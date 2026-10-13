// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FareOption _$FareOptionFromJson(Map<String, dynamic> json) => _FareOption(
  vehicleType: json['vehicleType'] as String,
  label: json['label'] as String,
  recommendedFare: (json['recommendedFare'] as num).toInt(),
  minFare: (json['minFare'] as num).toInt(),
  maxFare: (json['maxFare'] as num).toInt(),
);

Map<String, dynamic> _$FareOptionToJson(_FareOption instance) =>
    <String, dynamic>{
      'vehicleType': instance.vehicleType,
      'label': instance.label,
      'recommendedFare': instance.recommendedFare,
      'minFare': instance.minFare,
      'maxFare': instance.maxFare,
    };

_FareEstimate _$FareEstimateFromJson(Map<String, dynamic> json) =>
    _FareEstimate(
      distanceM: (json['distanceM'] as num).toInt(),
      durationS: (json['durationS'] as num).toInt(),
      routePolyline: json['routePolyline'] as String?,
      routeSource: json['routeSource'] as String?,
      options: (json['options'] as List<dynamic>)
          .map((e) => FareOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FareEstimateToJson(_FareEstimate instance) =>
    <String, dynamic>{
      'distanceM': instance.distanceM,
      'durationS': instance.durationS,
      'routePolyline': instance.routePolyline,
      'routeSource': instance.routeSource,
      'options': instance.options,
    };

_Place _$PlaceFromJson(Map<String, dynamic> json) => _Place(
  id: json['id'] as String?,
  label: json['label'] as String?,
  name: json['name'] as String,
  address: json['address'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
);

Map<String, dynamic> _$PlaceToJson(_Place instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'name': instance.name,
  'address': instance.address,
  'lat': instance.lat,
  'lng': instance.lng,
};

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  rideId: json['rideId'] as String,
  senderId: json['senderId'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rideId': instance.rideId,
      'senderId': instance.senderId,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_NearbyCar _$NearbyCarFromJson(Map<String, dynamic> json) => _NearbyCar(
  key: json['key'] as String,
  vehicleType: json['vehicleType'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  heading: (json['heading'] as num?)?.toDouble(),
  distanceM: (json['distanceM'] as num).toInt(),
);

Map<String, dynamic> _$NearbyCarToJson(_NearbyCar instance) =>
    <String, dynamic>{
      'key': instance.key,
      'vehicleType': instance.vehicleType,
      'lat': instance.lat,
      'lng': instance.lng,
      'heading': instance.heading,
      'distanceM': instance.distanceM,
    };

_EarningPeriod _$EarningPeriodFromJson(Map<String, dynamic> json) =>
    _EarningPeriod(
      rides: (json['rides'] as num?)?.toInt() ?? 0,
      gross: (json['gross'] as num?)?.toInt() ?? 0,
      commission: (json['commission'] as num?)?.toInt() ?? 0,
      net: (json['net'] as num?)?.toInt() ?? 0,
      distanceM: (json['distanceM'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$EarningPeriodToJson(_EarningPeriod instance) =>
    <String, dynamic>{
      'rides': instance.rides,
      'gross': instance.gross,
      'commission': instance.commission,
      'net': instance.net,
      'distanceM': instance.distanceM,
    };

_WalletTx _$WalletTxFromJson(Map<String, dynamic> json) => _WalletTx(
  id: json['id'] as String,
  amount: (json['amount'] as num).toInt(),
  type: json['type'] as String,
  rideId: json['rideId'] as String?,
  note: json['note'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$WalletTxToJson(_WalletTx instance) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'type': instance.type,
  'rideId': instance.rideId,
  'note': instance.note,
  'createdAt': instance.createdAt.toIso8601String(),
};

_Earnings _$EarningsFromJson(Map<String, dynamic> json) => _Earnings(
  balance: (json['balance'] as num).toInt(),
  commissionRate: (json['commissionRate'] as num).toDouble(),
  today: EarningPeriod.fromJson(json['today'] as Map<String, dynamic>),
  week: EarningPeriod.fromJson(json['week'] as Map<String, dynamic>),
  month: EarningPeriod.fromJson(json['month'] as Map<String, dynamic>),
  transactions:
      (json['transactions'] as List<dynamic>?)
          ?.map((e) => WalletTx.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$EarningsToJson(_Earnings instance) => <String, dynamic>{
  'balance': instance.balance,
  'commissionRate': instance.commissionRate,
  'today': instance.today,
  'week': instance.week,
  'month': instance.month,
  'transactions': instance.transactions,
};
