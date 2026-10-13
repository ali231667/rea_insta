import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/l10n/strings.dart';
import '../../core/location/location_service.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../core/utils/geo.dart';
import '../../core/utils/vehicles.dart';
import '../../models/misc.dart';
import '../../widgets/app_map.dart';
import '../../widgets/common.dart';
import '../../widgets/map_markers.dart';
import '../common/app_drawer.dart';
import 'order_sheets.dart';
import 'passenger_controller.dart';

/// Passenger main screen: map + "Where to?" + vehicle and price selection.
class PassengerHomeScreen extends ConsumerStatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  ConsumerState<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends ConsumerState<PassengerHomeScreen> {
  final _map = MapController();
  final _scaffold = GlobalKey<ScaffoldState>();
  Timer? _carsTimer;
  Timer? _pinDebounce;
  List<NearbyCar> _cars = [];
  int? _nearestEta;
  bool _dragging = false;
  final _panelKey = GlobalKey();

  /// Height of the bottom panel, so the route is not hidden behind it.
  double get _panelHeight => _panelKey.currentContext?.size?.height ?? 420;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(passengerProvider.notifier).init();
      final p = ref.read(passengerProvider);
      if (!mounted) return;
      if (p.ride?.isActive == true) {
        context.go('/ride');
        return;
      }
      final c = p.pickup?.latLng ?? p.myPosition;
      if (c != null) _map.move(c, 16);
      _loadCars();
    });
    _carsTimer = Timer.periodic(const Duration(seconds: 10), (_) => _loadCars());
  }

  @override
  void dispose() {
    _carsTimer?.cancel();
    _pinDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadCars() async {
    final c = ref.read(passengerProvider).pickup?.latLng ?? ref.read(passengerProvider).myPosition;
    if (c == null) return;
    try {
      final r = await ref.read(driverRepositoryProvider).nearby(c);
      if (mounted) {
        setState(() {
          _cars = r.cars;
          _nearestEta = r.nearestEtaSec;
        });
      }
    } catch (_) {}
  }

  /// InDrive style: when no destination is chosen, the pin in the middle of the map is the pickup point.
  void _onMapMoved(MapCamera camera, bool hasGesture) {
    if (!hasGesture || ref.read(passengerProvider).dropoff != null) return;
    if (!_dragging) setState(() => _dragging = true);
    _pinDebounce?.cancel();
    _pinDebounce = Timer(const Duration(milliseconds: 700), () async {
      setState(() => _dragging = false);
      await ref.read(passengerProvider.notifier).setPickupFromMap(camera.center);
      _loadCars();
    });
  }

  Future<void> _myLocation() async {
    try {
      final pos = await ref.read(locationServiceProvider).current();
      _map.move(pos.latLng, 16);
      if (ref.read(passengerProvider).dropoff == null) {
        await ref.read(passengerProvider.notifier).setPickupFromMap(pos.latLng);
      }
    } catch (e) {
      if (mounted) showMessage(context, '$e', error: true);
    }
  }

  Future<void> _openSearch(String field) async {
    final picked = await context.push<Place>('/search-place?field=$field');
    if (picked == null) return;
    final n = ref.read(passengerProvider.notifier);
    try {
      if (field == 'pickup') {
        await n.setPickup(picked);
      } else {
        await n.setDropoff(picked);
      }
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  void _fitRoute() {
    final s = ref.read(passengerProvider);
    final pts = [?s.pickup?.latLng, ?s.dropoff?.latLng];
    // Wait one frame so the panel has its new height (vehicles + price appear).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) fitPoints(_map, pts, padding: EdgeInsets.fromLTRB(50, 100, 50, _panelHeight + 30));
    });
  }

  Future<void> _order() async {
    final s = ref.read(passengerProvider);
    final o = s.selectedOption;
    if (o != null && (s.offeredFare ?? 0) < o.minFare) {
      showMessage(context, '${tr('Minimum fare')}: ${pkr(o.minFare)}', error: true);
      return;
    }
    await ref.read(passengerProvider.notifier).createRide();
    if (mounted) context.go('/ride');
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(passengerProvider);
    final route = decodePolyline(s.estimate?.routePolyline);
    final hasRoute = s.dropoff != null;
    // New route (from search, Home/Work chip or "order again"): show all of it.
    ref.listen(passengerProvider.select((x) => x.estimate?.routePolyline), (_, next) {
      if (next != null) _fitRoute();
    });

    return Scaffold(
      key: _scaffold,
      drawer: const AppDrawer(),
      body: Stack(children: [
        Positioned.fill(
          child: AppMap(
            controller: _map,
            initialCenter: s.pickup?.latLng ?? s.myPosition ?? LocationService.fallback,
            onPositionChanged: _onMapMoved,
            layers: [
              if (route.isNotEmpty) PolylineLayer(polylines: [routeLine(route)]),
              MarkerLayer(markers: [
                for (final c in _cars) carMarker(LatLng(c.lat, c.lng), heading: c.heading, vehicleType: c.vehicleType, size: 34),
                if (s.myPosition != null) personMarker(s.myPosition!),
                if (hasRoute && s.pickup != null) pickupMarker(s.pickup!.latLng),
                if (hasRoute) dropoffMarker(s.dropoff!.latLng),
              ]),
            ],
          ),
        ),
        // Center pin for choosing pickup by moving the map.
        // The tip of the pin is exactly at the map center, which is the pickup point.
        if (!hasRoute)
          Positioned.fill(
            child: IgnorePointer(
              child: LayoutBuilder(builder: (context, c) {
                const pinSize = 48.0;
                return Stack(children: [
                  Positioned(
                    left: c.maxWidth / 2 - 60,
                    width: 120,
                    top: c.maxHeight / 2 - pinSize - 30,
                    height: pinSize + 30,
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      if (_nearestEta != null && !_dragging)
                        Pill(durationText(_nearestEta), color: AppColors.black, textColor: Colors.white),
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 150),
                        offset: Offset(0, _dragging ? -0.2 : 0),
                        child: const Icon(Icons.location_on, size: pinSize, color: AppColors.black),
                      ),
                    ]),
                  ),
                ]);
              }),
            ),
          ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              MapCircleButton(icon: Icons.menu, onTap: () => _scaffold.currentState?.openDrawer()),
              const Spacer(),
              if (hasRoute)
                MapCircleButton(icon: Icons.close, onTap: () => ref.read(passengerProvider.notifier).clearDropoff())
              else
                MapCircleButton(icon: Icons.my_location, onTap: _myLocation),
            ]),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: KeyedSubtree(key: _panelKey, child: _BottomPanel(onSearch: _openSearch, onOrder: _order)),
        ),
      ]),
    );
  }
}

class _BottomPanel extends ConsumerWidget {
  const _BottomPanel({required this.onSearch, required this.onOrder});
  final Future<void> Function(String field) onSearch;
  final Future<void> Function() onOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(passengerProvider);
    final n = ref.read(passengerProvider.notifier);
    final theme = Theme.of(context);

    return Material(
      elevation: 12,
      color: theme.colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Services: City / City to City / Courier / Freight
            SizedBox(
              height: 40,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                for (final sv in services)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: Icon(sv.icon, size: 18, color: s.serviceType == sv.type ? AppColors.black : null),
                      label: Text(sv.label),
                      selected: s.serviceType == sv.type,
                      showCheckmark: false,
                      onSelected: (_) => n.setService(sv.type).catchError((Object e) {
                        if (context.mounted) showError(context, e);
                      }),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 12),
            InfoTile(
              icon: Icons.circle,
              iconColor: AppColors.limeDark,
              text: s.pickup?.name ?? (s.locationFailed ? 'Move the map to choose pickup' : 'Finding your location...'),
              subtitle: tr('From'),
              onTap: () => onSearch('pickup'),
            ),
            const SizedBox(height: 8),
            InfoTile(
              icon: Icons.search,
              text: s.dropoff?.name ?? tr('Where to?'),
              subtitle: s.dropoff != null ? tr('To') : null,
              onTap: () => onSearch('dropoff'),
            ),
            if (s.dropoff != null) ...[
              const SizedBox(height: 12),
              if (s.estimating) const LinearProgressIndicator(),
              if (s.estimate != null) ...[
                _VehicleList(),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: InfoTile(
                      icon: Icons.payments_outlined,
                      text: s.offeredFare != null ? pkr(s.offeredFare) : tr('Offer your fare'),
                      subtitle: '${tr('Recommended fare')}: ${pkr(s.selectedOption?.recommendedFare)}',
                      onTap: () => showFareSheet(context, ref),
                      trailing: const Icon(Icons.edit, size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: tr('Comments and wishes'),
                    onPressed: () => showOptionsSheet(context, ref),
                    icon: Badge(
                      isLabelVisible: s.comment.isNotEmpty || s.details.toJson().isNotEmpty,
                      child: const Icon(Icons.tune),
                    ),
                  ),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.money, size: 18, color: AppColors.green),
                  const SizedBox(width: 6),
                  Text(tr('Cash'), style: const TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text('${distanceText(s.estimate!.distanceM)} · ${durationText(s.estimate!.durationS)}',
                      style: const TextStyle(color: AppColors.grey)),
                ]),
                const SizedBox(height: 10),
                LoadingButton(label: tr('Find a driver'), onPressed: s.offeredFare == null ? null : onOrder),
              ],
            ] else
              _QuickPlaces(onPicked: (p) async {
                await n.setDropoff(p);
              }),
          ]),
        ),
      ),
    );
  }
}

/// Horizontal list of vehicle types with recommended prices.
class _VehicleList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(passengerProvider);
    final options = s.estimate?.options ?? const <FareOption>[];
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final o = options[i];
          final v = vehicleInfo(o.vehicleType);
          final selected = o.vehicleType == s.vehicleType;
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => ref.read(passengerProvider.notifier).setVehicle(o.vehicleType),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 104,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: selected ? AppColors.lime.withValues(alpha: 0.25) : null,
                border: Border.all(color: selected ? AppColors.limeDark : Theme.of(context).dividerColor, width: selected ? 2 : 1),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(v.icon, size: 28),
                const Spacer(),
                Text(o.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(pkr(o.recommendedFare), style: const TextStyle(fontSize: 12, color: AppColors.grey)),
              ]),
            ),
          );
        },
      ),
    );
  }
}

/// Home / Work / recent destinations under "Where to?".
class _QuickPlaces extends ConsumerStatefulWidget {
  const _QuickPlaces({required this.onPicked});
  final Future<void> Function(Place p) onPicked;

  @override
  ConsumerState<_QuickPlaces> createState() => _QuickPlacesState();
}

class _QuickPlacesState extends ConsumerState<_QuickPlaces> {
  List<Place> _places = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        final saved = await ref.read(userRepositoryProvider).savedPlaces();
        final recent = await ref.read(rideRepositoryProvider).recentPlaces();
        if (mounted) setState(() => _places = [...saved, ...recent].take(6).toList());
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_places.isEmpty) return const SizedBox(height: 4);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 38,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          for (final p in _places)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                avatar: Icon(p.label == 'home' ? Icons.home_outlined : p.label == 'work' ? Icons.work_outline : Icons.history, size: 18),
                label: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
                  child: Text(p.label == 'home' ? tr('Home') : p.label == 'work' ? tr('Work') : p.name, overflow: TextOverflow.ellipsis),
                ),
                onPressed: () => widget.onPicked(p).catchError((Object e) {
                  if (context.mounted) showError(context, e);
                }),
              ),
            ),
        ]),
      ),
    );
  }
}
