import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

const _distance = Distance();

double metersBetween(LatLng a, LatLng b) => _distance.as(LengthUnit.Meter, a, b);

/// Direction from a to b in degrees (0 = north).
double bearingBetween(LatLng a, LatLng b) {
  final lat1 = a.latitudeInRad, lat2 = b.latitudeInRad;
  final dLng = (b.longitude - a.longitude) * math.pi / 180;
  final y = math.sin(dLng) * math.cos(lat2);
  final x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
  return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
}

/// Decodes a Google/OSRM encoded polyline into map points.
List<LatLng> decodePolyline(String? encoded) {
  if (encoded == null || encoded.isEmpty) return const [];
  final points = <LatLng>[];
  var index = 0, lat = 0, lng = 0;
  int next() {
    var result = 0, shift = 0, b = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    return (result & 1) != 0 ? ~(result >> 1) : result >> 1;
  }

  while (index < encoded.length) {
    lat += next();
    lng += next();
    points.add(LatLng(lat / 1e5, lng / 1e5));
  }
  return points;
}

enum Trend { closer, away, still }

/// Tells if two people are getting closer or moving away.
/// We keep the last few distances and compare the newest with the oldest.
class ApproachTracker {
  ApproachTracker({this.window = 4, this.minChangeM = 8});
  final int window;
  final double minChangeM;
  final _history = <double>[];

  Trend add(double distanceM) {
    _history.add(distanceM);
    if (_history.length > window) _history.removeAt(0);
    if (_history.length < 2) return Trend.still;
    final change = _history.last - _history.first;
    if (change < -minChangeM) return Trend.closer;
    if (change > minChangeM) return Trend.away;
    return Trend.still;
  }

  void reset() => _history.clear();
}
