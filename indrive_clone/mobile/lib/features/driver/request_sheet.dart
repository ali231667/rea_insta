import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/strings.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../core/utils/geo.dart';
import '../../core/utils/vehicles.dart';
import '../../models/ride.dart';
import '../../widgets/app_map.dart';
import '../../widgets/common.dart';
import '../../widgets/map_markers.dart';
import '../passenger/order_sheets.dart';
import 'driver_controller.dart';

/// Driver looks at a request: accept the passenger's price or offer a higher price (InDrive bidding).
Future<void> showRequestSheet(BuildContext context, WidgetRef ref, DriverRequest r) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _RequestSheet(rideId: r.rideId),
  );
}

class _RequestSheet extends ConsumerStatefulWidget {
  const _RequestSheet({required this.rideId});
  final String rideId;

  @override
  ConsumerState<_RequestSheet> createState() => _RequestSheetState();
}

class _RequestSheetState extends ConsumerState<_RequestSheet> {
  final _map = MapController();
  final _custom = TextEditingController();

  Future<void> _offer(DriverRequest r, int price) async {
    await ref.read(driverProvider.notifier).makeOffer(r, price);
    if (mounted) showMessage(context, 'Offer sent: ${pkr(price)}. Waiting for the passenger...');
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(driverProvider);
    final r = s.requests.where((x) => x.rideId == widget.rideId).firstOrNull;
    if (r == null) {
      // Request closed (taken by another driver / cancelled / expired)
      return const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('This request is no longer available.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        ),
      );
    }
    final route = decodePolyline(r.routePolyline);
    final counters = {for (final f in [1.1, 1.2, 1.3]) ((r.offeredFare * f) / 10).round() * 10}.toList();
    final waiting = r.myOffer?.status == 'pending';

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.viewInsetsOf(context).bottom + 16),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 180,
              child: AppMap(
                controller: _map,
                initialCenter: r.pickup.latLng,
                interactive: false,
                onMapReady: () => fitPoints(_map, [r.pickup.latLng, r.dropoff.latLng, ?s.myPosition],
                    padding: const EdgeInsets.all(30)),
                layers: [
                  if (route.isNotEmpty) PolylineLayer(polylines: [routeLine(route)]),
                  MarkerLayer(markers: [
                    pickupMarker(r.pickup.latLng),
                    dropoffMarker(r.dropoff.latLng),
                    if (s.myPosition != null) carMarker(s.myPosition!, heading: s.heading, size: 30),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            UserAvatar(url: r.passenger.photoUrl, name: r.passenger.name),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.passenger.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                RatingBadge(rating: r.passenger.rating, count: r.passenger.ratingCount),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(pkr(r.offeredFare), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              Text(tr('Cash'), style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w600)),
            ]),
          ]),
          const SizedBox(height: 10),
          InfoTile(icon: Icons.circle, iconColor: AppColors.limeDark, text: r.pickup.address, subtitle: '${distanceText(r.pickupDistanceM)} from you · ${durationText(r.pickupEtaSec)}'),
          const SizedBox(height: 6),
          InfoTile(icon: Icons.flag, text: r.dropoff.address, subtitle: 'Trip ${distanceText(r.distanceM)} · ${durationText(r.durationS)}'),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            Pill(serviceInfo(r.serviceType).label, color: AppColors.greyLight),
            Pill(vehicleInfo(r.vehicleType).label, color: AppColors.greyLight),
            for (final l in detailLines(r.details)) Pill(l, color: AppColors.greyLight),
          ]),
          if (r.comment != null) ...[
            const SizedBox(height: 8),
            Text('💬 "${r.comment}"', style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
          const SizedBox(height: 16),
          if (waiting)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.lime.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(12)),
              child: Text('Your offer ${pkr(r.myOffer!.price)} was sent. Waiting for the passenger to choose...',
                  textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
            )
          else ...[
            LoadingButton(label: '${tr('Accept for')} ${pkr(r.offeredFare)}', onPressed: () => _offer(r, r.offeredFare)),
            const SizedBox(height: 10),
            const Text('Or offer your price:', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Row(children: [
              for (final p in counters)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: OutlinedButton(onPressed: () => _offer(r, p).catchError((Object e) {
                      if (context.mounted) showError(context, e);
                    }), child: Text(pkr(p), style: const TextStyle(fontSize: 13))),
                  ),
                ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _custom,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(hintText: 'Your price', prefixText: 'PKR '),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 110,
                child: LoadingButton(
                  label: tr('Offer'),
                  onPressed: () async {
                    final v = int.tryParse(_custom.text);
                    if (v == null || v < r.offeredFare) throw ApiException('Price must be at least ${pkr(r.offeredFare)}');
                    await _offer(r, v);
                  },
                ),
              ),
            ]),
          ],
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              ref.read(driverProvider.notifier).skip(r.rideId);
              Navigator.pop(context);
            },
            child: const Text('Skip this request'),
          ),
        ]),
      ),
    );
  }
}
