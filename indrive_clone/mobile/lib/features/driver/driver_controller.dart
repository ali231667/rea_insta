import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../core/location/location_service.dart';
import '../../core/providers.dart';
import '../../core/realtime/socket_events.dart';
import '../../core/utils/geo.dart';
import '../../models/ride.dart';
import '../auth/session_controller.dart';

@immutable
class DriverState {
  const DriverState({
    this.online = false,
    this.switching = false,
    this.myPosition,
    this.heading,
    this.requests = const [],
    this.ride,
    this.passengerLocation,
    this.passengerTrend = Trend.still,
  });

  final bool online;
  final bool switching;
  final LatLng? myPosition;
  final double? heading;

  /// Order feed (nearest first).
  final List<DriverRequest> requests;

  /// Ride I am doing now.
  final Ride? ride;
  final LiveLocation? passengerLocation;

  /// Is the passenger walking to the pickup point?
  final Trend passengerTrend;

  DriverState copyWith({
    bool? online,
    bool? switching,
    LatLng? myPosition,
    double? heading,
    List<DriverRequest>? requests,
    Ride? ride,
    bool clearRide = false,
    LiveLocation? passengerLocation,
    Trend? passengerTrend,
  }) =>
      DriverState(
        online: online ?? this.online,
        switching: switching ?? this.switching,
        myPosition: myPosition ?? this.myPosition,
        heading: heading ?? this.heading,
        requests: requests ?? this.requests,
        ride: clearRide ? null : (ride ?? this.ride),
        passengerLocation: clearRide ? null : (passengerLocation ?? this.passengerLocation),
        passengerTrend: passengerTrend ?? this.passengerTrend,
      );
}

final driverProvider = NotifierProvider<DriverController, DriverState>(DriverController.new);

/// Driver side: online/offline, GPS sharing, order feed, offers and the active trip.
class DriverController extends Notifier<DriverState> {
  final _subs = <StreamSubscription<dynamic>>[];
  StreamSubscription<Position>? _gps;
  Timer? _heartbeat;
  Timer? _cleanup;
  final _tracker = ApproachTracker();

  @override
  DriverState build() {
    final socket = ref.watch(socketProvider);
    _subs
      ..add(socket.on(SocketEvents.rideRequest).listen(_onRequest))
      ..add(socket.on(SocketEvents.rideRequestUpdated).listen(_onRequestUpdated))
      ..add(socket.on(SocketEvents.rideRequestClosed).listen((d) => _removeRequest(d['rideId'] as String)))
      ..add(socket.on(SocketEvents.offerRejected).listen((d) => _setMyOfferStatus(d['rideId'] as String, 'rejected')))
      ..add(socket.on(SocketEvents.offerExpired).listen((d) => _setMyOfferStatus(d['rideId'] as String, 'expired')))
      ..add(socket.on(SocketEvents.rideUpdated).listen(_onRideUpdated))
      ..add(socket.on(SocketEvents.passengerLocationUpdate).listen(_onPassengerLocation))
      ..add(socket.on(SocketEvents.balanceUpdated).listen((d) {
        ref.read(sessionProvider.notifier).setBalance((d['balance'] as num).toInt());
      }));
    // Remove requests whose time is over.
    _cleanup = Timer.periodic(const Duration(seconds: 5), (_) {
      final now = DateTime.now();
      final left = state.requests.where((r) => r.expiresAt.isAfter(now)).toList();
      if (left.length != state.requests.length) state = state.copyWith(requests: left);
    });
    ref.onDispose(() {
      for (final s in _subs) {
        s.cancel();
      }
      _stopGps();
      _cleanup?.cancel();
    });
    return const DriverState();
  }

  /// Called when driver mode opens. Restores online state and an unfinished trip.
  Future<void> init() async {
    final profile = ref.read(sessionProvider).driver;
    try {
      final ride = await ref.read(rideRepositoryProvider).active(role: 'driver');
      if (ride != null) state = state.copyWith(ride: ride);
    } catch (_) {}
    if (profile?.isOnline == true || state.ride != null) {
      try {
        await _startGps();
        state = state.copyWith(online: profile?.isOnline == true);
        if (state.online) await refreshRequests();
      } catch (_) {}
    } else {
      try {
        final pos = await ref.read(locationServiceProvider).current();
        state = state.copyWith(myPosition: pos.latLng);
      } catch (_) {}
    }
  }

  Future<void> goOnline() async {
    state = state.copyWith(switching: true);
    try {
      final pos = await ref.read(locationServiceProvider).current();
      await ref.read(driverRepositoryProvider).setOnline(true, at: pos.latLng, heading: pos.heading);
      state = state.copyWith(online: true, myPosition: pos.latLng);
      _updateProfileOnline(true);
      await _startGps();
      await refreshRequests();
    } finally {
      state = state.copyWith(switching: false);
    }
  }

  Future<void> goOffline() async {
    state = state.copyWith(switching: true);
    try {
      await ref.read(driverRepositoryProvider).setOnline(false);
      state = state.copyWith(online: false, requests: const []);
      _updateProfileOnline(false);
      if (state.ride == null) _stopGps();
    } finally {
      state = state.copyWith(switching: false);
    }
  }

  void _updateProfileOnline(bool v) {
    final d = ref.read(sessionProvider).driver;
    if (d != null) ref.read(sessionProvider.notifier).updateDriver(d.copyWith(isOnline: v));
  }

  Future<void> refreshRequests() async {
    if (!state.online || state.ride != null) return;
    final list = await ref.read(driverRepositoryProvider).requests();
    state = state.copyWith(requests: list);
  }

  /* --------------------------- GPS sharing --------------------------- */

  Future<void> _startGps() async {
    if (_gps != null) return;
    await ref.read(locationServiceProvider).ensurePermission();
    _gps = ref.read(locationServiceProvider).stream(driverMode: true).listen((p) {
      state = state.copyWith(myPosition: p.latLng, heading: p.heading);
      _send(p);
    }, onError: (_) {});
    // Send position at least every 10 s even when standing still (server marks old GPS as offline).
    _heartbeat = Timer.periodic(const Duration(seconds: 10), (_) {
      final me = state.myPosition;
      if (me != null) {
        ref.read(socketProvider).emit(SocketEvents.driverLocation, {'lat': me.latitude, 'lng': me.longitude, 'heading': state.heading});
      }
    });
  }

  DateTime _lastSent = DateTime(2000);
  void _send(Position p) {
    if (DateTime.now().difference(_lastSent) < const Duration(seconds: 2)) return;
    _lastSent = DateTime.now();
    ref.read(socketProvider).emit(SocketEvents.driverLocation, {
      'lat': p.latitude,
      'lng': p.longitude,
      'heading': p.heading,
      'speed': p.speed,
    });
  }

  void _stopGps() {
    _gps?.cancel();
    _gps = null;
    _heartbeat?.cancel();
    _heartbeat = null;
  }

  /* ------------------------------ Orders ------------------------------ */

  void _onRequest(Map<String, dynamic> data) {
    if (!state.online || state.ride != null) return;
    final r = DriverRequest.fromJson(data);
    final list = [r, ...state.requests.where((x) => x.rideId != r.rideId)];
    list.sort((a, b) => (a.pickupDistanceM ?? 0).compareTo(b.pickupDistanceM ?? 0));
    state = state.copyWith(requests: list);
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
  }

  void _onRequestUpdated(Map<String, dynamic> data) {
    final id = data['rideId'] as String;
    final fare = (data['offeredFare'] as num).toInt();
    state = state.copyWith(requests: [
      for (final r in state.requests) r.rideId == id ? r.copyWith(offeredFare: fare) : r,
    ]);
  }

  void _removeRequest(String rideId) =>
      state = state.copyWith(requests: state.requests.where((r) => r.rideId != rideId).toList());

  void _setMyOfferStatus(String rideId, String status) {
    state = state.copyWith(requests: [
      for (final r in state.requests)
        r.rideId == rideId && r.myOffer != null ? r.copyWith(myOffer: r.myOffer!.copyWith(status: status)) : r,
    ]);
  }

  void skip(String rideId) => _removeRequest(rideId);

  Future<void> makeOffer(DriverRequest r, int price) async {
    final o = await ref.read(rideRepositoryProvider).makeOffer(r.rideId, price);
    state = state.copyWith(requests: [
      for (final x in state.requests) x.rideId == r.rideId ? x.copyWith(myOffer: MyOffer(id: o.id, price: o.price, status: o.status)) : x,
    ]);
  }

  /* ------------------------------ Trip ------------------------------ */

  void _onRideUpdated(Map<String, dynamic> data) {
    final ride = Ride.fromJson(data);
    final me = ref.read(sessionProvider).user?.id;
    if (ride.driver?.id != me) return;
    if (ride.status == RideStatus.accepted && state.ride?.id != ride.id) {
      // Passenger chose me!
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.alert);
      _tracker.reset();
      state = state.copyWith(ride: ride, requests: const []);
      return;
    }
    if (state.ride?.id == ride.id) state = state.copyWith(ride: ride);
  }

  void _onPassengerLocation(Map<String, dynamic> data) {
    final loc = LiveLocation.fromJson(data);
    if (state.ride?.id != loc.rideId) return;
    final d = loc.distanceToPickupM?.toDouble();
    state = state.copyWith(passengerLocation: loc, passengerTrend: d == null ? Trend.still : _tracker.add(d));
  }

  Future<void> arrived() async => state = state.copyWith(ride: await ref.read(rideRepositoryProvider).arrived(state.ride!.id));
  Future<void> startTrip() async => state = state.copyWith(ride: await ref.read(rideRepositoryProvider).start(state.ride!.id));
  Future<void> completeTrip() async => state = state.copyWith(ride: await ref.read(rideRepositoryProvider).complete(state.ride!.id));
  Future<void> cancelTrip(String reason) async =>
      state = state.copyWith(ride: await ref.read(rideRepositoryProvider).cancel(state.ride!.id, reason));

  Future<void> ratePassenger(int stars, String? review) => ref.read(rideRepositoryProvider).rate(state.ride!.id, stars, review);

  /// Back to the order feed after the trip.
  Future<void> closeTrip() async {
    state = state.copyWith(clearRide: true);
    if (!state.online) _stopGps();
    try {
      await refreshRequests();
    } catch (_) {}
  }
}
