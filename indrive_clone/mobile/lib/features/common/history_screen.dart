import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../auth/session_controller.dart';
import '../passenger/order_sheets.dart';
import 'ride_sheets.dart';

/// List of past rides (as passenger or as driver, depending on the mode).
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _rides = <Ride>[];
  bool _loading = true;
  bool _done = false;
  final _scroll = ScrollController();

  String get _role => ref.read(sessionProvider).mode == AppMode.driver ? 'driver' : 'passenger';

  @override
  void initState() {
    super.initState();
    _load();
    // Load more when we reach the end (pagination).
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 200) _load();
    });
  }

  Future<void> _load() async {
    if (_done || (_loading && _rides.isNotEmpty)) return;
    setState(() => _loading = true);
    try {
      final list = await ref.read(rideRepositoryProvider).history(role: _role, before: _rides.isEmpty ? null : _rides.last.createdAt);
      setState(() {
        _rides.addAll(list);
        _done = list.length < 20;
      });
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('My rides'))),
      body: _rides.isEmpty && !_loading
          ? const Center(child: Text('No rides yet', style: TextStyle(color: AppColors.grey)))
          : ListView.separated(
              controller: _scroll,
              itemCount: _rides.length + (_loading ? 1 : 0),
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                if (i >= _rides.length) return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
                final r = _rides[i];
                final ok = r.status == RideStatus.completed;
                return ListTile(
                  onTap: () => context.push('/history/${r.id}'),
                  leading: CircleAvatar(child: Icon(vehicleInfo(r.vehicleType).icon)),
                  title: Text(r.dropoff.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${dateText(r.createdAt)}\n${r.pickup.address}', maxLines: 2, overflow: TextOverflow.ellipsis),
                  isThreeLine: true,
                  trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(ok ? pkr(r.price) : '', style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(ok ? 'Completed' : (r.status == RideStatus.expired ? 'No driver' : 'Cancelled'),
                        style: TextStyle(color: ok ? AppColors.green : AppColors.red, fontSize: 12)),
                  ]),
                );
              },
            ),
    );
  }
}

/// Details of one ride with the route on a map.
class RideDetailsScreen extends ConsumerWidget {
  const RideDetailsScreen({super.key, required this.rideId});
  final String rideId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ride details')),
      body: FutureBuilder<Ride>(
        future: ref.read(rideRepositoryProvider).get(rideId),
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('${snap.error}'));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final r = snap.data!;
          final route = decodePolyline(r.routePolyline);
          final map = MapController();
          return ListView(padding: const EdgeInsets.all(16), children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 200,
                child: AppMap(
                  controller: map,
                  initialCenter: r.pickup.latLng,
                  interactive: false,
                  onMapReady: () => fitPoints(map, [r.pickup.latLng, r.dropoff.latLng], padding: const EdgeInsets.all(30)),
                  layers: [
                    if (route.isNotEmpty) PolylineLayer(polylines: [routeLine(route)]),
                    MarkerLayer(markers: [pickupMarker(r.pickup.latLng), dropoffMarker(r.dropoff.latLng)]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(dateText(r.createdAt), style: const TextStyle(color: AppColors.grey)),
            const SizedBox(height: 8),
            InfoTile(icon: Icons.circle, iconColor: AppColors.limeDark, text: r.pickup.address, subtitle: timeText(r.startedAt)),
            const SizedBox(height: 6),
            InfoTile(icon: Icons.flag, text: r.dropoff.address, subtitle: timeText(r.completedAt)),
            const SizedBox(height: 12),
            _row('Status', r.status.replaceAll('_', ' ')),
            _row('Service', '${serviceInfo(r.serviceType).label} · ${vehicleInfo(r.vehicleType).label}'),
            _row('Distance', '${distanceText(r.distanceM)} · ${durationText(r.durationS)}'),
            _row('Price', pkr(r.price)),
            _row('Payment', tr('Cash')),
            if (r.commission != null) _row('Commission', pkr(r.commission)),
            if (r.cancelReason != null) _row('Cancel reason', r.cancelReason!),
            for (final l in detailLines(r.details)) Text(l),
            const SizedBox(height: 12),
            if (r.driver != null) DriverCard(driver: r.driver!),
            if (r.driverStars != null) _row('Your rating for driver', '★' * r.driverStars!),
          ]);
        },
      ),
    );
  }

  Widget _row(String a, String b) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Expanded(child: Text(a, style: const TextStyle(color: AppColors.grey))),
          Flexible(child: Text(b, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w600))),
        ]),
      );
}
