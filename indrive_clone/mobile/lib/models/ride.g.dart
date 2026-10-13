// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RidePoint _$RidePointFromJson(Map<String, dynamic> json) => _RidePoint(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  address: json['address'] as String,
);

Map<String, dynamic> _$RidePointToJson(_RidePoint instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
    };

_RideDetails _$RideDetailsFromJson(Map<String, dynamic> json) => _RideDetails(
  packageDescription: json['packageDescription'] as String?,
  receiverName: json['receiverName'] as String?,
  receiverPhone: json['receiverPhone'] as String?,
  departureAt: json['departureAt'] as String?,
  seats: (json['seats'] as num?)?.toInt(),
  sharedRide: json['sharedRide'] as bool?,
  cargoDescription: json['cargoDescription'] as String?,
  needLoaders: json['needLoaders'] as bool?,
  childSeat: json['childSeat'] as bool?,
  withPet: json['withPet'] as bool?,
);

Map<String, dynamic> _$RideDetailsToJson(_RideDetails instance) =>
    <String, dynamic>{
      'packageDescription': ?instance.packageDescription,
      'receiverName': ?instance.receiverName,
      'receiverPhone': ?instance.receiverPhone,
      'departureAt': ?instance.departureAt,
      'seats': ?instance.seats,
      'sharedRide': ?instance.sharedRide,
      'cargoDescription': ?instance.cargoDescription,
      'needLoaders': ?instance.needLoaders,
      'childSeat': ?instance.childSeat,
      'withPet': ?instance.withPet,
    };

_Offer _$OfferFromJson(Map<String, dynamic> json) => _Offer(
  id: json['id'] as String,
  rideId: json['rideId'] as String,
  price: (json['price'] as num).toInt(),
  etaSec: (json['etaSec'] as num).toInt(),
  distanceM: (json['distanceM'] as num).toInt(),
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  driver: json['driver'] == null
      ? null
      : PublicDriver.fromJson(json['driver'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OfferToJson(_Offer instance) => <String, dynamic>{
  'id': instance.id,
  'rideId': instance.rideId,
  'price': instance.price,
  'etaSec': instance.etaSec,
  'distanceM': instance.distanceM,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
  'expiresAt': instance.expiresAt.toIso8601String(),
  'driver': instance.driver,
};

_Ride _$RideFromJson(Map<String, dynamic> json) => _Ride(
  id: json['id'] as String,
  status: json['status'] as String,
  serviceType: json['serviceType'] as String,
  vehicleType: json['vehicleType'] as String,
  pickup: RidePoint.fromJson(json['pickup'] as Map<String, dynamic>),
  dropoff: RidePoint.fromJson(json['dropoff'] as Map<String, dynamic>),
  distanceM: (json['distanceM'] as num).toInt(),
  durationS: (json['durationS'] as num).toInt(),
  routePolyline: json['routePolyline'] as String?,
  recommendedFare: (json['recommendedFare'] as num).toInt(),
  minFare: (json['minFare'] as num).toInt(),
  offeredFare: (json['offeredFare'] as num).toInt(),
  finalFare: (json['finalFare'] as num?)?.toInt(),
  paymentMethod: json['paymentMethod'] as String? ?? 'cash',
  comment: json['comment'] as String?,
  details: json['details'] == null
      ? const RideDetails()
      : RideDetails.fromJson(json['details'] as Map<String, dynamic>),
  searchRadiusM: (json['searchRadiusM'] as num?)?.toInt() ?? 3000,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  acceptedAt: json['acceptedAt'] == null
      ? null
      : DateTime.parse(json['acceptedAt'] as String),
  arrivedAt: json['arrivedAt'] == null
      ? null
      : DateTime.parse(json['arrivedAt'] as String),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  cancelledBy: json['cancelledBy'] as String?,
  cancelReason: json['cancelReason'] as String?,
  driverStars: (json['driverStars'] as num?)?.toInt(),
  passengerStars: (json['passengerStars'] as num?)?.toInt(),
  commission: (json['commission'] as num?)?.toInt(),
  passenger: json['passenger'] == null
      ? null
      : PublicUser.fromJson(json['passenger'] as Map<String, dynamic>),
  driver: json['driver'] == null
      ? null
      : PublicDriver.fromJson(json['driver'] as Map<String, dynamic>),
  offers:
      (json['offers'] as List<dynamic>?)
          ?.map((e) => Offer.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$RideToJson(_Ride instance) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'serviceType': instance.serviceType,
  'vehicleType': instance.vehicleType,
  'pickup': instance.pickup,
  'dropoff': instance.dropoff,
  'distanceM': instance.distanceM,
  'durationS': instance.durationS,
  'routePolyline': instance.routePolyline,
  'recommendedFare': instance.recommendedFare,
  'minFare': instance.minFare,
  'offeredFare': instance.offeredFare,
  'finalFare': instance.finalFare,
  'paymentMethod': instance.paymentMethod,
  'comment': instance.comment,
  'details': instance.details,
  'searchRadiusM': instance.searchRadiusM,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'acceptedAt': instance.acceptedAt?.toIso8601String(),
  'arrivedAt': instance.arrivedAt?.toIso8601String(),
  'startedAt': instance.startedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'cancelledAt': instance.cancelledAt?.toIso8601String(),
  'cancelledBy': instance.cancelledBy,
  'cancelReason': instance.cancelReason,
  'driverStars': instance.driverStars,
  'passengerStars': instance.passengerStars,
  'commission': instance.commission,
  'passenger': instance.passenger,
  'driver': instance.driver,
  'offers': instance.offers,
};

_DriverRequest _$DriverRequestFromJson(Map<String, dynamic> json) =>
    _DriverRequest(
      rideId: json['rideId'] as String,
      serviceType: json['serviceType'] as String,
      vehicleType: json['vehicleType'] as String,
      pickup: RidePoint.fromJson(json['pickup'] as Map<String, dynamic>),
      dropoff: RidePoint.fromJson(json['dropoff'] as Map<String, dynamic>),
      distanceM: (json['distanceM'] as num).toInt(),
      durationS: (json['durationS'] as num).toInt(),
      routePolyline: json['routePolyline'] as String?,
      offeredFare: (json['offeredFare'] as num).toInt(),
      recommendedFare: (json['recommendedFare'] as num).toInt(),
      paymentMethod: json['paymentMethod'] as String? ?? 'cash',
      comment: json['comment'] as String?,
      details: json['details'] == null
          ? const RideDetails()
          : RideDetails.fromJson(json['details'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      passenger: PublicUser.fromJson(json['passenger'] as Map<String, dynamic>),
      pickupDistanceM: (json['pickupDistanceM'] as num?)?.toInt(),
      pickupEtaSec: (json['pickupEtaSec'] as num?)?.toInt(),
      myOffer: json['myOffer'] == null
          ? null
          : MyOffer.fromJson(json['myOffer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DriverRequestToJson(_DriverRequest instance) =>
    <String, dynamic>{
      'rideId': instance.rideId,
      'serviceType': instance.serviceType,
      'vehicleType': instance.vehicleType,
      'pickup': instance.pickup,
      'dropoff': instance.dropoff,
      'distanceM': instance.distanceM,
      'durationS': instance.durationS,
      'routePolyline': instance.routePolyline,
      'offeredFare': instance.offeredFare,
      'recommendedFare': instance.recommendedFare,
      'paymentMethod': instance.paymentMethod,
      'comment': instance.comment,
      'details': instance.details,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'passenger': instance.passenger,
      'pickupDistanceM': instance.pickupDistanceM,
      'pickupEtaSec': instance.pickupEtaSec,
      'myOffer': instance.myOffer,
    };

_MyOffer _$MyOfferFromJson(Map<String, dynamic> json) => _MyOffer(
  id: json['id'] as String,
  price: (json['price'] as num).toInt(),
  status: json['status'] as String,
);

Map<String, dynamic> _$MyOfferToJson(_MyOffer instance) => <String, dynamic>{
  'id': instance.id,
  'price': instance.price,
  'status': instance.status,
};

_LiveLocation _$LiveLocationFromJson(Map<String, dynamic> json) =>
    _LiveLocation(
      rideId: json['rideId'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      distanceM: (json['distanceM'] as num?)?.toInt(),
      etaSec: (json['etaSec'] as num?)?.toInt(),
      distanceToPickupM: (json['distanceToPickupM'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LiveLocationToJson(_LiveLocation instance) =>
    <String, dynamic>{
      'rideId': instance.rideId,
      'lat': instance.lat,
      'lng': instance.lng,
      'heading': instance.heading,
      'speed': instance.speed,
      'distanceM': instance.distanceM,
      'etaSec': instance.etaSec,
      'distanceToPickupM': instance.distanceToPickupM,
    };
