import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../core/utils/geo.dart';
import '../../models/ride.dart';
import '../../widgets/app_map.dart';
import '../../widgets/common.dart';
import '../../widgets/map_markers.dart';
import '../common/ride_sheets.dart';
import '../passenger/order_sheets.dart';
import 'driver_controller.dart';

/// Driver trip screen: go to pickup -> "I have arrived" -> "Start trip" -> "Finish trip".
class DriverRideScreen extends ConsumerStatefulWidget {
  const DriverRideScreen({super.key});

  @override
  ConsumerState<DriverRideScreen> createState() => _DriverRideScreenState();
}

class _DriverRideScreenState extends ConsumerState<DriverRideScreen> {
  final _map = MapController();
  Timer? _tick;
  List<LatLng> _route = [];
  LatLng? _routeFrom;
  String? _routeFor;
  bool _follow = true;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    Future.microtask(() {
      if (ref.read(driverProvider).ride == null && mounted) context.go('/driver');
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  /// Road route from my position to the current target (pickup or destination). Updated when I move 150 m.
  Future<void> _updateRoute(Ride r, LatLng? me) async {
    if (me == null) return;
    final target = r.status == RideStatus.inProgress ? r.dropoff.latLng : r.pickup.latLng;
    final key = '${r.id}-${r.status == RideStatus.inProgress}';
    if (_routeFor == key && _routeFrom != null && metersBetween(_routeFrom!, me) < 150) return;
    _routeFor = key;
    _routeFrom = me;
    if (r.status == RideStatus.inProgress && r.routePolyline != null && _route.isEmpty) {
      setState(() => _route = decodePolyline(r.routePolyline));
    }
    try {
      final info = await ref.read(mapsRepositoryProvider).route(me, target);
      if (mounted) setState(() => _route = decodePolyline(info.polyline));
    } catch (_) {}
  }

  /// Opens Google Maps (or another app) for turn-by-turn navigation.
  Future<void> _navigate(LatLng to) async {
    final google = Uri.parse('google.navigation:q=${to.latitude},${to.longitude}&mode=d');
    if (!await launchUrl(google)) {
      await launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${to.latitude},${to.longitude}&travelmode=driving'),
          mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _finished(Ride r) async {
    final stars = await showDialog<int>(context: context, barrierDismissible: false, builder: (_) => _TripDoneDialog(ride: r));
    if (stars != null && stars > 0) {
      try {
        await ref.read(driverProvider.notifier).ratePassenger(stars, null);
      } catch (_) {}
    }
    await ref.read(driverProvider.notifier).closeTrip();
    if (mounted) context.go('/driver');
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(driverProvider);
    final r = s.ride;

    ref.listen(driverProvider.select((x) => x.ride?.status), (prev, next) {
      final ride = ref.read(driverProvider).ride;
      if (ride == null) return;
      if (next == RideStatus.completed && prev != next) _finished(ride);
      if (next == RideStatus.cancelled && prev != next) {
        showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(ride.cancelledBy == 'passenger' ? 'Passenger cancelled the ride' : 'Ride cancelled'),
            content: Text(ride.cancelReason ?? ''),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
        ).then((_) async {
          await ref.read(driverProvider.notifier).closeTrip();
          if (context.mounted) context.go('/driver');
        });
      }
    });

    if (r == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateRoute(r, s.myPosition);
    });
    if (_follow && s.myPosition != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          _map.move(s.myPosition!, _map.camera.zoom < 14 ? 16 : _map.camera.zoom);
        } catch (_) {}
      });
    }

    final p = s.passengerLocation;
    final target = r.status == RideStatus.inProgress ? r.dropoff : r.pickup;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(children: [
          Positioned.fill(
            child: AppMap(
              controller: _map,
              initialCenter: s.myPosition ?? r.pickup.latLng,
              initialZoom: 16,
              onPositionChanged: (_, gesture) {
                if (gesture && _follow) setState(() => _follow = false);
              },
              layers: [
                if (_route.isNotEmpty) PolylineLayer(polylines: [routeLine(_route)]),
                MarkerLayer(markers: [
                  if (r.status != RideStatus.inProgress) pickupMarker(r.pickup.latLng),
                  dropoffMarker(r.dropoff.latLng),
                  if (p != null && r.status != RideStatus.inProgress) personMarker(p.latLng),
                  if (s.myPosition != null) carMarker(s.myPosition!, heading: s.heading, vehicleType: r.vehicleType),
                ]),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                MapCircleButton(icon: Icons.shield_outlined, onTap: () => showSafetySheet(context, ref, r, myPosition: s.myPosition)),
                const Spacer(),
                if (!_follow) MapCircleButton(icon: Icons.navigation, onTap: () => setState(() => _follow = true)),
                const SizedBox(width: 8),
                FloatingActionButton.extended(
                  heroTag: 'nav',
                  backgroundColor: AppColors.black,
                  foregroundColor: Colors.white,
                  onPressed: () => _navigate(target.latLng),
                  icon: const Icon(Icons.turn_right),
                  label: const Text('Navigate'),
                ),
              ]),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: _DriverTripPanel(ride: r)),
        ]),
      ),
    );
  }
}

class _DriverTripPanel extends ConsumerWidget {
  const _DriverTripPanel({required this.ride});
  final Ride ride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(driverProvider);
    final n = ref.read(driverProvider.notifier);
    final pax = ride.passenger;
    final me = s.myPosition;

    final String title;
    final String? subtitle;
    switch (ride.status) {
      case RideStatus.accepted:
        title = 'Go to pickup';
        subtitle = me == null ? null : '${distanceText(metersBetween(me, ride.pickup.latLng))} · ${ride.pickup.address}';
      case RideStatus.arrived:
        final waited = DateTime.now().difference(ride.arrivedAt ?? DateTime.now());
        title = 'Waiting for passenger';
        subtitle = '${waited.inMinutes}:${(waited.inSeconds % 60).toString().padLeft(2, '0')} min waited';
      default:
        title = 'Drive to destination';
        subtitle = me == null ? ride.dropoff.address : '${distanceText(metersBetween(me, ride.dropoff.latLng))} · ${ride.dropoff.address}';
    }

    // Is the passenger walking to the pickup point?
    String? paxInfo;
    Color paxColor = AppColors.grey;
    final pl = s.passengerLocation;
    if (pl?.distanceToPickupM != null && ride.status != RideStatus.inProgress) {
      final d = pl!.distanceToPickupM!;
      if (d < 30) {
        (paxInfo, paxColor) = ('Passenger is at the pickup point', AppColors.green);
      } else {
        (paxInfo, paxColor) = switch (s.passengerTrend) {
          Trend.closer => ('Passenger is walking to the pickup point (${distanceText(d)})', AppColors.green),
          Trend.away => ('Passenger is moving away from the pickup point (${distanceText(d)})', AppColors.red),
          Trend.still => ('Passenger is ${distanceText(d)} from the pickup point', AppColors.grey),
        };
      }
    }

    return Material(
      elevation: 12,
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            if (subtitle != null) Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.grey)),
            if (paxInfo != null) ...[
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.directions_walk, color: paxColor, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(paxInfo, style: TextStyle(color: paxColor, fontWeight: FontWeight.w600))),
              ]),
            ],
            const SizedBox(height: 12),
            Row(children: [
              UserAvatar(url: pax?.photoUrl, name: pax?.name),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(pax?.name ?? 'Passenger', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  if (pax != null) RatingBadge(rating: pax.rating, count: pax.ratingCount),
                ]),
              ),
              Text(pkr(ride.price), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(width: 8),
              IconButton.filledTonal(onPressed: () => callPhone(pax?.phone), icon: const Icon(Icons.call)),
              IconButton.filledTonal(onPressed: () => context.push('/chat/${ride.id}'), icon: const Icon(Icons.chat_bubble_outline)),
            ]),
            if (ride.comment != null || detailLines(ride.details).isNotEmpty) ...[
              const SizedBox(height: 8),
              for (final l in [if (ride.comment != null) '💬 ${ride.comment}', ...detailLines(ride.details)])
                Text(l, style: const TextStyle(color: AppColors.grey)),
            ],
            const SizedBox(height: 12),
            switch (ride.status) {
              RideStatus.accepted => LoadingButton(label: tr('I have arrived'), icon: Icons.place, onPressed: n.arrived),
              RideStatus.arrived => LoadingButton(label: tr('Start trip'), icon: Icons.play_arrow, onPressed: n.startTrip),
              RideStatus.inProgress => LoadingButton(
                  label: tr('Finish trip'),
                  icon: Icons.flag,
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Finish the trip?'),
                        content: Text('Collect ${pkr(ride.price)} in cash from the passenger.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr('No'))),
                          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(tr('Yes'))),
                        ],
                      ),
                    );
                    if (ok == true) await n.completeTrip();
                  },
                ),
              _ => const SizedBox.shrink(),
            },
            if (ride.status != RideStatus.inProgress)
              TextButton(
                style: TextButton.styleFrom(foregroundColor: AppColors.red),
                onPressed: () async {
                  final reason = await askCancelReason(context, driver: true);
                  if (reason == null) return;
                  try {
                    await n.cancelTrip(reason);
                  } catch (e) {
                    if (context.mounted) showError(context, e);
                  }
                },
                child: Text(tr('Cancel')),
              ),
          ]),
        ),
      ),
    );
  }
}

/// Shown when the trip is finished: fare, commission, rate the passenger.
class _TripDoneDialog extends StatefulWidget {
  const _TripDoneDialog({required this.ride});
  final Ride ride;

  @override
  State<_TripDoneDialog> createState() => _TripDoneDialogState();
}

class _TripDoneDialogState extends State<_TripDoneDialog> {
  int _stars = 5;

  @override
  Widget build(BuildContext context) {
    final r = widget.ride;
    return AlertDialog(
      title: const Text('Trip completed 🎉'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Collect in cash: ${pkr(r.price)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        if (r.commission != null) Text('Service commission: ${pkr(r.commission)}', style: const TextStyle(color: AppColors.grey)),
        const SizedBox(height: 16),
        const Text('Rate the passenger'),
        StarInput(value: _stars, size: 34, onChanged: (v) => setState(() => _stars = v)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, 0), child: const Text('Skip')),
        FilledButton(onPressed: () => Navigator.pop(context, _stars), child: Text(tr('Done'))),
      ],
    );
  }
}
