// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  phone: json['phone'] as String,
  name: json['name'] as String?,
  email: json['email'] as String?,
  photoUrl: json['photoUrl'] as String?,
  language: json['language'] as String? ?? 'en',
  rating: (json['rating'] as num?)?.toDouble() ?? 5,
  ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'name': instance.name,
  'email': instance.email,
  'photoUrl': instance.photoUrl,
  'language': instance.language,
  'rating': instance.rating,
  'ratingCount': instance.ratingCount,
  'createdAt': instance.createdAt?.toIso8601String(),
};

_Vehicle _$VehicleFromJson(Map<String, dynamic> json) => _Vehicle(
  type: json['type'] as String,
  make: json['make'] as String,
  model: json['model'] as String,
  color: json['color'] as String,
  year: (json['year'] as num?)?.toInt(),
  plateNumber: json['plateNumber'] as String,
  photoUrl: json['photoUrl'] as String?,
);

Map<String, dynamic> _$VehicleToJson(_Vehicle instance) => <String, dynamic>{
  'type': instance.type,
  'make': instance.make,
  'model': instance.model,
  'color': instance.color,
  'year': instance.year,
  'plateNumber': instance.plateNumber,
  'photoUrl': instance.photoUrl,
};

_DriverProfile _$DriverProfileFromJson(Map<String, dynamic> json) =>
    _DriverProfile(
      status: json['status'] as String,
      rejectionReason: json['rejectionReason'] as String?,
      cnicNumber: json['cnicNumber'] as String,
      licenseNumber: json['licenseNumber'] as String,
      vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      services:
          (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      docs:
          (json['docs'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      rating: (json['rating'] as num?)?.toDouble() ?? 5,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
    );

Map<String, dynamic> _$DriverProfileToJson(_DriverProfile instance) =>
    <String, dynamic>{
      'status': instance.status,
      'rejectionReason': instance.rejectionReason,
      'cnicNumber': instance.cnicNumber,
      'licenseNumber': instance.licenseNumber,
      'vehicle': instance.vehicle,
      'services': instance.services,
      'docs': instance.docs,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'balance': instance.balance,
      'isOnline': instance.isOnline,
    };

_Me _$MeFromJson(Map<String, dynamic> json) => _Me(
  user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
  driver: json['driver'] == null
      ? null
      : DriverProfile.fromJson(json['driver'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MeToJson(_Me instance) => <String, dynamic>{
  'user': instance.user,
  'driver': instance.driver,
};

_PublicUser _$PublicUserFromJson(Map<String, dynamic> json) => _PublicUser(
  id: json['id'] as String,
  name: json['name'] as String,
  photoUrl: json['photoUrl'] as String?,
  rating: (json['rating'] as num?)?.toDouble() ?? 5,
  ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$PublicUserToJson(_PublicUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'phone': instance.phone,
    };

_PublicDriver _$PublicDriverFromJson(Map<String, dynamic> json) =>
    _PublicDriver(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 5,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      tripsCount: (json['tripsCount'] as num?)?.toInt() ?? 0,
      vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$PublicDriverToJson(_PublicDriver instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'tripsCount': instance.tripsCount,
      'vehicle': instance.vehicle,
      'phone': instance.phone,
    };
