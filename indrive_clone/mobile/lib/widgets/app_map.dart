import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/config/app_config.dart';

/// Base map used on every screen (OpenStreetMap tiles).
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
          urlTemplate: AppConfig.tileUrl,
          userAgentPackageName: AppConfig.userAgent,
          maxZoom: 19,
          // Dark mode: same tiles with inverted colors.
          tileBuilder: dark ? darkModeTileBuilder : null,
        ),
        ...layers,
        RichAttributionWidget(
          alignment: AttributionAlignment.bottomLeft,
          attributions: [
            TextSourceAttribution('OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright'))),
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
    // On small screens the padding can be bigger than the map. Then the camera breaks (zoom 0),
    // so we shrink the padding to leave at least 120 px of map for the points.
    final size = c.camera.size;
    var p = padding;
    if (size.height > 0 && size.width > 0) {
      double fit(double a, double b, double total) {
        final room = total - 120;
        if (a + b <= room || room <= 0) return 1;
        return room / (a + b);
      }

      final fv = fit(p.top, p.bottom, size.height), fh = fit(p.left, p.right, size.width);
      p = EdgeInsets.fromLTRB(p.left * fh, p.top * fv, p.right * fh, p.bottom * fv);
    }
    c.fitCamera(CameraFit.coordinates(coordinates: points, padding: p, maxZoom: 17));
  } catch (_) {
    // Map not ready yet.
  }
}
