import 'package:latlong2/latlong.dart';

import '../core/network/api_client.dart';
import '../models/misc.dart';
import '../models/ride.dart';

class RideRepository {
  RideRepository(this.api);
  final ApiClient api;

  Map<String, dynamic> _ll(LatLng p) => {'lat': p.latitude, 'lng': p.longitude};

  Future<FareEstimate> estimate({required String serviceType, required LatLng pickup, required LatLng dropoff}) async =>
      FareEstimate.fromJson(await api.post<Map<String, dynamic>>(
        '/rides/estimate',
        {'serviceType': serviceType, 'pickup': _ll(pickup), 'dropoff': _ll(dropoff)},
      ));

  Future<Ride> create({
    required String serviceType,
    required String vehicleType,
    required Place pickup,
    required Place dropoff,
    required int offeredFare,
    String? comment,
    RideDetails? details,
  }) async =>
      Ride.fromJson(await api.post<Map<String, dynamic>>('/rides', {
        'serviceType': serviceType,
        'vehicleType': vehicleType,
        'pickup': {'lat': pickup.lat, 'lng': pickup.lng, 'address': pickup.name},
        'dropoff': {'lat': dropoff.lat, 'lng': dropoff.lng, 'address': dropoff.name},
        'offeredFare': offeredFare,
        if (comment != null && comment.trim().isNotEmpty) 'comment': comment.trim(),
        if (details != null) 'details': details.toJson(),
      }));

  Future<Ride?> active({required String role}) async {
    final r = await api.get<Map<String, dynamic>>('/rides/active', query: {'role': role});
    return r['ride'] == null ? null : Ride.fromJson(r['ride'] as Map<String, dynamic>);
  }

  Future<Ride> get(String id) async => Ride.fromJson(await api.get<Map<String, dynamic>>('/rides/$id'));

  Future<List<Ride>> history({required String role, DateTime? before}) async {
    final list = await api.get<List<dynamic>>('/rides/history', query: {
      'role': role,
      if (before != null) 'before': before.toIso8601String(),
    });
    return list.map((e) => Ride.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Place>> recentPlaces() async => (await api.get<List<dynamic>>('/rides/recent-places'))
      .map((e) => e as Map<String, dynamic>)
      .map((e) => Place(name: e['address'] as String, address: e['address'] as String, lat: (e['lat'] as num).toDouble(), lng: (e['lng'] as num).toDouble()))
      .toList();

  Future<Ride> raiseFare(String id, int fare) async =>
      Ride.fromJson(await api.patch<Map<String, dynamic>>('/rides/$id/fare', {'offeredFare': fare}));

  Future<Ride> acceptOffer(String rideId, String offerId) async =>
      Ride.fromJson(await api.post<Map<String, dynamic>>('/rides/$rideId/offers/$offerId/accept'));

  Future<void> declineOffer(String rideId, String offerId) => api.post('/rides/$rideId/offers/$offerId/decline');

  Future<Ride> cancel(String id, String reason) async =>
      Ride.fromJson(await api.post<Map<String, dynamic>>('/rides/$id/cancel', {'reason': reason}));

  Future<void> rate(String id, int stars, String? review) =>
      api.post('/rides/$id/rate', {'stars': stars, if (review != null && review.trim().isNotEmpty) 'review': review.trim()});

  Future<List<ChatMessage>> messages(String id) async =>
      (await api.get<List<dynamic>>('/rides/$id/messages')).map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList();

  Future<ChatMessage> sendMessage(String id, String body) async =>
      ChatMessage.fromJson(await api.post<Map<String, dynamic>>('/rides/$id/messages', {'body': body}));

  Future<void> sos(String id, LatLng? at) => api.post('/rides/$id/sos', at == null ? {} : _ll(at));

  // ---------- driver ----------
  Future<Offer> makeOffer(String rideId, int price) async =>
      Offer.fromJson(await api.post<Map<String, dynamic>>('/rides/$rideId/offers', {'price': price}));
  Future<Ride> arrived(String id) async => Ride.fromJson(await api.post<Map<String, dynamic>>('/rides/$id/arrived'));
  Future<Ride> start(String id) async => Ride.fromJson(await api.post<Map<String, dynamic>>('/rides/$id/start'));
  Future<Ride> complete(String id) async => Ride.fromJson(await api.post<Map<String, dynamic>>('/rides/$id/complete'));
}
