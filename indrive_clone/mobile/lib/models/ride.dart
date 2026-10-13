import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import 'user.dart';

part 'ride.freezed.dart';
part 'ride.g.dart';

/// Ride status values (same as backend).
class RideStatus {
  static const searching = 'searching';
  static const accepted = 'accepted';
  static const arrived = 'arrived';
  static const inProgress = 'in_progress';
  static const completed = 'completed';
  static const cancelled = 'cancelled';
  static const expired = 'expired';

  static const active = [searching, accepted, arrived, inProgress];
  static const assigned = [accepted, arrived, inProgress];
}

@freezed
abstract class RidePoint with _$RidePoint {
  const RidePoint._();
  const factory RidePoint({required double lat, required double lng, required String address}) = _RidePoint;
  factory RidePoint.fromJson(Map<String, dynamic> json) => _$RidePointFromJson(json);

  LatLng get latLng => LatLng(lat, lng);
}

/// Extra info for courier / intercity / freight orders.
@freezed
abstract class RideDetails with _$RideDetails {
  @JsonSerializable(includeIfNull: false)
  const factory RideDetails({
    String? packageDescription,
    String? receiverName,
    String? receiverPhone,
    String? departureAt,
    int? seats,
    bool? sharedRide,
    String? cargoDescription,
    bool? needLoaders,
    bool? childSeat,
    bool? withPet,
  }) = _RideDetails;

  factory RideDetails.fromJson(Map<String, dynamic> json) => _$RideDetailsFromJson(json);
}

/// A driver's price offer for a ride.
@freezed
abstract class Offer with _$Offer {
  const factory Offer({
    required String id,
    required String rideId,
    required int price,
    required int etaSec,
    required int distanceM,
    required String status,
    required DateTime createdAt,
    required DateTime expiresAt,
    PublicDriver? driver,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}

@freezed
abstract class Ride with _$Ride {
  const Ride._();
  const factory Ride({
    required String id,
    required String status,
    required String serviceType,
    required String vehicleType,
    required RidePoint pickup,
    required RidePoint dropoff,
    required int distanceM,
    required int durationS,
    String? routePolyline,
    required int recommendedFare,
    required int minFare,
    required int offeredFare,
    int? finalFare,
    @Default('cash') String paymentMethod,
    String? comment,
    @Default(RideDetails()) RideDetails details,
    @Default(3000) int searchRadiusM,
    required DateTime expiresAt,
    required DateTime createdAt,
    DateTime? acceptedAt,
    DateTime? arrivedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancelledBy,
    String? cancelReason,
    int? driverStars,
    int? passengerStars,
    int? commission,
    PublicUser? passenger,
    PublicDriver? driver,
    @Default([]) List<Offer> offers,
  }) = _Ride;

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  bool get isActive => RideStatus.active.contains(status);
  bool get isAssigned => RideStatus.assigned.contains(status);
  int get price => finalFare ?? offeredFare;
}

/// A ride request as the driver sees it in the order feed.
@freezed
abstract class DriverRequest with _$DriverRequest {
  const factory DriverRequest({
    required String rideId,
    required String serviceType,
    required String vehicleType,
    required RidePoint pickup,
    required RidePoint dropoff,
    required int distanceM,
    required int durationS,
    String? routePolyline,
    required int offeredFare,
    required int recommendedFare,
    @Default('cash') String paymentMethod,
    String? comment,
    @Default(RideDetails()) RideDetails details,
    required DateTime createdAt,
    required DateTime expiresAt,
    required PublicUser passenger,
    int? pickupDistanceM,
    int? pickupEtaSec,
    MyOffer? myOffer,
  }) = _DriverRequest;

  factory DriverRequest.fromJson(Map<String, dynamic> json) => _$DriverRequestFromJson(json);
}

@freezed
abstract class MyOffer with _$MyOffer {
  const factory MyOffer({required String id, required int price, required String status}) = _MyOffer;
  factory MyOffer.fromJson(Map<String, dynamic> json) => _$MyOfferFromJson(json);
}

/// Live position of the other person during a ride.
@freezed
abstract class LiveLocation with _$LiveLocation {
  const LiveLocation._();
  const factory LiveLocation({
    required String rideId,
    required double lat,
    required double lng,
    double? heading,
    double? speed,
    int? distanceM,
    int? etaSec,
    int? distanceToPickupM,
  }) = _LiveLocation;

  factory LiveLocation.fromJson(Map<String, dynamic> json) => _$LiveLocationFromJson(json);

  LatLng get latLng => LatLng(lat, lng);
}
