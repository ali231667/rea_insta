import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/strings.dart';
import '../../core/location/location_service.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../models/misc.dart';
import '../../widgets/app_map.dart';
import '../../widgets/common.dart';
import 'passenger_controller.dart';

/// Move the map under the pin to choose an exact point.
class PickOnMapScreen extends ConsumerStatefulWidget {
  const PickOnMapScreen({super.key});

  @override
  ConsumerState<PickOnMapScreen> createState() => _PickOnMapScreenState();
}

class _PickOnMapScreenState extends ConsumerState<PickOnMapScreen> {
  final _map = MapController();
  Timer? _debounce;
  Place? _place;
  bool _loading = true;

  Future<void> _lookup(MapCamera camera) async {
    setState(() => _loading = true);
    try {
      final p = await ref.read(mapsRepositoryProvider).reverse(camera.center);
      if (mounted) setState(() => _place = p);
    } catch (_) {
      if (mounted) {
        setState(() => _place = Place(
              name: '${camera.center.latitude.toStringAsFixed(5)}, ${camera.center.longitude.toStringAsFixed(5)}',
              address: '',
              lat: camera.center.latitude,
              lng: camera.center.longitude,
            ));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.read(passengerProvider);
    final start = s.dropoff?.latLng ?? s.pickup?.latLng ?? s.myPosition ?? LocationService.fallback;
    return Scaffold(
      appBar: AppBar(title: Text(tr('Choose on map')), backgroundColor: Theme.of(context).colorScheme.surface),
      body: Stack(children: [
        AppMap(
          controller: _map,
          initialCenter: start,
          initialZoom: 17,
          onMapReady: () => _lookup(_map.camera),
          onPositionChanged: (camera, _) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 600), () => _lookup(camera));
          },
        ),
        const IgnorePointer(
          child: Center(
            child: Padding(padding: EdgeInsets.only(bottom: 44), child: Icon(Icons.location_on, size: 48, color: AppColors.black)),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            elevation: 12,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  InfoTile(
                    icon: Icons.place_outlined,
                    text: _loading ? '...' : (_place?.name ?? ''),
                    subtitle: _loading ? null : _place?.address,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _loading || _place == null ? null : () => context.pop(_place), child: Text(tr('Done'))),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
