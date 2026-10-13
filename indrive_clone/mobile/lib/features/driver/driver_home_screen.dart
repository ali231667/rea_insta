import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/strings.dart';
import '../../core/location/location_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../core/utils/vehicles.dart';
import '../../models/ride.dart';
import '../../widgets/app_map.dart';
import '../../widgets/common.dart';
import '../../widgets/map_markers.dart';
import '../auth/session_controller.dart';
import '../common/app_drawer.dart';
import 'driver_controller.dart';
import 'request_sheet.dart';

/// Driver main screen: Online/Offline switch + live order feed.
class DriverHomeScreen extends ConsumerStatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  ConsumerState<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends ConsumerState<DriverHomeScreen> {
  final _map = MapController();
  final _scaffold = GlobalKey<ScaffoldState>();
  bool _centered = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(driverProvider.notifier).init();
      if (mounted && ref.read(driverProvider).ride?.isAssigned == true) context.go('/driver/ride');
    });
  }

  Future<void> _toggle(bool online) async {
    final n = ref.read(driverProvider.notifier);
    try {
      online ? await n.goOnline() : await n.goOffline();
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(driverProvider);
    final session = ref.watch(sessionProvider);
    final balance = session.driver?.balance ?? 0;

    ref.listen(driverProvider.select((x) => x.ride?.id), (prev, next) {
      if (next != null && prev != next && ref.read(driverProvider).ride?.status == RideStatus.accepted) {
        context.go('/driver/ride');
      }
    });
    if (!_centered && s.myPosition != null) {
      _centered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _map.move(s.myPosition!, 15));
    }

    return Scaffold(
      key: _scaffold,
      drawer: const AppDrawer(),
      body: Stack(children: [
        Positioned.fill(
          child: AppMap(
            controller: _map,
            initialCenter: s.myPosition ?? LocationService.fallback,
            layers: [
              MarkerLayer(markers: [
                for (final r in s.requests) pickupMarker(r.pickup.latLng, label: '₨'),
                if (s.myPosition != null)
                  carMarker(s.myPosition!, heading: s.heading, vehicleType: session.driver?.vehicle.type ?? 'mini'),
              ]),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              MapCircleButton(icon: Icons.menu, onTap: () => _scaffold.currentState?.openDrawer()),
              const Spacer(),
              // Online / Offline switch (top center like InDrive driver app)
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(30),
                color: s.online ? AppColors.lime : Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 6),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(s.online ? tr('Online') : tr('Offline'),
                        style: TextStyle(fontWeight: FontWeight.w800, color: s.online ? AppColors.black : null)),
                    s.switching
                        ? const Padding(padding: EdgeInsets.all(14), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                        : Switch(value: s.online, onChanged: _toggle, activeTrackColor: AppColors.black),
                  ]),
                ),
              ),
              const Spacer(),
              ActionChip(
                avatar: const Icon(Icons.account_balance_wallet_outlined, size: 18),
                label: Text(pkr(balance), style: TextStyle(color: balance < 0 ? AppColors.red : null, fontWeight: FontWeight.w700)),
                onPressed: () => context.push('/driver/earnings'),
              ),
            ]),
          ),
        ),
        Align(alignment: Alignment.bottomCenter, child: _Feed(onToggle: _toggle)),
      ]),
    );
  }
}

class _Feed extends ConsumerWidget {
  const _Feed({required this.onToggle});
  final Future<void> Function(bool) onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(driverProvider);
    final balance = ref.watch(sessionProvider).driver?.balance ?? 0;
    final h = MediaQuery.sizeOf(context).height;

    return Material(
      elevation: 12,
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: s.online ? h * 0.6 : h * 0.4),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: !s.online
                ? Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text(tr('You are offline'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Go online to see ride requests near you.', style: TextStyle(color: AppColors.grey)),
                    if (balance < 0) ...[
                      const SizedBox(height: 8),
                      Text('Your balance is ${pkr(balance)}. Top up to receive orders.', style: const TextStyle(color: AppColors.red)),
                    ],
                    const SizedBox(height: 16),
                    LoadingButton(label: tr('Go online'), icon: Icons.power_settings_new, onPressed: () => onToggle(true)),
                  ])
                : Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Row(children: [
                      Text(tr('Ride requests'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(width: 8),
                      Pill('${s.requests.length}'),
                      const Spacer(),
                      IconButton(
                        onPressed: () => ref.read(driverProvider.notifier).refreshRequests().catchError((Object e) {
                          if (context.mounted) showError(context, e);
                        }),
                        icon: const Icon(Icons.refresh),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    if (s.requests.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Column(children: [
                          Icon(Icons.radar, size: 40, color: AppColors.grey),
                          SizedBox(height: 8),
                          Text('Waiting for requests near you...', style: TextStyle(color: AppColors.grey)),
                        ]),
                      )
                    else
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: s.requests.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (_, i) => RequestCard(request: s.requests[i]),
                        ),
                      ),
                  ]),
          ),
        ),
      ),
    );
  }
}

/// One order in the feed.
class RequestCard extends ConsumerWidget {
  const RequestCard({super.key, required this.request});
  final DriverRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = request;
    final my = r.myOffer;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => showRequestSheet(context, ref, r),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: my?.status == 'pending' ? AppColors.limeDark : Theme.of(context).dividerColor, width: my?.status == 'pending' ? 2 : 1),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            UserAvatar(url: r.passenger.photoUrl, name: r.passenger.name, radius: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.passenger.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                RatingBadge(rating: r.passenger.rating, count: r.passenger.ratingCount, size: 12),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(pkr(r.offeredFare), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              Text('${distanceText(r.pickupDistanceM)} · ${durationText(r.pickupEtaSec)} to pickup',
                  style: const TextStyle(color: AppColors.grey, fontSize: 12)),
            ]),
          ]),
          const SizedBox(height: 8),
          _AddrLine(color: AppColors.limeDark, text: r.pickup.address),
          _AddrLine(color: AppColors.black, text: r.dropoff.address),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 4, children: [
            Pill(serviceInfo(r.serviceType).label, color: AppColors.greyLight),
            Pill('${distanceText(r.distanceM)} trip', color: AppColors.greyLight),
            if (r.comment != null) const Pill('💬 comment', color: AppColors.greyLight),
            if (my != null)
              Pill(
                my.status == 'pending' ? 'Your offer ${pkr(my.price)} · waiting' : 'Offer ${my.status}',
                color: my.status == 'pending' ? AppColors.lime : AppColors.line,
              ),
          ]),
        ]),
      ),
    );
  }
}

class _AddrLine extends StatelessWidget {
  const _AddrLine({required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ]),
      );
}
