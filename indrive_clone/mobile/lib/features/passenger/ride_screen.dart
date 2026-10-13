import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../core/utils/geo.dart';
import '../../core/utils/vehicles.dart';
import '../../models/ride.dart';
import '../../widgets/app_map.dart';
import '../../widgets/common.dart';
import '../../widgets/map_markers.dart';
import '../common/ride_sheets.dart';
import 'order_sheets.dart';
import 'passenger_controller.dart';

/// Passenger active ride: searching (offers) -> driver coming -> arrived -> on trip.
class PassengerRideScreen extends ConsumerStatefulWidget {
  const PassengerRideScreen({super.key});

  @override
  ConsumerState<PassengerRideScreen> createState() => _PassengerRideScreenState();
}

class _PassengerRideScreenState extends ConsumerState<PassengerRideScreen> {
  final _map = MapController();
  final _panelKey = GlobalKey();
  Timer? _tick;

  /// The user moved the map by hand: stop moving the camera for them until they tap "center".
  bool _userMovedMap = false;
  DateTime _lastAutoFit = DateTime(2000);

  /// Road route from the driver's car to the pickup point (refreshed when the car moves).
  List<LatLng> _carRoute = const [];
  LatLng? _carRouteFrom;

  @override
  void initState() {
    super.initState();
    // Re-draw every second for countdowns (offer timers, waiting time).
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    Future.microtask(() async {
      if (ref.read(passengerProvider).ride == null) await ref.read(passengerProvider.notifier).restoreActiveRide();
      if (mounted && ref.read(passengerProvider).ride == null) context.go('/home');
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  double get _panelHeight => _panelKey.currentContext?.size?.height ?? 380;

  /// Show pickup, car and (when useful) destination above the bottom panel.
  void _fit({bool force = false}) {
    final s = ref.read(passengerProvider);
    final r = s.ride;
    if (r == null || (_userMovedMap && !force)) return;
    final car = s.driverLocation;
    final pts = <LatLng>[
      if (r.status != RideStatus.inProgress) r.pickup.latLng,
      if (r.status == RideStatus.inProgress || r.status == RideStatus.searching) r.dropoff.latLng,
      if (car != null) car.latLng,
    ];
    _lastAutoFit = DateTime.now();
    fitPoints(_map, pts, padding: EdgeInsets.fromLTRB(50, 100, 50, _panelHeight + 30));
  }

  void _fitAfterFrame({bool force = false}) => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fit(force: force);
      });

  Future<void> _updateCarRoute(Ride r, LatLng car) async {
    if (r.status != RideStatus.accepted) return;
    if (_carRouteFrom != null && metersBetween(_carRouteFrom!, car) < 150) return;
    _carRouteFrom = car;
    try {
      final info = await ref.read(mapsRepositoryProvider).route(car, r.pickup.latLng);
      if (mounted) setState(() => _carRoute = decodePolyline(info.polyline));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(passengerProvider);
    final ride = s.ride;

    ref.listen(passengerProvider.select((x) => x.ride?.status), (prev, next) {
      final r = ref.read(passengerProvider).ride;
      if (r == null) return;
      if (next == RideStatus.completed) context.go('/rate/${r.id}');
      if (prev != next) {
        _userMovedMap = false;
        _carRoute = const [];
        _carRouteFrom = null;
        _fitAfterFrame();
        if (next == RideStatus.accepted) showMessage(context, 'Driver accepted! ${r.driver?.name} is coming.');
        if (next == RideStatus.arrived) showMessage(context, tr('Driver has arrived'));
      }
    });
    // The car moved: keep it on screen (not too often, so the map does not shake).
    ref.listen(passengerProvider.select((x) => x.driverLocation), (prev, next) {
      final r = ref.read(passengerProvider).ride;
      if (next == null || r == null) return;
      _updateCarRoute(r, next.latLng);
      if (prev == null || DateTime.now().difference(_lastAutoFit) > const Duration(seconds: 5)) _fit();
    });

    if (ride == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final route = decodePolyline(ride.routePolyline);
    final car = s.driverLocation;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(children: [
          Positioned.fill(
            child: AppMap(
              controller: _map,
              initialCenter: ride.pickup.latLng,
              onMapReady: _fitAfterFrame,
              onPositionChanged: (_, gesture) {
                if (gesture) _userMovedMap = true;
              },
              layers: [
                if (ride.status == RideStatus.searching)
                  CircleLayer(circles: [
                    CircleMarker(
                      point: ride.pickup.latLng,
                      radius: ride.searchRadiusM.toDouble(),
                      useRadiusInMeter: true,
                      color: AppColors.lime.withValues(alpha: 0.15),
                      borderColor: AppColors.limeDark,
                      borderStrokeWidth: 2,
                    ),
                  ]),
                if (route.isNotEmpty && ride.status != RideStatus.accepted) PolylineLayer(polylines: [routeLine(route)]),
                if (car != null && ride.status == RideStatus.accepted)
                  PolylineLayer(polylines: [
                    _carRoute.length > 1 ? routeLine(_carRoute) : routeLine([car.latLng, ride.pickup.latLng], dashed: true),
                  ]),
                MarkerLayer(markers: [
                  if (s.myPosition != null && ride.status != RideStatus.inProgress) personMarker(s.myPosition!),
                  pickupMarker(ride.pickup.latLng),
                  dropoffMarker(ride.dropoff.latLng),
                  if (car != null) carMarker(car.latLng, heading: car.heading, vehicleType: ride.vehicleType),
                ]),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                if (ride.isAssigned)
                  MapCircleButton(icon: Icons.shield_outlined, tooltip: tr('Safety'), onTap: () => showSafetySheet(context, ref, ride, myPosition: s.myPosition)),
                const Spacer(),
                MapCircleButton(
                  icon: Icons.center_focus_strong,
                  onTap: () {
                    _userMovedMap = false;
                    _fit(force: true);
                  },
                ),
              ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: KeyedSubtree(
              key: _panelKey,
              child: switch (ride.status) {
                RideStatus.searching => _SearchingPanel(ride: ride),
                RideStatus.accepted || RideStatus.arrived || RideStatus.inProgress => _TripPanel(ride: ride),
                _ => _ClosedPanel(ride: ride),
              },
            ),
          ),
        ]),
      ),
    );
  }
}

Widget _panel(BuildContext context, List<Widget> children) => Material(
      elevation: 12,
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.66),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
          ),
        ),
      ),
    );

/* -------------------------------- Searching -------------------------------- */

class _SearchingPanel extends ConsumerWidget {
  const _SearchingPanel({required this.ride});
  final Ride ride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(passengerProvider);
    final offers = s.liveOffers;
    final left = ride.expiresAt.difference(DateTime.now());
    final n = ref.read(passengerProvider.notifier);

    return _panel(context, [
      Row(children: [
        const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(offers.isEmpty ? tr('Looking for drivers') : '${offers.length} offer(s)',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text(
              'Search area ${distanceText(ride.searchRadiusM)} · ${s.driversNotified} driver(s) saw your request',
              style: const TextStyle(color: AppColors.grey, fontSize: 13),
            ),
          ]),
        ),
        Text('${left.inMinutes}:${(left.inSeconds % 60).toString().padLeft(2, '0')}', style: const TextStyle(color: AppColors.grey)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Pill(vehicleInfo(ride.vehicleType).label, color: AppColors.greyLight),
        const SizedBox(width: 6),
        Pill(pkr(ride.offeredFare)),
        const Spacer(),
        Text(distanceText(ride.distanceM), style: const TextStyle(color: AppColors.grey)),
      ]),
      const SizedBox(height: 12),
      for (final o in offers) _OfferCard(offer: o),
      if (offers.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Drivers near you are looking at your request. If nobody answers, raise your fare.',
              style: TextStyle(color: AppColors.grey)),
        ),
      const SizedBox(height: 8),
      Text(tr('Raise fare'), style: const TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Row(children: [
        for (final add in [20, 50, 100])
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: OutlinedButton(
                onPressed: () => n.raiseFare(ride.offeredFare + add).catchError((Object e) {
                  if (context.mounted) showError(context, e);
                }),
                child: Text('+$add'),
              ),
            ),
          ),
      ]),
      const SizedBox(height: 8),
      TextButton(
        style: TextButton.styleFrom(foregroundColor: AppColors.red),
        onPressed: () async {
          final reason = await askCancelReason(context, driver: false);
          if (reason == null) return;
          try {
            await n.cancel(reason);
          } catch (e) {
            if (context.mounted) showError(context, e);
          }
        },
        child: Text(tr('Cancel request')),
      ),
    ]);
  }
}

/// One driver offer: photo, rating, car, ETA, price, timer, Accept / Decline.
class _OfferCard extends ConsumerWidget {
  const _OfferCard({required this.offer});
  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = offer.driver;
    final total = offer.expiresAt.difference(offer.createdAt).inMilliseconds;
    final left = offer.expiresAt.difference(DateTime.now()).inMilliseconds;
    final progress = total <= 0 ? 0.0 : (left / total).clamp(0.0, 1.0);
    final n = ref.read(passengerProvider.notifier);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Theme.of(context).dividerColor)),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        LinearProgressIndicator(value: progress, minHeight: 3, color: AppColors.limeDark, backgroundColor: Colors.transparent),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Row(children: [
              UserAvatar(url: d?.photoUrl, name: d?.name, radius: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(d?.name ?? 'Driver', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  if (d != null)
                    Row(children: [
                      RatingBadge(rating: d.rating, size: 13),
                      Text('  ${d.tripsCount} trips', style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                    ]),
                  if (d != null) Text(d.vehicle.title, style: const TextStyle(color: AppColors.grey, fontSize: 13)),
                ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(pkr(offer.price), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                Text('${durationText(offer.etaSec)} · ${distanceText(offer.distanceM)}', style: const TextStyle(color: AppColors.grey, fontSize: 12)),
              ]),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => n.declineOffer(offer).catchError((_) {}),
                  child: Text(tr('Decline')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: LoadingButton(label: tr('Accept'), onPressed: () => n.acceptOffer(offer))),
            ]),
          ]),
        ),
      ]),
    );
  }
}

/* -------------------------------- On the trip -------------------------------- */

class _TripPanel extends ConsumerWidget {
  const _TripPanel({required this.ride});
  final Ride ride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(passengerProvider);
    final d = ride.driver;
    final car = s.driverLocation;

    final String title;
    String? subtitle;
    switch (ride.status) {
      case RideStatus.accepted:
        title = car?.etaSec != null ? '${tr('Driver is on the way')} · ${durationText(car!.etaSec)}' : tr('Driver is on the way');
        subtitle = car?.distanceM != null ? '${distanceText(car!.distanceM)} away' : null;
      case RideStatus.arrived:
        final waited = DateTime.now().difference(ride.arrivedAt ?? DateTime.now());
        title = tr('Driver has arrived');
        subtitle = 'Waiting ${waited.inMinutes}:${(waited.inSeconds % 60).toString().padLeft(2, '0')} · first 5 min are free';
      default:
        title = tr('On the way to destination');
        subtitle = car?.etaSec != null ? 'Arriving in ${durationText(car!.etaSec)}' : ride.dropoff.address;
    }

    return _panel(context, [
      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      if (subtitle != null) Text(subtitle, style: const TextStyle(color: AppColors.grey)),
      // "Am I walking towards the pickup point?" (InDrive shows the passenger's position to the driver too)
      if ((ride.status == RideStatus.accepted || ride.status == RideStatus.arrived) && s.myDistanceToPickupM != null) ...[
        const SizedBox(height: 8),
        _TrendBanner(trend: s.myTrend, distanceM: s.myDistanceToPickupM!),
      ],
      const SizedBox(height: 14),
      if (d != null) DriverCard(driver: d),
      const SizedBox(height: 14),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ActionCircle(icon: Icons.call, label: tr('Call'), onTap: () => callPhone(d?.phone)),
        ActionCircle(icon: Icons.chat_bubble_outline, label: tr('Chat'), onTap: () => context.push('/chat/${ride.id}')),
        ActionCircle(
          icon: Icons.share_outlined,
          label: tr('Share'),
          onTap: () => shareTrip(ref, ride, carAt: car?.latLng),
        ),
        ActionCircle(
          icon: Icons.shield_outlined,
          label: tr('Safety'),
          color: AppColors.red,
          onTap: () => showSafetySheet(context, ref, ride, myPosition: s.myPosition),
        ),
      ]),
      const SizedBox(height: 12),
      InfoTile(icon: Icons.circle, iconColor: AppColors.limeDark, text: ride.pickup.address, subtitle: tr('From')),
      const SizedBox(height: 6),
      InfoTile(icon: Icons.flag, text: ride.dropoff.address, subtitle: tr('To')),
      const SizedBox(height: 10),
      Row(children: [
        const Icon(Icons.money, color: AppColors.green),
        const SizedBox(width: 8),
        Text('${tr('Cash')} · ${pkr(ride.price)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ]),
      if (ride.status != RideStatus.inProgress) ...[
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.red),
          onPressed: () async {
            final reason = await askCancelReason(context, driver: false);
            if (reason == null) return;
            try {
              await ref.read(passengerProvider.notifier).cancel(reason);
            } catch (e) {
              if (context.mounted) showError(context, e);
            }
          },
          child: Text(tr('Cancel')),
        ),
      ],
    ]);
  }
}

class _TrendBanner extends StatelessWidget {
  const _TrendBanner({required this.trend, required this.distanceM});
  final Trend trend;
  final int distanceM;

  @override
  Widget build(BuildContext context) {
    final (icon, text, color) = switch (trend) {
      _ when distanceM < 30 => (Icons.check_circle, 'You are at the pickup point', AppColors.green),
      Trend.closer => (Icons.directions_walk, 'You are moving towards the pickup point (${distanceText(distanceM)})', AppColors.green),
      Trend.away => (Icons.warning_amber, 'You are moving away from the pickup point (${distanceText(distanceM)})', AppColors.red),
      Trend.still => (Icons.place_outlined, 'Pickup point is ${distanceText(distanceM)} from you', AppColors.grey),
    };
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

/* -------------------------------- Closed -------------------------------- */

class _ClosedPanel extends ConsumerWidget {
  const _ClosedPanel({required this.ride});
  final Ride ride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.read(passengerProvider.notifier);
    final expired = ride.status == RideStatus.expired;
    final byDriver = ride.cancelledBy == 'driver';
    return _panel(context, [
      Icon(expired ? Icons.timer_off_outlined : Icons.cancel_outlined, size: 48, color: AppColors.grey),
      const SizedBox(height: 8),
      Text(
        expired ? 'No driver was chosen in time' : (byDriver ? 'The driver cancelled the ride' : 'Ride cancelled'),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
      if (ride.cancelReason != null && !expired)
        Text(ride.cancelReason!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.grey)),
      const SizedBox(height: 16),
      if (expired || byDriver) ...[
        LoadingButton(
          label: 'Order again',
          onPressed: () async {
            n.clearRideKeepDraft();
            await n.createRide();
          },
        ),
        const SizedBox(height: 8),
      ],
      OutlinedButton(
        onPressed: () {
          n.closeRide();
          context.go('/home');
        },
        child: Text(tr('Close')),
      ),
      ...detailLines(ride.details).map((l) => Text(l, style: const TextStyle(color: AppColors.grey))),
    ]);
  }
}
