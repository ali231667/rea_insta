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
import '../../models/misc.dart';
import '../../models/ride.dart';
import '../auth/session_controller.dart';

@immutable
class PassengerState {
  const PassengerState({
    this.myPosition,
    this.pickup,
    this.dropoff,
    this.serviceType = 'city',
    this.vehicleType = 'mini',
    this.estimate,
    this.estimating = false,
    this.offeredFare,
    this.comment = '',
    this.details = const RideDetails(),
    this.ride,
    this.driverLocation,
    this.driversNotified = 0,
    this.myTrend = Trend.still,
    this.myDistanceToPickupM,
    this.locationFailed = false,
  });

  /// GPS is off / not allowed: the user moves the map pin to choose the pickup.
  final bool locationFailed;
  final LatLng? myPosition;
  final Place? pickup;
  final Place? dropoff;
  final String serviceType;
  final String vehicleType;
  final FareEstimate? estimate;
  final bool estimating;
  final int? offeredFare;
  final String comment;
  final RideDetails details;

  /// Current active (or just finished) ride.
  final Ride? ride;
  final LiveLocation? driverLocation;
  final int driversNotified;

  /// Is the passenger walking towards the pickup point?
  final Trend myTrend;
  final int? myDistanceToPickupM;

  FareOption? get selectedOption {
    final opts = estimate?.options ?? const <FareOption>[];
    for (final o in opts) {
      if (o.vehicleType == vehicleType) return o;
    }
    return opts.isEmpty ? null : opts.first;
  }

  /// Offers that are still valid, cheapest first.
  List<Offer> get liveOffers {
    final now = DateTime.now();
    final list = (ride?.offers ?? const <Offer>[]).where((o) => o.status == 'pending' && o.expiresAt.isAfter(now)).toList();
    list.sort((a, b) => a.price.compareTo(b.price));
    return list;
  }

  PassengerState copyWith({
    LatLng? myPosition,
    Place? pickup,
    Place? dropoff,
    bool clearDropoff = false,
    String? serviceType,
    String? vehicleType,
    FareEstimate? estimate,
    bool clearEstimate = false,
    bool? estimating,
    int? offeredFare,
    String? comment,
    RideDetails? details,
    Ride? ride,
    bool clearRide = false,
    LiveLocation? driverLocation,
    bool clearDriverLocation = false,
    int? driversNotified,
    Trend? myTrend,
    int? myDistanceToPickupM,
    bool? locationFailed,
  }) =>
      PassengerState(
        myPosition: myPosition ?? this.myPosition,
        pickup: pickup ?? this.pickup,
        dropoff: clearDropoff ? null : (dropoff ?? this.dropoff),
        serviceType: serviceType ?? this.serviceType,
        vehicleType: vehicleType ?? this.vehicleType,
        estimate: clearEstimate ? null : (estimate ?? this.estimate),
        estimating: estimating ?? this.estimating,
        offeredFare: clearEstimate ? null : (offeredFare ?? this.offeredFare),
        comment: comment ?? this.comment,
        details: details ?? this.details,
        ride: clearRide ? null : (ride ?? this.ride),
        driverLocation: clearDriverLocation || clearRide ? null : (driverLocation ?? this.driverLocation),
        driversNotified: driversNotified ?? this.driversNotified,
        myTrend: myTrend ?? this.myTrend,
        myDistanceToPickupM: myDistanceToPickupM ?? this.myDistanceToPickupM,
        locationFailed: locationFailed ?? this.locationFailed,
      );
}

final passengerProvider = NotifierProvider<PassengerController, PassengerState>(PassengerController.new);

/// Everything the passenger does: choose addresses, offer a price, pick a driver, track the ride.
class PassengerController extends Notifier<PassengerState> {
  final _subs = <StreamSubscription<dynamic>>[];
  StreamSubscription<Position>? _gps;
  final _tracker = ApproachTracker();
  DateTime _lastShare = DateTime(2000);

  @override
  PassengerState build() {
    final socket = ref.watch(socketProvider);
    _subs
      ..add(socket.on(SocketEvents.rideUpdated).listen(_onRideUpdated))
      ..add(socket.on(SocketEvents.offerNew).listen(_onOfferNew))
      ..add(socket.on(SocketEvents.offerUpdated).listen(_onOfferUpdated))
      ..add(socket.on(SocketEvents.searchProgress).listen(_onSearchProgress))
      ..add(socket.on(SocketEvents.driverLocationUpdate).listen(_onDriverLocation));
    ref.onDispose(() {
      for (final s in _subs) {
        s.cancel();
      }
      _gps?.cancel();
    });
    return const PassengerState();
  }

  /* ------------------------------ Setup ------------------------------ */

  /// Called when the home screen opens: find my location and restore an unfinished ride.
  Future<void> init() async {
    try {
      final pos = await ref.read(locationServiceProvider).current();
      state = state.copyWith(myPosition: pos.latLng, locationFailed: false);
      if (state.pickup == null) await setPickupFromMap(pos.latLng);
    } catch (_) {
      state = state.copyWith(locationFailed: true);
    }
    await restoreActiveRide();
  }

  Future<void> restoreActiveRide() async {
    try {
      final ride = await ref.read(rideRepositoryProvider).active(role: 'passenger');
      if (ride != null) _setRide(ride);
    } catch (_) {}
  }

  Future<void> setPickupFromMap(LatLng p) async {
    state = state.copyWith(pickup: Place(name: 'Pinned location', address: '', lat: p.latitude, lng: p.longitude));
    try {
      final place = await ref.read(mapsRepositoryProvider).reverse(p);
      state = state.copyWith(pickup: place);
    } catch (_) {}
    if (state.dropoff != null) await loadEstimate();
  }

  Future<void> setPickup(Place p) async {
    state = state.copyWith(pickup: p);
    if (state.dropoff != null) await loadEstimate();
  }

  Future<void> setDropoff(Place p) async {
    state = state.copyWith(dropoff: p);
    await loadEstimate();
  }

  void clearDropoff() => state = state.copyWith(clearDropoff: true, clearEstimate: true);

  Future<void> setService(String type) async {
    final allowed = {
      'city': ['moto', 'rickshaw', 'mini', 'ac', 'comfort'],
      'intercity': ['mini', 'ac', 'comfort'],
      'courier': ['moto', 'mini'],
      'freight': ['loader', 'truck'],
    }[type]!;
    state = state.copyWith(
      serviceType: type,
      vehicleType: allowed.contains(state.vehicleType) ? state.vehicleType : allowed.first,
      details: const RideDetails(),
    );
    if (state.pickup != null && state.dropoff != null) await loadEstimate();
  }

  void setVehicle(String type) {
    state = state.copyWith(vehicleType: type);
    final o = state.selectedOption;
    if (o != null) state = state.copyWith(offeredFare: o.recommendedFare);
  }

  void setFare(int fare) => state = state.copyWith(offeredFare: fare);
  void setComment(String c) => state = state.copyWith(comment: c);
  void setDetails(RideDetails d) => state = state.copyWith(details: d);

  /// Ask the server for route + recommended price for every vehicle.
  Future<void> loadEstimate() async {
    final p = state.pickup, d = state.dropoff;
    if (p == null || d == null) return;
    state = state.copyWith(estimating: true);
    try {
      final e = await ref.read(rideRepositoryProvider).estimate(serviceType: state.serviceType, pickup: p.latLng, dropoff: d.latLng);
      state = state.copyWith(estimate: e, estimating: false);
      final o = state.selectedOption;
      if (o != null) state = state.copyWith(offeredFare: o.recommendedFare, vehicleType: o.vehicleType);
    } catch (e) {
      state = state.copyWith(estimating: false);
      rethrow;
    }
  }

  /* ------------------------------ Order ------------------------------ */

  Future<void> createRide() async {
    final p = state.pickup, d = state.dropoff, fare = state.offeredFare;
    if (p == null || d == null || fare == null) throw StateError('Choose pickup, destination and price');
    final ride = await ref.read(rideRepositoryProvider).create(
          serviceType: state.serviceType,
          vehicleType: state.vehicleType,
          pickup: p,
          dropoff: d,
          offeredFare: fare,
          comment: state.comment,
          details: state.details,
        );
    state = state.copyWith(driversNotified: 0);
    _setRide(ride);
  }

  Future<void> raiseFare(int newFare) async {
    final r = state.ride;
    if (r == null) return;
    _setRide(await ref.read(rideRepositoryProvider).raiseFare(r.id, newFare));
  }

  Future<void> acceptOffer(Offer o) async {
    _setRide(await ref.read(rideRepositoryProvider).acceptOffer(o.rideId, o.id));
  }

  Future<void> declineOffer(Offer o) async {
    _removeOffer(o.id);
    await ref.read(rideRepositoryProvider).declineOffer(o.rideId, o.id);
  }

  Future<void> cancel(String reason) async {
    final r = state.ride;
    if (r == null) return;
    _setRide(await ref.read(rideRepositoryProvider).cancel(r.id, reason));
  }

  Future<void> rate(int stars, String? review) async {
    final r = state.ride;
    if (r == null) return;
    await ref.read(rideRepositoryProvider).rate(r.id, stars, review);
  }

  /// After the ride is finished (rated / closed): back to a clean home screen.
  void closeRide() {
    _stopSharing();
    state = state.copyWith(clearRide: true, clearDropoff: true, clearEstimate: true, comment: '', details: const RideDetails());
  }

  /// "Order again" after a cancelled/expired request: keep addresses and price.
  void clearRideKeepDraft() {
    _stopSharing();
    final r = state.ride;
    if (r == null) return;
    state = state.copyWith(
      clearRide: true,
      pickup: Place(name: r.pickup.address, address: r.pickup.address, lat: r.pickup.lat, lng: r.pickup.lng),
      dropoff: Place(name: r.dropoff.address, address: r.dropoff.address, lat: r.dropoff.lat, lng: r.dropoff.lng),
      serviceType: r.serviceType,
      vehicleType: r.vehicleType,
      offeredFare: r.offeredFare,
      comment: r.comment ?? '',
      details: r.details,
    );
  }

  /* ------------------------------ Realtime ------------------------------ */

  void _setRide(Ride ride) {
    final old = state.ride;
    // Keep offers we got by socket if the server copy has none (e.g. after raise fare)
    state = state.copyWith(ride: ride);
    if (ride.isAssigned) {
      _startSharing();
    } else {
      _stopSharing();
    }
    if (old != null && old.status != ride.status) {
      HapticFeedback.mediumImpact();
      if (ride.status == RideStatus.arrived) SystemSound.play(SystemSoundType.alert);
    }
  }

  void _onRideUpdated(Map<String, dynamic> data) {
    final ride = Ride.fromJson(data);
    final mine = ref.read(sessionProvider).user?.id;
    if (ride.passenger?.id != mine) return; // this event is for me as a driver
    if (state.ride == null || state.ride!.id == ride.id || ride.isActive) _setRide(ride);
  }

  void _onOfferNew(Map<String, dynamic> data) {
    final o = Offer.fromJson(data);
    final r = state.ride;
    if (r == null || r.id != o.rideId) return;
    final offers = [...r.offers.where((x) => x.id != o.id && x.driver?.id != o.driver?.id), o];
    state = state.copyWith(ride: r.copyWith(offers: offers));
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
  }

  void _onOfferUpdated(Map<String, dynamic> data) => _removeOffer(data['offerId'] as String);

  void _removeOffer(String id) {
    final r = state.ride;
    if (r == null) return;
    state = state.copyWith(ride: r.copyWith(offers: r.offers.where((o) => o.id != id).toList()));
  }

  void _onSearchProgress(Map<String, dynamic> data) {
    final r = state.ride;
    if (r == null || r.id != data['rideId']) return;
    state = state.copyWith(
      ride: r.copyWith(searchRadiusM: (data['radiusM'] as num).toInt()),
      driversNotified: (data['driversNotified'] as num).toInt(),
    );
  }

  void _onDriverLocation(Map<String, dynamic> data) {
    final loc = LiveLocation.fromJson(data);
    if (state.ride?.id != loc.rideId) return;
    state = state.copyWith(driverLocation: loc);
  }

  /// During an assigned ride we share the passenger GPS with the driver (like InDrive),
  /// and check if the passenger is walking towards the pickup point.
  void _startSharing() {
    if (_gps != null) return;
    _tracker.reset();
    _gps = ref.read(locationServiceProvider).stream().listen((pos) {
      final me = pos.latLng;
      final r = state.ride;
      if (r == null) return;
      final d = metersBetween(me, r.pickup.latLng);
      state = state.copyWith(myPosition: me, myTrend: _tracker.add(d), myDistanceToPickupM: d.round());
      if (DateTime.now().difference(_lastShare) > const Duration(seconds: 3) && r.status != RideStatus.inProgress) {
        _lastShare = DateTime.now();
        ref.read(socketProvider).emit(SocketEvents.passengerLocation, {
          'lat': me.latitude,
          'lng': me.longitude,
          'heading': pos.heading,
        });
      }
    }, onError: (_) {});
  }

  void _stopSharing() {
    _gps?.cancel();
    _gps = null;
  }
}
