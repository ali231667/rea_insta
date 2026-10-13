import '../core/network/api_client.dart';

class SupportTicket {
  SupportTicket({
    required this.id,
    required this.category,
    required this.message,
    required this.status,
    this.adminReply,
    this.rideId,
    required this.createdAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> j) => SupportTicket(
        id: j['id'] as String,
        category: j['category'] as String,
        message: j['message'] as String,
        status: j['status'] as String,
        adminReply: j['adminReply'] as String?,
        rideId: j['rideId'] as String?,
        createdAt: DateTime.parse(j['createdAt'] as String),
      );

  final String id;
  final String category;
  final String message;
  final String status; // open | answered | closed
  final String? adminReply;
  final String? rideId;
  final DateTime createdAt;
}

const ticketCategories = <String, String>{
  'lost_item': 'I lost an item',
  'driver_behaviour': 'Problem with the driver',
  'passenger_behaviour': 'Problem with the passenger',
  'fare_issue': 'Price / payment problem',
  'safety': 'Safety issue',
  'app_problem': 'The app is not working',
  'account': 'My account',
  'other': 'Something else',
};

class SupportRepository {
  SupportRepository(this.api);
  final ApiClient api;

  Future<List<SupportTicket>> tickets() async =>
      (await api.get<List<dynamic>>('/support/tickets')).map((e) => SupportTicket.fromJson(e as Map<String, dynamic>)).toList();

  Future<SupportTicket> create({required String category, required String message, String? rideId}) async =>
      SupportTicket.fromJson(await api.post<Map<String, dynamic>>('/support/tickets', {
        'category': category,
        'message': message,
        'rideId': ?rideId,
      }));

  Future<void> close(String id) => api.post('/support/tickets/$id/close');

  /// Link to a web page where family can follow the ride live.
  Future<String> shareLink(String rideId) async => (await api.get<Map<String, dynamic>>('/rides/$rideId/share-link'))['url'] as String;
}
