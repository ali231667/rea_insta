import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/config/app_config.dart';

/// Base map used on every screen (OpenStreetMap data, CARTO tiles).
class AppMap extends StatelessWidget {
  const AppMap({
    super.key,
    required this.controller,
    required this.initialCenter,
    this.initialZoom = 15,
    this.layers = const [],
    this.onPositionChanged,
    this.onMapReady,
    this.interactive = true,
  });

  final MapController controller;
  final LatLng initialCenter;
  final double initialZoom;
  final List<Widget> layers;
  final void Function(MapCamera camera, bool hasGesture)? onPositionChanged;
  final VoidCallback? onMapReady;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
        minZoom: 4,
        maxZoom: 19,
        onPositionChanged: onPositionChanged,
        onMapReady: onMapReady,
        interactionOptions: InteractionOptions(
          flags: interactive ? InteractiveFlag.all & ~InteractiveFlag.rotate : InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: dark
              ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
              : AppConfig.tileUrl,
          subdomains: AppConfig.tileSubdomains,
          retinaMode: RetinaMode.isHighDensity(context),
          userAgentPackageName: AppConfig.userAgent,
          maxZoom: 19,
        ),
        ...layers,
        RichAttributionWidget(
          alignment: AttributionAlignment.bottomLeft,
          attributions: [
            TextSourceAttribution('OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright'))),
            const TextSourceAttribution('CARTO'),
          ],
        ),
      ],
    );
  }
}

/// Moves the camera so all points are visible.
void fitPoints(MapController c, List<LatLng> points, {EdgeInsets padding = const EdgeInsets.fromLTRB(60, 120, 60, 360)}) {
  if (points.isEmpty) return;
  if (points.length == 1) {
    c.move(points.first, 16);
    return;
  }
  try {
    c.fitCamera(CameraFit.coordinates(coordinates: points, padding: padding, maxZoom: 17));
  } catch (_) {
    // Map not ready yet.
  }
}
