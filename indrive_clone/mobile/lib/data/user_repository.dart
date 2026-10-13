import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../models/misc.dart';
import '../models/user.dart';

class UserRepository {
  UserRepository(this.api);
  final ApiClient api;

  Future<Me> me() async => Me.fromJson(await api.get<Map<String, dynamic>>('/users/me'));

  Future<Me> update({String? name, String? email, String? language, String? fcmToken}) async {
    final body = <String, dynamic>{'name': ?name, 'email': ?email, 'language': ?language, 'fcmToken': ?fcmToken};
    return Me.fromJson(await api.patch<Map<String, dynamic>>('/users/me', body));
  }

  Future<Me> uploadPhoto(List<int> bytes, String fileName) async {
    final form = FormData.fromMap({'photo': MultipartFile.fromBytes(bytes, filename: fileName)});
    return Me.fromJson(await api.post<Map<String, dynamic>>('/users/me/photo', form));
  }

  Future<void> deleteAccount() => api.delete('/users/me');

  Future<List<Place>> savedPlaces() async =>
      (await api.get<List<dynamic>>('/places')).map((e) => Place.fromJson(e as Map<String, dynamic>)).toList();

  Future<Place> savePlace({required String label, required Place place}) async => Place.fromJson(await api.post<Map<String, dynamic>>(
        '/places',
        {'label': label, 'name': place.name, 'address': place.address, 'lat': place.lat, 'lng': place.lng},
      ));

  Future<void> deletePlace(String id) => api.delete('/places/$id');
}
