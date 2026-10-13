import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'misc.freezed.dart';
part 'misc.g.dart';

@freezed
abstract class FareOption with _$FareOption {
  const factory FareOption({
    required String vehicleType,
    required String label,
    required int recommendedFare,
    required int minFare,
    required int maxFare,
  }) = _FareOption;
  factory FareOption.fromJson(Map<String, dynamic> json) => _$FareOptionFromJson(json);
}

@freezed
abstract class FareEstimate with _$FareEstimate {
  const factory FareEstimate({
    required int distanceM,
    required int durationS,
    String? routePolyline,
    String? routeSource,
    required List<FareOption> options,
  }) = _FareEstimate;
  factory FareEstimate.fromJson(Map<String, dynamic> json) => _$FareEstimateFromJson(json);
}

/// An address (search result, map pin, saved place).
@freezed
abstract class Place with _$Place {
  const Place._();
  const factory Place({String? id, String? label, required String name, required String address, required double lat, required double lng}) =
      _Place;
  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  LatLng get latLng => LatLng(lat, lng);
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String rideId,
    required String senderId,
    required String body,
    required DateTime createdAt,
  }) = _ChatMessage;
  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}

@freezed
abstract class NearbyCar with _$NearbyCar {
  const factory NearbyCar({
    required String key,
    required String vehicleType,
    required double lat,
    required double lng,
    double? heading,
    required int distanceM,
  }) = _NearbyCar;
  factory NearbyCar.fromJson(Map<String, dynamic> json) => _$NearbyCarFromJson(json);
}

@freezed
abstract class EarningPeriod with _$EarningPeriod {
  const factory EarningPeriod({
    @Default(0) int rides,
    @Default(0) int gross,
    @Default(0) int commission,
    @Default(0) int net,
    @Default(0) int distanceM,
  }) = _EarningPeriod;
  factory EarningPeriod.fromJson(Map<String, dynamic> json) => _$EarningPeriodFromJson(json);
}

@freezed
abstract class WalletTx with _$WalletTx {
  const factory WalletTx({
    required String id,
    required int amount,
    required String type,
    String? rideId,
    String? note,
    required DateTime createdAt,
  }) = _WalletTx;
  factory WalletTx.fromJson(Map<String, dynamic> json) => _$WalletTxFromJson(json);
}

@freezed
abstract class Earnings with _$Earnings {
  const factory Earnings({
    required int balance,
    required double commissionRate,
    required EarningPeriod today,
    required EarningPeriod week,
    required EarningPeriod month,
    @Default([]) List<WalletTx> transactions,
  }) = _Earnings;
  factory Earnings.fromJson(Map<String, dynamic> json) => _$EarningsFromJson(json);
}
