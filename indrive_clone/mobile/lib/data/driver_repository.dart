import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

import '../core/network/api_client.dart';
import '../models/misc.dart';
import '../models/ride.dart';
import '../models/user.dart';

class DriverRegistration {
  String cnicNumber = '';
  String licenseNumber = '';
  String vehicleType = 'mini';
  String vehicleMake = '';
  String vehicleModel = '';
  String vehicleColor = '';
  String vehicleYear = '';
  String plateNumber = '';
  Set<String> services = {'city'};

  /// Local file paths of photos
  final docs = <String, String>{};
}

class DriverRepository {
  DriverRepository(this.api);
  final ApiClient api;

  Future<DriverProfile> register(DriverRegistration r) async {
    final form = FormData.fromMap({
      'cnicNumber': r.cnicNumber,
      'licenseNumber': r.licenseNumber,
      'vehicleType': r.vehicleType,
      'vehicleMake': r.vehicleMake,
      'vehicleModel': r.vehicleModel,
      'vehicleColor': r.vehicleColor,
      if (r.vehicleYear.isNotEmpty) 'vehicleYear': r.vehicleYear,
      'plateNumber': r.plateNumber,
      'services': r.services.join(','),
    });
    for (final e in r.docs.entries) {
      form.files.add(MapEntry(e.key, await MultipartFile.fromFile(e.value)));
    }
    return DriverProfile.fromJson(await api.post<Map<String, dynamic>>('/drivers/register', form));
  }

  Future<DriverProfile?> me() async {
    final r = await api.get<dynamic>('/drivers/me');
    return r == null ? null : DriverProfile.fromJson(r as Map<String, dynamic>);
  }

  Future<DriverProfile> updateServices(List<String> services) async =>
      DriverProfile.fromJson(await api.patch<Map<String, dynamic>>('/drivers/me/services', {'services': services}));

  Future<void> setOnline(bool online, {LatLng? at, double? heading}) => api.post('/drivers/me/online', {
        'online': online,
        if (at != null) 'lat': at.latitude,
        if (at != null) 'lng': at.longitude,
        'heading': ?heading,
      });

  Future<List<DriverRequest>> requests() async => (await api.get<List<dynamic>>('/drivers/me/requests'))
      .map((e) => DriverRequest.fromJson(e as Map<String, dynamic>))
      .toList();

  Future<Earnings> earnings() async => Earnings.fromJson(await api.get<Map<String, dynamic>>('/drivers/me/earnings'));

  Future<int> topUp(int amount, String method) async =>
      ((await api.post<Map<String, dynamic>>('/drivers/me/topup', {'amount': amount, 'method': method}))['balance'] as num).toInt();

  Future<({List<NearbyCar> cars, int? nearestEtaSec})> nearby(LatLng at) async {
    final r = await api.get<Map<String, dynamic>>('/drivers/nearby', query: {'lat': at.latitude, 'lng': at.longitude});
    return (
      cars: (r['drivers'] as List).map((e) => NearbyCar.fromJson(e as Map<String, dynamic>)).toList(),
      nearestEtaSec: (r['nearestEtaSec'] as num?)?.toInt(),
    );
  }
}
