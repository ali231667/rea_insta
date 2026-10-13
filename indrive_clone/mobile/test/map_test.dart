import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:indrive_clone/core/utils/geo.dart';
import 'package:indrive_clone/widgets/app_map.dart';
import 'package:indrive_clone/widgets/map_markers.dart';
import 'package:latlong2/latlong.dart';

Future<MapController> pumpMap(WidgetTester tester, Size size, List<Widget> layers) async {
  final c = MapController();
  await tester.binding.setSurfaceSize(size);
  await tester.pumpWidget(MaterialApp(
    home: FlutterMap(
      mapController: c,
      options: const MapOptions(initialCenter: LatLng(31.5204, 74.3587), initialZoom: 15),
      children: layers,
    ),
  ));
  await tester.pump();
  return c;
}

void main() {
  final e = jsonDecode(File('test/fixtures/estimate.json').readAsStringSync()) as Map;
  final route = decodePolyline(e['routePolyline'] as String);

  test('decoded route stays near Lahore (no broken points)', () {
    for (final p in route) {
      expect(p.latitude, inInclusiveRange(31.3, 31.7));
      expect(p.longitude, inInclusiveRange(74.1, 74.6));
    }
  });

  testWidgets('route line draws without errors', (tester) async {
    final c = await pumpMap(tester, const Size(400, 860), [PolylineLayer(polylines: [routeLine(route)])]);
    fitPoints(c, [route.first, route.last], padding: const EdgeInsets.fromLTRB(60, 120, 60, 420));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(c.camera.zoom, greaterThan(10));
  });

  testWidgets('fit still works on a small screen with big padding', (tester) async {
    final c = await pumpMap(tester, const Size(360, 500), const []);
    fitPoints(c, [route.first, route.last], padding: const EdgeInsets.fromLTRB(60, 120, 60, 420));
    await tester.pump();
    expect(c.camera.zoom, greaterThan(10)); // before the fix the camera jumped to zoom 0
    expect(c.camera.center.latitude, inInclusiveRange(31.3, 31.7));
  });
}
