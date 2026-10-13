import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String phone,
    String? name,
    String? email,
    String? photoUrl,
    @Default('en') String language,
    @Default(5) double rating,
    @Default(0) int ratingCount,
    DateTime? createdAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}

@freezed
abstract class Vehicle with _$Vehicle {
  const Vehicle._();
  const factory Vehicle({
    required String type,
    required String make,
    required String model,
    required String color,
    int? year,
    required String plateNumber,
    String? photoUrl,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

  /// "White Suzuki Alto"
  String get title => '$color $make $model';
}

@freezed
abstract class DriverProfile with _$DriverProfile {
  const factory DriverProfile({
    required String status, // pending | approved | rejected | blocked
    String? rejectionReason,
    required String cnicNumber,
    required String licenseNumber,
    required Vehicle vehicle,
    @Default([]) List<String> services,
    @Default({}) Map<String, String> docs,
    @Default(5) double rating,
    @Default(0) int ratingCount,
    @Default(0) int balance,
    @Default(false) bool isOnline,
  }) = _DriverProfile;

  factory DriverProfile.fromJson(Map<String, dynamic> json) => _$DriverProfileFromJson(json);
}

/// Response of GET /users/me
@freezed
abstract class Me with _$Me {
  const factory Me({required AppUser user, DriverProfile? driver}) = _Me;
  factory Me.fromJson(Map<String, dynamic> json) => _$MeFromJson(json);
}

/// Another person in a ride (passenger seen by driver).
@freezed
abstract class PublicUser with _$PublicUser {
  const factory PublicUser({
    required String id,
    required String name,
    String? photoUrl,
    @Default(5) double rating,
    @Default(0) int ratingCount,
    String? phone,
  }) = _PublicUser;

  factory PublicUser.fromJson(Map<String, dynamic> json) => _$PublicUserFromJson(json);
}

/// Driver info shown to the passenger (in offers and during the ride).
@freezed
abstract class PublicDriver with _$PublicDriver {
  const factory PublicDriver({
    required String id,
    required String name,
    String? photoUrl,
    @Default(5) double rating,
    @Default(0) int ratingCount,
    @Default(0) int tripsCount,
    required Vehicle vehicle,
    String? phone,
  }) = _PublicDriver;

  factory PublicDriver.fromJson(Map<String, dynamic> json) => _$PublicDriverFromJson(json);
}
