import 'package:latlong2/latlong.dart';

import '../core/network/api_client.dart';
import '../models/misc.dart';

class RouteInfo {
  RouteInfo({required this.distanceM, required this.durationS, required this.polyline});
  final int distanceM;
  final int durationS;
  final String polyline;
}

/// Address search, reverse geocoding and routes (through our backend).
class MapsRepository {
  MapsRepository(this.api);
  final ApiClient api;

  Future<List<Place>> search(String q, {LatLng? near}) async {
    final list = await api.get<List<dynamic>>('/maps/search', query: {
      'q': q,
      if (near != null) 'lat': near.latitude,
      if (near != null) 'lng': near.longitude,
    });
    return list.map((e) => Place.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Place> reverse(LatLng p) async =>
      Place.fromJson(await api.get<Map<String, dynamic>>('/maps/reverse', query: {'lat': p.latitude, 'lng': p.longitude}));

  Future<RouteInfo> route(LatLng from, LatLng to) async {
    final r = await api.get<Map<String, dynamic>>('/maps/route', query: {
      'fromLat': from.latitude,
      'fromLng': from.longitude,
      'toLat': to.latitude,
      'toLng': to.longitude,
    });
    return RouteInfo(
      distanceM: (r['distanceM'] as num).toInt(),
      durationS: (r['durationS'] as num).toInt(),
      polyline: r['polyline'] as String,
    );
  }
}
