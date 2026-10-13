// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ride.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RidePoint {

 double get lat; double get lng; String get address;
/// Create a copy of RidePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RidePointCopyWith<RidePoint> get copyWith => _$RidePointCopyWithImpl<RidePoint>(this as RidePoint, _$identity);

  /// Serializes this RidePoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RidePoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RidePoint&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.address, _this.address) || other.address == _this.address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RidePoint;
  return Object.hash(runtimeType,_this.lat,_this.lng,_this.address);
}

@override
String toString() {
  final _this = this as RidePoint;
  return 'RidePoint(lat: ${_this.lat}, lng: ${_this.lng}, address: ${_this.address})';
}


}

/// @nodoc
abstract mixin class $RidePointCopyWith<$Res>  {
  factory $RidePointCopyWith(RidePoint value, $Res Function(RidePoint) _then) = _$RidePointCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, String address
});




}
/// @nodoc
class _$RidePointCopyWithImpl<$Res>
    implements $RidePointCopyWith<$Res> {
  _$RidePointCopyWithImpl(this._self, this._then);

  final RidePoint _self;
  final $Res Function(RidePoint) _then;

/// Create a copy of RidePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? address = null,}) {
  return _then(RidePoint(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RidePoint].
extension RidePointPatterns on RidePoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RidePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RidePoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RidePoint value)  $default,){
final _that = this;
switch (_that) {
case _RidePoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RidePoint value)?  $default,){
final _that = this;
switch (_that) {
case _RidePoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  String address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RidePoint() when $default != null:
return $default(_that.lat,_that.lng,_that.address);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  String address)  $default,) {final _that = this;
switch (_that) {
case _RidePoint():
return $default(_that.lat,_that.lng,_that.address);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  String address)?  $default,) {final _that = this;
switch (_that) {
case _RidePoint() when $default != null:
return $default(_that.lat,_that.lng,_that.address);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RidePoint extends RidePoint {
  const _RidePoint({required this.lat, required this.lng, required this.address}): super._();
  factory _RidePoint.fromJson(Map<String, dynamic> json) => _$RidePointFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  String address;

/// Create a copy of RidePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RidePointCopyWith<_RidePoint> get copyWith => __$RidePointCopyWithImpl<_RidePoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RidePointToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RidePoint&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,lat,lng,address);
}

@override
String toString() {
    return 'RidePoint(lat: $lat, lng: $lng, address: $address)';
}


}

/// @nodoc
abstract mixin class _$RidePointCopyWith<$Res> implements $RidePointCopyWith<$Res> {
  factory _$RidePointCopyWith(_RidePoint value, $Res Function(_RidePoint) _then) = __$RidePointCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, String address
});




}
/// @nodoc
class __$RidePointCopyWithImpl<$Res>
    implements _$RidePointCopyWith<$Res> {
  __$RidePointCopyWithImpl(this._self, this._then);

  final _RidePoint _self;
  final $Res Function(_RidePoint) _then;

/// Create a copy of RidePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? address = null,}) {
  return _then(_RidePoint(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RideDetails {

 String? get packageDescription; String? get receiverName; String? get receiverPhone; String? get departureAt; int? get seats; bool? get sharedRide; String? get cargoDescription; bool? get needLoaders; bool? get childSeat; bool? get withPet;
/// Create a copy of RideDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RideDetailsCopyWith<RideDetails> get copyWith => _$RideDetailsCopyWithImpl<RideDetails>(this as RideDetails, _$identity);

  /// Serializes this RideDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RideDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RideDetails&&(identical(other.packageDescription, _this.packageDescription) || other.packageDescription == _this.packageDescription)&&(identical(other.receiverName, _this.receiverName) || other.receiverName == _this.receiverName)&&(identical(other.receiverPhone, _this.receiverPhone) || other.receiverPhone == _this.receiverPhone)&&(identical(other.departureAt, _this.departureAt) || other.departureAt == _this.departureAt)&&(identical(other.seats, _this.seats) || other.seats == _this.seats)&&(identical(other.sharedRide, _this.sharedRide) || other.sharedRide == _this.sharedRide)&&(identical(other.cargoDescription, _this.cargoDescription) || other.cargoDescription == _this.cargoDescription)&&(identical(other.needLoaders, _this.needLoaders) || other.needLoaders == _this.needLoaders)&&(identical(other.childSeat, _this.childSeat) || other.childSeat == _this.childSeat)&&(identical(other.withPet, _this.withPet) || other.withPet == _this.withPet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RideDetails;
  return Object.hash(runtimeType,_this.packageDescription,_this.receiverName,_this.receiverPhone,_this.departureAt,_this.seats,_this.sharedRide,_this.cargoDescription,_this.needLoaders,_this.childSeat,_this.withPet);
}

@override
String toString() {
  final _this = this as RideDetails;
  return 'RideDetails(packageDescription: ${_this.packageDescription}, receiverName: ${_this.receiverName}, receiverPhone: ${_this.receiverPhone}, departureAt: ${_this.departureAt}, seats: ${_this.seats}, sharedRide: ${_this.sharedRide}, cargoDescription: ${_this.cargoDescription}, needLoaders: ${_this.needLoaders}, childSeat: ${_this.childSeat}, withPet: ${_this.withPet})';
}


}

/// @nodoc
abstract mixin class $RideDetailsCopyWith<$Res>  {
  factory $RideDetailsCopyWith(RideDetails value, $Res Function(RideDetails) _then) = _$RideDetailsCopyWithImpl;
@useResult
$Res call({
 String? packageDescription, String? receiverName, String? receiverPhone, String? departureAt, int? seats, bool? sharedRide, String? cargoDescription, bool? needLoaders, bool? childSeat, bool? withPet
});




}
/// @nodoc
class _$RideDetailsCopyWithImpl<$Res>
    implements $RideDetailsCopyWith<$Res> {
  _$RideDetailsCopyWithImpl(this._self, this._then);

  final RideDetails _self;
  final $Res Function(RideDetails) _then;

/// Create a copy of RideDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageDescription = freezed,Object? receiverName = freezed,Object? receiverPhone = freezed,Object? departureAt = freezed,Object? seats = freezed,Object? sharedRide = freezed,Object? cargoDescription = freezed,Object? needLoaders = freezed,Object? childSeat = freezed,Object? withPet = freezed,}) {
  return _then(RideDetails(
packageDescription: freezed == packageDescription ? _self.packageDescription : packageDescription // ignore: cast_nullable_to_non_nullable
as String?,receiverName: freezed == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String?,receiverPhone: freezed == receiverPhone ? _self.receiverPhone : receiverPhone // ignore: cast_nullable_to_non_nullable
as String?,departureAt: freezed == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String?,seats: freezed == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int?,sharedRide: freezed == sharedRide ? _self.sharedRide : sharedRide // ignore: cast_nullable_to_non_nullable
as bool?,cargoDescription: freezed == cargoDescription ? _self.cargoDescription : cargoDescription // ignore: cast_nullable_to_non_nullable
as String?,needLoaders: freezed == needLoaders ? _self.needLoaders : needLoaders // ignore: cast_nullable_to_non_nullable
as bool?,childSeat: freezed == childSeat ? _self.childSeat : childSeat // ignore: cast_nullable_to_non_nullable
as bool?,withPet: freezed == withPet ? _self.withPet : withPet // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [RideDetails].
extension RideDetailsPatterns on RideDetails {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RideDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RideDetails() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RideDetails value)  $default,){
final _that = this;
switch (_that) {
case _RideDetails():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RideDetails value)?  $default,){
final _that = this;
switch (_that) {
case _RideDetails() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? packageDescription,  String? receiverName,  String? receiverPhone,  String? departureAt,  int? seats,  bool? sharedRide,  String? cargoDescription,  bool? needLoaders,  bool? childSeat,  bool? withPet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RideDetails() when $default != null:
return $default(_that.packageDescription,_that.receiverName,_that.receiverPhone,_that.departureAt,_that.seats,_that.sharedRide,_that.cargoDescription,_that.needLoaders,_that.childSeat,_that.withPet);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? packageDescription,  String? receiverName,  String? receiverPhone,  String? departureAt,  int? seats,  bool? sharedRide,  String? cargoDescription,  bool? needLoaders,  bool? childSeat,  bool? withPet)  $default,) {final _that = this;
switch (_that) {
case _RideDetails():
return $default(_that.packageDescription,_that.receiverName,_that.receiverPhone,_that.departureAt,_that.seats,_that.sharedRide,_that.cargoDescription,_that.needLoaders,_that.childSeat,_that.withPet);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? packageDescription,  String? receiverName,  String? receiverPhone,  String? departureAt,  int? seats,  bool? sharedRide,  String? cargoDescription,  bool? needLoaders,  bool? childSeat,  bool? withPet)?  $default,) {final _that = this;
switch (_that) {
case _RideDetails() when $default != null:
return $default(_that.packageDescription,_that.receiverName,_that.receiverPhone,_that.departureAt,_that.seats,_that.sharedRide,_that.cargoDescription,_that.needLoaders,_that.childSeat,_that.withPet);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _RideDetails implements RideDetails {
  const _RideDetails({this.packageDescription, this.receiverName, this.receiverPhone, this.departureAt, this.seats, this.sharedRide, this.cargoDescription, this.needLoaders, this.childSeat, this.withPet});
  factory _RideDetails.fromJson(Map<String, dynamic> json) => _$RideDetailsFromJson(json);

@override final  String? packageDescription;
@override final  String? receiverName;
@override final  String? receiverPhone;
@override final  String? departureAt;
@override final  int? seats;
@override final  bool? sharedRide;
@override final  String? cargoDescription;
@override final  bool? needLoaders;
@override final  bool? childSeat;
@override final  bool? withPet;

/// Create a copy of RideDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RideDetailsCopyWith<_RideDetails> get copyWith => __$RideDetailsCopyWithImpl<_RideDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RideDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RideDetails&&(identical(other.packageDescription, packageDescription) || other.packageDescription == packageDescription)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.receiverPhone, receiverPhone) || other.receiverPhone == receiverPhone)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.seats, seats) || other.seats == seats)&&(identical(other.sharedRide, sharedRide) || other.sharedRide == sharedRide)&&(identical(other.cargoDescription, cargoDescription) || other.cargoDescription == cargoDescription)&&(identical(other.needLoaders, needLoaders) || other.needLoaders == needLoaders)&&(identical(other.childSeat, childSeat) || other.childSeat == childSeat)&&(identical(other.withPet, withPet) || other.withPet == withPet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,packageDescription,receiverName,receiverPhone,departureAt,seats,sharedRide,cargoDescription,needLoaders,childSeat,withPet);
}

@override
String toString() {
    return 'RideDetails(packageDescription: $packageDescription, receiverName: $receiverName, receiverPhone: $receiverPhone, departureAt: $departureAt, seats: $seats, sharedRide: $sharedRide, cargoDescription: $cargoDescription, needLoaders: $needLoaders, childSeat: $childSeat, withPet: $withPet)';
}


}

/// @nodoc
abstract mixin class _$RideDetailsCopyWith<$Res> implements $RideDetailsCopyWith<$Res> {
  factory _$RideDetailsCopyWith(_RideDetails value, $Res Function(_RideDetails) _then) = __$RideDetailsCopyWithImpl;
@override @useResult
$Res call({
 String? packageDescription, String? receiverName, String? receiverPhone, String? departureAt, int? seats, bool? sharedRide, String? cargoDescription, bool? needLoaders, bool? childSeat, bool? withPet
});




}
/// @nodoc
class __$RideDetailsCopyWithImpl<$Res>
    implements _$RideDetailsCopyWith<$Res> {
  __$RideDetailsCopyWithImpl(this._self, this._then);

  final _RideDetails _self;
  final $Res Function(_RideDetails) _then;

/// Create a copy of RideDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageDescription = freezed,Object? receiverName = freezed,Object? receiverPhone = freezed,Object? departureAt = freezed,Object? seats = freezed,Object? sharedRide = freezed,Object? cargoDescription = freezed,Object? needLoaders = freezed,Object? childSeat = freezed,Object? withPet = freezed,}) {
  return _then(_RideDetails(
packageDescription: freezed == packageDescription ? _self.packageDescription : packageDescription // ignore: cast_nullable_to_non_nullable
as String?,receiverName: freezed == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String?,receiverPhone: freezed == receiverPhone ? _self.receiverPhone : receiverPhone // ignore: cast_nullable_to_non_nullable
as String?,departureAt: freezed == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String?,seats: freezed == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int?,sharedRide: freezed == sharedRide ? _self.sharedRide : sharedRide // ignore: cast_nullable_to_non_nullable
as bool?,cargoDescription: freezed == cargoDescription ? _self.cargoDescription : cargoDescription // ignore: cast_nullable_to_non_nullable
as String?,needLoaders: freezed == needLoaders ? _self.needLoaders : needLoaders // ignore: cast_nullable_to_non_nullable
as bool?,childSeat: freezed == childSeat ? _self.childSeat : childSeat // ignore: cast_nullable_to_non_nullable
as bool?,withPet: freezed == withPet ? _self.withPet : withPet // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Offer {

 String get id; String get rideId; int get price; int get etaSec; int get distanceM; String get status; DateTime get createdAt; DateTime get expiresAt; PublicDriver? get driver;
/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferCopyWith<Offer> get copyWith => _$OfferCopyWithImpl<Offer>(this as Offer, _$identity);

  /// Serializes this Offer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Offer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Offer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.rideId, _this.rideId) || other.rideId == _this.rideId)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.etaSec, _this.etaSec) || other.etaSec == _this.etaSec)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.driver, _this.driver) || other.driver == _this.driver));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Offer;
  return Object.hash(runtimeType,_this.id,_this.rideId,_this.price,_this.etaSec,_this.distanceM,_this.status,_this.createdAt,_this.expiresAt,_this.driver);
}

@override
String toString() {
  final _this = this as Offer;
  return 'Offer(id: ${_this.id}, rideId: ${_this.rideId}, price: ${_this.price}, etaSec: ${_this.etaSec}, distanceM: ${_this.distanceM}, status: ${_this.status}, createdAt: ${_this.createdAt}, expiresAt: ${_this.expiresAt}, driver: ${_this.driver})';
}


}

/// @nodoc
abstract mixin class $OfferCopyWith<$Res>  {
  factory $OfferCopyWith(Offer value, $Res Function(Offer) _then) = _$OfferCopyWithImpl;
@useResult
$Res call({
 String id, String rideId, int price, int etaSec, int distanceM, String status, DateTime createdAt, DateTime expiresAt, PublicDriver? driver
});


$PublicDriverCopyWith<$Res>? get driver;

}
/// @nodoc
class _$OfferCopyWithImpl<$Res>
    implements $OfferCopyWith<$Res> {
  _$OfferCopyWithImpl(this._self, this._then);

  final Offer _self;
  final $Res Function(Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rideId = null,Object? price = null,Object? etaSec = null,Object? distanceM = null,Object? status = null,Object? createdAt = null,Object? expiresAt = null,Object? driver = freezed,}) {
  return _then(Offer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rideId: null == rideId ? _self.rideId : rideId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,etaSec: null == etaSec ? _self.etaSec : etaSec // ignore: cast_nullable_to_non_nullable
as int,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,driver: freezed == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as PublicDriver?,
  ));
}
/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicDriverCopyWith<$Res>? get driver {
    if (_self.driver == null) {
    return null;
  }

  return $PublicDriverCopyWith<$Res>(_self.driver!, (value) {
    return _then(_self.copyWith(driver: value));
  });
}
}


/// Adds pattern-matching-related methods to [Offer].
extension OfferPatterns on Offer {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Offer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Offer value)  $default,){
final _that = this;
switch (_that) {
case _Offer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Offer value)?  $default,){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String rideId,  int price,  int etaSec,  int distanceM,  String status,  DateTime createdAt,  DateTime expiresAt,  PublicDriver? driver)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.id,_that.rideId,_that.price,_that.etaSec,_that.distanceM,_that.status,_that.createdAt,_that.expiresAt,_that.driver);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String rideId,  int price,  int etaSec,  int distanceM,  String status,  DateTime createdAt,  DateTime expiresAt,  PublicDriver? driver)  $default,) {final _that = this;
switch (_that) {
case _Offer():
return $default(_that.id,_that.rideId,_that.price,_that.etaSec,_that.distanceM,_that.status,_that.createdAt,_that.expiresAt,_that.driver);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String rideId,  int price,  int etaSec,  int distanceM,  String status,  DateTime createdAt,  DateTime expiresAt,  PublicDriver? driver)?  $default,) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.id,_that.rideId,_that.price,_that.etaSec,_that.distanceM,_that.status,_that.createdAt,_that.expiresAt,_that.driver);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Offer implements Offer {
  const _Offer({required this.id, required this.rideId, required this.price, required this.etaSec, required this.distanceM, required this.status, required this.createdAt, required this.expiresAt, this.driver});
  factory _Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

@override final  String id;
@override final  String rideId;
@override final  int price;
@override final  int etaSec;
@override final  int distanceM;
@override final  String status;
@override final  DateTime createdAt;
@override final  DateTime expiresAt;
@override final  PublicDriver? driver;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferCopyWith<_Offer> get copyWith => __$OfferCopyWithImpl<_Offer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Offer&&(identical(other.id, id) || other.id == id)&&(identical(other.rideId, rideId) || other.rideId == rideId)&&(identical(other.price, price) || other.price == price)&&(identical(other.etaSec, etaSec) || other.etaSec == etaSec)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.driver, driver) || other.driver == driver));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,rideId,price,etaSec,distanceM,status,createdAt,expiresAt,driver);
}

@override
String toString() {
    return 'Offer(id: $id, rideId: $rideId, price: $price, etaSec: $etaSec, distanceM: $distanceM, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, driver: $driver)';
}


}

/// @nodoc
abstract mixin class _$OfferCopyWith<$Res> implements $OfferCopyWith<$Res> {
  factory _$OfferCopyWith(_Offer value, $Res Function(_Offer) _then) = __$OfferCopyWithImpl;
@override @useResult
$Res call({
 String id, String rideId, int price, int etaSec, int distanceM, String status, DateTime createdAt, DateTime expiresAt, PublicDriver? driver
});


@override $PublicDriverCopyWith<$Res>? get driver;

}
/// @nodoc
class __$OfferCopyWithImpl<$Res>
    implements _$OfferCopyWith<$Res> {
  __$OfferCopyWithImpl(this._self, this._then);

  final _Offer _self;
  final $Res Function(_Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rideId = null,Object? price = null,Object? etaSec = null,Object? distanceM = null,Object? status = null,Object? createdAt = null,Object? expiresAt = null,Object? driver = freezed,}) {
  return _then(_Offer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rideId: null == rideId ? _self.rideId : rideId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,etaSec: null == etaSec ? _self.etaSec : etaSec // ignore: cast_nullable_to_non_nullable
as int,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,driver: freezed == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as PublicDriver?,
  ));
}

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicDriverCopyWith<$Res>? get driver {
    if (_self.driver == null) {
    return null;
  }

  return $PublicDriverCopyWith<$Res>(_self.driver!, (value) {
    return _then(_self.copyWith(driver: value));
  });
}
}


/// @nodoc
mixin _$Ride {

 String get id; String get status; String get serviceType; String get vehicleType; RidePoint get pickup; RidePoint get dropoff; int get distanceM; int get durationS; String? get routePolyline; int get recommendedFare; int get minFare; int get offeredFare; int? get finalFare; String get paymentMethod; String? get comment; RideDetails get details; int get searchRadiusM; DateTime get expiresAt; DateTime get createdAt; DateTime? get acceptedAt; DateTime? get arrivedAt; DateTime? get startedAt; DateTime? get completedAt; DateTime? get cancelledAt; String? get cancelledBy; String? get cancelReason; int? get driverStars; int? get passengerStars; int? get commission; PublicUser? get passenger; PublicDriver? get driver; List<Offer> get offers;/// While searching: how many drivers got this request.
 int get driversNotified;/// Last known car position (assigned rides), so the map is not empty after reopening the app.
 LiveLocation? get driverLocation;
/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RideCopyWith<Ride> get copyWith => _$RideCopyWithImpl<Ride>(this as Ride, _$identity);

  /// Serializes this Ride to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Ride;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ride&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.serviceType, _this.serviceType) || other.serviceType == _this.serviceType)&&(identical(other.vehicleType, _this.vehicleType) || other.vehicleType == _this.vehicleType)&&(identical(other.pickup, _this.pickup) || other.pickup == _this.pickup)&&(identical(other.dropoff, _this.dropoff) || other.dropoff == _this.dropoff)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM)&&(identical(other.durationS, _this.durationS) || other.durationS == _this.durationS)&&(identical(other.routePolyline, _this.routePolyline) || other.routePolyline == _this.routePolyline)&&(identical(other.recommendedFare, _this.recommendedFare) || other.recommendedFare == _this.recommendedFare)&&(identical(other.minFare, _this.minFare) || other.minFare == _this.minFare)&&(identical(other.offeredFare, _this.offeredFare) || other.offeredFare == _this.offeredFare)&&(identical(other.finalFare, _this.finalFare) || other.finalFare == _this.finalFare)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.comment, _this.comment) || other.comment == _this.comment)&&(identical(other.details, _this.details) || other.details == _this.details)&&(identical(other.searchRadiusM, _this.searchRadiusM) || other.searchRadiusM == _this.searchRadiusM)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.acceptedAt, _this.acceptedAt) || other.acceptedAt == _this.acceptedAt)&&(identical(other.arrivedAt, _this.arrivedAt) || other.arrivedAt == _this.arrivedAt)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt)&&(identical(other.cancelledAt, _this.cancelledAt) || other.cancelledAt == _this.cancelledAt)&&(identical(other.cancelledBy, _this.cancelledBy) || other.cancelledBy == _this.cancelledBy)&&(identical(other.cancelReason, _this.cancelReason) || other.cancelReason == _this.cancelReason)&&(identical(other.driverStars, _this.driverStars) || other.driverStars == _this.driverStars)&&(identical(other.passengerStars, _this.passengerStars) || other.passengerStars == _this.passengerStars)&&(identical(other.commission, _this.commission) || other.commission == _this.commission)&&(identical(other.passenger, _this.passenger) || other.passenger == _this.passenger)&&(identical(other.driver, _this.driver) || other.driver == _this.driver)&&const DeepCollectionEquality().equals(other.offers, _this.offers)&&(identical(other.driversNotified, _this.driversNotified) || other.driversNotified == _this.driversNotified)&&(identical(other.driverLocation, _this.driverLocation) || other.driverLocation == _this.driverLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Ride;
  return Object.hashAll([runtimeType,_this.id,_this.status,_this.serviceType,_this.vehicleType,_this.pickup,_this.dropoff,_this.distanceM,_this.durationS,_this.routePolyline,_this.recommendedFare,_this.minFare,_this.offeredFare,_this.finalFare,_this.paymentMethod,_this.comment,_this.details,_this.searchRadiusM,_this.expiresAt,_this.createdAt,_this.acceptedAt,_this.arrivedAt,_this.startedAt,_this.completedAt,_this.cancelledAt,_this.cancelledBy,_this.cancelReason,_this.driverStars,_this.passengerStars,_this.commission,_this.passenger,_this.driver,const DeepCollectionEquality().hash(_this.offers),_this.driversNotified,_this.driverLocation]);
}

@override
String toString() {
  final _this = this as Ride;
  return 'Ride(id: ${_this.id}, status: ${_this.status}, serviceType: ${_this.serviceType}, vehicleType: ${_this.vehicleType}, pickup: ${_this.pickup}, dropoff: ${_this.dropoff}, distanceM: ${_this.distanceM}, durationS: ${_this.durationS}, routePolyline: ${_this.routePolyline}, recommendedFare: ${_this.recommendedFare}, minFare: ${_this.minFare}, offeredFare: ${_this.offeredFare}, finalFare: ${_this.finalFare}, paymentMethod: ${_this.paymentMethod}, comment: ${_this.comment}, details: ${_this.details}, searchRadiusM: ${_this.searchRadiusM}, expiresAt: ${_this.expiresAt}, createdAt: ${_this.createdAt}, acceptedAt: ${_this.acceptedAt}, arrivedAt: ${_this.arrivedAt}, startedAt: ${_this.startedAt}, completedAt: ${_this.completedAt}, cancelledAt: ${_this.cancelledAt}, cancelledBy: ${_this.cancelledBy}, cancelReason: ${_this.cancelReason}, driverStars: ${_this.driverStars}, passengerStars: ${_this.passengerStars}, commission: ${_this.commission}, passenger: ${_this.passenger}, driver: ${_this.driver}, offers: ${_this.offers}, driversNotified: ${_this.driversNotified}, driverLocation: ${_this.driverLocation})';
}


}

/// @nodoc
abstract mixin class $RideCopyWith<$Res>  {
  factory $RideCopyWith(Ride value, $Res Function(Ride) _then) = _$RideCopyWithImpl;
@useResult
$Res call({
 String id, String status, String serviceType, String vehicleType, RidePoint pickup, RidePoint dropoff, int distanceM, int durationS, String? routePolyline, int recommendedFare, int minFare, int offeredFare, int? finalFare, String paymentMethod, String? comment, RideDetails details, int searchRadiusM, DateTime expiresAt, DateTime createdAt, DateTime? acceptedAt, DateTime? arrivedAt, DateTime? startedAt, DateTime? completedAt, DateTime? cancelledAt, String? cancelledBy, String? cancelReason, int? driverStars, int? passengerStars, int? commission, PublicUser? passenger, PublicDriver? driver, List<Offer> offers, int driversNotified, LiveLocation? driverLocation
});


$RidePointCopyWith<$Res> get pickup;$RidePointCopyWith<$Res> get dropoff;$RideDetailsCopyWith<$Res> get details;$PublicUserCopyWith<$Res>? get passenger;$PublicDriverCopyWith<$Res>? get driver;$LiveLocationCopyWith<$Res>? get driverLocation;

}
/// @nodoc
class _$RideCopyWithImpl<$Res>
    implements $RideCopyWith<$Res> {
  _$RideCopyWithImpl(this._self, this._then);

  final Ride _self;
  final $Res Function(Ride) _then;

/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? serviceType = null,Object? vehicleType = null,Object? pickup = null,Object? dropoff = null,Object? distanceM = null,Object? durationS = null,Object? routePolyline = freezed,Object? recommendedFare = null,Object? minFare = null,Object? offeredFare = null,Object? finalFare = freezed,Object? paymentMethod = null,Object? comment = freezed,Object? details = null,Object? searchRadiusM = null,Object? expiresAt = null,Object? createdAt = null,Object? acceptedAt = freezed,Object? arrivedAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancelledBy = freezed,Object? cancelReason = freezed,Object? driverStars = freezed,Object? passengerStars = freezed,Object? commission = freezed,Object? passenger = freezed,Object? driver = freezed,Object? offers = null,Object? driversNotified = null,Object? driverLocation = freezed,}) {
  return _then(Ride(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String,vehicleType: null == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String,pickup: null == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as RidePoint,dropoff: null == dropoff ? _self.dropoff : dropoff // ignore: cast_nullable_to_non_nullable
as RidePoint,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,routePolyline: freezed == routePolyline ? _self.routePolyline : routePolyline // ignore: cast_nullable_to_non_nullable
as String?,recommendedFare: null == recommendedFare ? _self.recommendedFare : recommendedFare // ignore: cast_nullable_to_non_nullable
as int,minFare: null == minFare ? _self.minFare : minFare // ignore: cast_nullable_to_non_nullable
as int,offeredFare: null == offeredFare ? _self.offeredFare : offeredFare // ignore: cast_nullable_to_non_nullable
as int,finalFare: freezed == finalFare ? _self.finalFare : finalFare // ignore: cast_nullable_to_non_nullable
as int?,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as RideDetails,searchRadiusM: null == searchRadiusM ? _self.searchRadiusM : searchRadiusM // ignore: cast_nullable_to_non_nullable
as int,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,arrivedAt: freezed == arrivedAt ? _self.arrivedAt : arrivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledBy: freezed == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as String?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,driverStars: freezed == driverStars ? _self.driverStars : driverStars // ignore: cast_nullable_to_non_nullable
as int?,passengerStars: freezed == passengerStars ? _self.passengerStars : passengerStars // ignore: cast_nullable_to_non_nullable
as int?,commission: freezed == commission ? _self.commission : commission // ignore: cast_nullable_to_non_nullable
as int?,passenger: freezed == passenger ? _self.passenger : passenger // ignore: cast_nullable_to_non_nullable
as PublicUser?,driver: freezed == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as PublicDriver?,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as List<Offer>,driversNotified: null == driversNotified ? _self.driversNotified : driversNotified // ignore: cast_nullable_to_non_nullable
as int,driverLocation: freezed == driverLocation ? _self.driverLocation : driverLocation // ignore: cast_nullable_to_non_nullable
as LiveLocation?,
  ));
}
/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RidePointCopyWith<$Res> get pickup {
  
  return $RidePointCopyWith<$Res>(_self.pickup, (value) {
    return _then(_self.copyWith(pickup: value));
  });
}/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RidePointCopyWith<$Res> get dropoff {
  
  return $RidePointCopyWith<$Res>(_self.dropoff, (value) {
    return _then(_self.copyWith(dropoff: value));
  });
}/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RideDetailsCopyWith<$Res> get details {
  
  return $RideDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicUserCopyWith<$Res>? get passenger {
    if (_self.passenger == null) {
    return null;
  }

  return $PublicUserCopyWith<$Res>(_self.passenger!, (value) {
    return _then(_self.copyWith(passenger: value));
  });
}/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicDriverCopyWith<$Res>? get driver {
    if (_self.driver == null) {
    return null;
  }

  return $PublicDriverCopyWith<$Res>(_self.driver!, (value) {
    return _then(_self.copyWith(driver: value));
  });
}/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveLocationCopyWith<$Res>? get driverLocation {
    if (_self.driverLocation == null) {
    return null;
  }

  return $LiveLocationCopyWith<$Res>(_self.driverLocation!, (value) {
    return _then(_self.copyWith(driverLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [Ride].
extension RidePatterns on Ride {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ride value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ride() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ride value)  $default,){
final _that = this;
switch (_that) {
case _Ride():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ride value)?  $default,){
final _that = this;
switch (_that) {
case _Ride() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String status,  String serviceType,  String vehicleType,  RidePoint pickup,  RidePoint dropoff,  int distanceM,  int durationS,  String? routePolyline,  int recommendedFare,  int minFare,  int offeredFare,  int? finalFare,  String paymentMethod,  String? comment,  RideDetails details,  int searchRadiusM,  DateTime expiresAt,  DateTime createdAt,  DateTime? acceptedAt,  DateTime? arrivedAt,  DateTime? startedAt,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancelledBy,  String? cancelReason,  int? driverStars,  int? passengerStars,  int? commission,  PublicUser? passenger,  PublicDriver? driver,  List<Offer> offers,  int driversNotified,  LiveLocation? driverLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ride() when $default != null:
return $default(_that.id,_that.status,_that.serviceType,_that.vehicleType,_that.pickup,_that.dropoff,_that.distanceM,_that.durationS,_that.routePolyline,_that.recommendedFare,_that.minFare,_that.offeredFare,_that.finalFare,_that.paymentMethod,_that.comment,_that.details,_that.searchRadiusM,_that.expiresAt,_that.createdAt,_that.acceptedAt,_that.arrivedAt,_that.startedAt,_that.completedAt,_that.cancelledAt,_that.cancelledBy,_that.cancelReason,_that.driverStars,_that.passengerStars,_that.commission,_that.passenger,_that.driver,_that.offers,_that.driversNotified,_that.driverLocation);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String status,  String serviceType,  String vehicleType,  RidePoint pickup,  RidePoint dropoff,  int distanceM,  int durationS,  String? routePolyline,  int recommendedFare,  int minFare,  int offeredFare,  int? finalFare,  String paymentMethod,  String? comment,  RideDetails details,  int searchRadiusM,  DateTime expiresAt,  DateTime createdAt,  DateTime? acceptedAt,  DateTime? arrivedAt,  DateTime? startedAt,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancelledBy,  String? cancelReason,  int? driverStars,  int? passengerStars,  int? commission,  PublicUser? passenger,  PublicDriver? driver,  List<Offer> offers,  int driversNotified,  LiveLocation? driverLocation)  $default,) {final _that = this;
switch (_that) {
case _Ride():
return $default(_that.id,_that.status,_that.serviceType,_that.vehicleType,_that.pickup,_that.dropoff,_that.distanceM,_that.durationS,_that.routePolyline,_that.recommendedFare,_that.minFare,_that.offeredFare,_that.finalFare,_that.paymentMethod,_that.comment,_that.details,_that.searchRadiusM,_that.expiresAt,_that.createdAt,_that.acceptedAt,_that.arrivedAt,_that.startedAt,_that.completedAt,_that.cancelledAt,_that.cancelledBy,_that.cancelReason,_that.driverStars,_that.passengerStars,_that.commission,_that.passenger,_that.driver,_that.offers,_that.driversNotified,_that.driverLocation);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String status,  String serviceType,  String vehicleType,  RidePoint pickup,  RidePoint dropoff,  int distanceM,  int durationS,  String? routePolyline,  int recommendedFare,  int minFare,  int offeredFare,  int? finalFare,  String paymentMethod,  String? comment,  RideDetails details,  int searchRadiusM,  DateTime expiresAt,  DateTime createdAt,  DateTime? acceptedAt,  DateTime? arrivedAt,  DateTime? startedAt,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancelledBy,  String? cancelReason,  int? driverStars,  int? passengerStars,  int? commission,  PublicUser? passenger,  PublicDriver? driver,  List<Offer> offers,  int driversNotified,  LiveLocation? driverLocation)?  $default,) {final _that = this;
switch (_that) {
case _Ride() when $default != null:
return $default(_that.id,_that.status,_that.serviceType,_that.vehicleType,_that.pickup,_that.dropoff,_that.distanceM,_that.durationS,_that.routePolyline,_that.recommendedFare,_that.minFare,_that.offeredFare,_that.finalFare,_that.paymentMethod,_that.comment,_that.details,_that.searchRadiusM,_that.expiresAt,_that.createdAt,_that.acceptedAt,_that.arrivedAt,_that.startedAt,_that.completedAt,_that.cancelledAt,_that.cancelledBy,_that.cancelReason,_that.driverStars,_that.passengerStars,_that.commission,_that.passenger,_that.driver,_that.offers,_that.driversNotified,_that.driverLocation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ride extends Ride {
  const _Ride({required this.id, required this.status, required this.serviceType, required this.vehicleType, required this.pickup, required this.dropoff, required this.distanceM, required this.durationS, this.routePolyline, required this.recommendedFare, required this.minFare, required this.offeredFare, this.finalFare, this.paymentMethod = 'cash', this.comment, this.details = const RideDetails(), this.searchRadiusM = 3000, required this.expiresAt, required this.createdAt, this.acceptedAt, this.arrivedAt, this.startedAt, this.completedAt, this.cancelledAt, this.cancelledBy, this.cancelReason, this.driverStars, this.passengerStars, this.commission, this.passenger, this.driver,  List<Offer> offers = const [], this.driversNotified = 0, this.driverLocation}): _offers = offers,super._();
  factory _Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

@override final  String id;
@override final  String status;
@override final  String serviceType;
@override final  String vehicleType;
@override final  RidePoint pickup;
@override final  RidePoint dropoff;
@override final  int distanceM;
@override final  int durationS;
@override final  String? routePolyline;
@override final  int recommendedFare;
@override final  int minFare;
@override final  int offeredFare;
@override final  int? finalFare;
@override@JsonKey() final  String paymentMethod;
@override final  String? comment;
@override@JsonKey() final  RideDetails details;
@override@JsonKey() final  int searchRadiusM;
@override final  DateTime expiresAt;
@override final  DateTime createdAt;
@override final  DateTime? acceptedAt;
@override final  DateTime? arrivedAt;
@override final  DateTime? startedAt;
@override final  DateTime? completedAt;
@override final  DateTime? cancelledAt;
@override final  String? cancelledBy;
@override final  String? cancelReason;
@override final  int? driverStars;
@override final  int? passengerStars;
@override final  int? commission;
@override final  PublicUser? passenger;
@override final  PublicDriver? driver;
 final  List<Offer> _offers;
@override@JsonKey() List<Offer> get offers {
  if (_offers is EqualUnmodifiableListView) return _offers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offers);
}

/// While searching: how many drivers got this request.
@override@JsonKey() final  int driversNotified;
/// Last known car position (assigned rides), so the map is not empty after reopening the app.
@override final  LiveLocation? driverLocation;

/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RideCopyWith<_Ride> get copyWith => __$RideCopyWithImpl<_Ride>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RideToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ride&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&(identical(other.dropoff, dropoff) || other.dropoff == dropoff)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.routePolyline, routePolyline) || other.routePolyline == routePolyline)&&(identical(other.recommendedFare, recommendedFare) || other.recommendedFare == recommendedFare)&&(identical(other.minFare, minFare) || other.minFare == minFare)&&(identical(other.offeredFare, offeredFare) || other.offeredFare == offeredFare)&&(identical(other.finalFare, finalFare) || other.finalFare == finalFare)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.details, details) || other.details == details)&&(identical(other.searchRadiusM, searchRadiusM) || other.searchRadiusM == searchRadiusM)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.arrivedAt, arrivedAt) || other.arrivedAt == arrivedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelledBy, cancelledBy) || other.cancelledBy == cancelledBy)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.driverStars, driverStars) || other.driverStars == driverStars)&&(identical(other.passengerStars, passengerStars) || other.passengerStars == passengerStars)&&(identical(other.commission, commission) || other.commission == commission)&&(identical(other.passenger, passenger) || other.passenger == passenger)&&(identical(other.driver, driver) || other.driver == driver)&&const DeepCollectionEquality().equals(other.offers, _offers)&&(identical(other.driversNotified, driversNotified) || other.driversNotified == driversNotified)&&(identical(other.driverLocation, driverLocation) || other.driverLocation == driverLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,status,serviceType,vehicleType,pickup,dropoff,distanceM,durationS,routePolyline,recommendedFare,minFare,offeredFare,finalFare,paymentMethod,comment,details,searchRadiusM,expiresAt,createdAt,acceptedAt,arrivedAt,startedAt,completedAt,cancelledAt,cancelledBy,cancelReason,driverStars,passengerStars,commission,passenger,driver,const DeepCollectionEquality().hash(_offers),driversNotified,driverLocation]);
}

@override
String toString() {
    return 'Ride(id: $id, status: $status, serviceType: $serviceType, vehicleType: $vehicleType, pickup: $pickup, dropoff: $dropoff, distanceM: $distanceM, durationS: $durationS, routePolyline: $routePolyline, recommendedFare: $recommendedFare, minFare: $minFare, offeredFare: $offeredFare, finalFare: $finalFare, paymentMethod: $paymentMethod, comment: $comment, details: $details, searchRadiusM: $searchRadiusM, expiresAt: $expiresAt, createdAt: $createdAt, acceptedAt: $acceptedAt, arrivedAt: $arrivedAt, startedAt: $startedAt, completedAt: $completedAt, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy, cancelReason: $cancelReason, driverStars: $driverStars, passengerStars: $passengerStars, commission: $commission, passenger: $passenger, driver: $driver, offers: $offers, driversNotified: $driversNotified, driverLocation: $driverLocation)';
}


}

/// @nodoc
abstract mixin class _$RideCopyWith<$Res> implements $RideCopyWith<$Res> {
  factory _$RideCopyWith(_Ride value, $Res Function(_Ride) _then) = __$RideCopyWithImpl;
@override @useResult
$Res call({
 String id, String status, String serviceType, String vehicleType, RidePoint pickup, RidePoint dropoff, int distanceM, int durationS, String? routePolyline, int recommendedFare, int minFare, int offeredFare, int? finalFare, String paymentMethod, String? comment, RideDetails details, int searchRadiusM, DateTime expiresAt, DateTime createdAt, DateTime? acceptedAt, DateTime? arrivedAt, DateTime? startedAt, DateTime? completedAt, DateTime? cancelledAt, String? cancelledBy, String? cancelReason, int? driverStars, int? passengerStars, int? commission, PublicUser? passenger, PublicDriver? driver, List<Offer> offers, int driversNotified, LiveLocation? driverLocation
});


@override $RidePointCopyWith<$Res> get pickup;@override $RidePointCopyWith<$Res> get dropoff;@override $RideDetailsCopyWith<$Res> get details;@override $PublicUserCopyWith<$Res>? get passenger;@override $PublicDriverCopyWith<$Res>? get driver;@override $LiveLocationCopyWith<$Res>? get driverLocation;

}
/// @nodoc
class __$RideCopyWithImpl<$Res>
    implements _$RideCopyWith<$Res> {
  __$RideCopyWithImpl(this._self, this._then);

  final _Ride _self;
  final $Res Function(_Ride) _then;

/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? serviceType = null,Object? vehicleType = null,Object? pickup = null,Object? dropoff = null,Object? distanceM = null,Object? durationS = null,Object? routePolyline = freezed,Object? recommendedFare = null,Object? minFare = null,Object? offeredFare = null,Object? finalFare = freezed,Object? paymentMethod = null,Object? comment = freezed,Object? details = null,Object? searchRadiusM = null,Object? expiresAt = null,Object? createdAt = null,Object? acceptedAt = freezed,Object? arrivedAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancelledBy = freezed,Object? cancelReason = freezed,Object? driverStars = freezed,Object? passengerStars = freezed,Object? commission = freezed,Object? passenger = freezed,Object? driver = freezed,Object? offers = null,Object? driversNotified = null,Object? driverLocation = freezed,}) {
  return _then(_Ride(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String,vehicleType: null == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String,pickup: null == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as RidePoint,dropoff: null == dropoff ? _self.dropoff : dropoff // ignore: cast_nullable_to_non_nullable
as RidePoint,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,routePolyline: freezed == routePolyline ? _self.routePolyline : routePolyline // ignore: cast_nullable_to_non_nullable
as String?,recommendedFare: null == recommendedFare ? _self.recommendedFare : recommendedFare // ignore: cast_nullable_to_non_nullable
as int,minFare: null == minFare ? _self.minFare : minFare // ignore: cast_nullable_to_non_nullable
as int,offeredFare: null == offeredFare ? _self.offeredFare : offeredFare // ignore: cast_nullable_to_non_nullable
as int,finalFare: freezed == finalFare ? _self.finalFare : finalFare // ignore: cast_nullable_to_non_nullable
as int?,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as RideDetails,searchRadiusM: null == searchRadiusM ? _self.searchRadiusM : searchRadiusM // ignore: cast_nullable_to_non_nullable
as int,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,arrivedAt: freezed == arrivedAt ? _self.arrivedAt : arrivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledBy: freezed == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as String?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,driverStars: freezed == driverStars ? _self.driverStars : driverStars // ignore: cast_nullable_to_non_nullable
as int?,passengerStars: freezed == passengerStars ? _self.passengerStars : passengerStars // ignore: cast_nullable_to_non_nullable
as int?,commission: freezed == commission ? _self.commission : commission // ignore: cast_nullable_to_non_nullable
as int?,passenger: freezed == passenger ? _self.passenger : passenger // ignore: cast_nullable_to_non_nullable
as PublicUser?,driver: freezed == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as PublicDriver?,offers: null == offers ? _self._offers : offers // ignore: cast_nullable_to_non_nullable
as List<Offer>,driversNotified: null == driversNotified ? _self.driversNotified : driversNotified // ignore: cast_nullable_to_non_nullable
as int,driverLocation: freezed == driverLocation ? _self.driverLocation : driverLocation // ignore: cast_nullable_to_non_nullable
as LiveLocation?,
  ));
}

/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RidePointCopyWith<$Res> get pickup {
  
  return $RidePointCopyWith<$Res>(_self.pickup, (value) {
    return _then(_self.copyWith(pickup: value));
  });
}/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RidePointCopyWith<$Res> get dropoff {
  
  return $RidePointCopyWith<$Res>(_self.dropoff, (value) {
    return _then(_self.copyWith(dropoff: value));
  });
}/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RideDetailsCopyWith<$Res> get details {
  
  return $RideDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicUserCopyWith<$Res>? get passenger {
    if (_self.passenger == null) {
    return null;
  }

  return $PublicUserCopyWith<$Res>(_self.passenger!, (value) {
    return _then(_self.copyWith(passenger: value));
  });
}/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicDriverCopyWith<$Res>? get driver {
    if (_self.driver == null) {
    return null;
  }

  return $PublicDriverCopyWith<$Res>(_self.driver!, (value) {
    return _then(_self.copyWith(driver: value));
  });
}/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveLocationCopyWith<$Res>? get driverLocation {
    if (_self.driverLocation == null) {
    return null;
  }

  return $LiveLocationCopyWith<$Res>(_self.driverLocation!, (value) {
    return _then(_self.copyWith(driverLocation: value));
  });
}
}


/// @nodoc
mixin _$DriverRequest {

 String get rideId; String get serviceType; String get vehicleType; RidePoint get pickup; RidePoint get dropoff; int get distanceM; int get durationS; String? get routePolyline; int get offeredFare; int get recommendedFare; String get paymentMethod; String? get comment; RideDetails get details; DateTime get createdAt; DateTime get expiresAt; PublicUser get passenger; int? get pickupDistanceM; int? get pickupEtaSec; MyOffer? get myOffer;
/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverRequestCopyWith<DriverRequest> get copyWith => _$DriverRequestCopyWithImpl<DriverRequest>(this as DriverRequest, _$identity);

  /// Serializes this DriverRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DriverRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverRequest&&(identical(other.rideId, _this.rideId) || other.rideId == _this.rideId)&&(identical(other.serviceType, _this.serviceType) || other.serviceType == _this.serviceType)&&(identical(other.vehicleType, _this.vehicleType) || other.vehicleType == _this.vehicleType)&&(identical(other.pickup, _this.pickup) || other.pickup == _this.pickup)&&(identical(other.dropoff, _this.dropoff) || other.dropoff == _this.dropoff)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM)&&(identical(other.durationS, _this.durationS) || other.durationS == _this.durationS)&&(identical(other.routePolyline, _this.routePolyline) || other.routePolyline == _this.routePolyline)&&(identical(other.offeredFare, _this.offeredFare) || other.offeredFare == _this.offeredFare)&&(identical(other.recommendedFare, _this.recommendedFare) || other.recommendedFare == _this.recommendedFare)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.comment, _this.comment) || other.comment == _this.comment)&&(identical(other.details, _this.details) || other.details == _this.details)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.passenger, _this.passenger) || other.passenger == _this.passenger)&&(identical(other.pickupDistanceM, _this.pickupDistanceM) || other.pickupDistanceM == _this.pickupDistanceM)&&(identical(other.pickupEtaSec, _this.pickupEtaSec) || other.pickupEtaSec == _this.pickupEtaSec)&&(identical(other.myOffer, _this.myOffer) || other.myOffer == _this.myOffer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DriverRequest;
  return Object.hashAll([runtimeType,_this.rideId,_this.serviceType,_this.vehicleType,_this.pickup,_this.dropoff,_this.distanceM,_this.durationS,_this.routePolyline,_this.offeredFare,_this.recommendedFare,_this.paymentMethod,_this.comment,_this.details,_this.createdAt,_this.expiresAt,_this.passenger,_this.pickupDistanceM,_this.pickupEtaSec,_this.myOffer]);
}

@override
String toString() {
  final _this = this as DriverRequest;
  return 'DriverRequest(rideId: ${_this.rideId}, serviceType: ${_this.serviceType}, vehicleType: ${_this.vehicleType}, pickup: ${_this.pickup}, dropoff: ${_this.dropoff}, distanceM: ${_this.distanceM}, durationS: ${_this.durationS}, routePolyline: ${_this.routePolyline}, offeredFare: ${_this.offeredFare}, recommendedFare: ${_this.recommendedFare}, paymentMethod: ${_this.paymentMethod}, comment: ${_this.comment}, details: ${_this.details}, createdAt: ${_this.createdAt}, expiresAt: ${_this.expiresAt}, passenger: ${_this.passenger}, pickupDistanceM: ${_this.pickupDistanceM}, pickupEtaSec: ${_this.pickupEtaSec}, myOffer: ${_this.myOffer})';
}


}

/// @nodoc
abstract mixin class $DriverRequestCopyWith<$Res>  {
  factory $DriverRequestCopyWith(DriverRequest value, $Res Function(DriverRequest) _then) = _$DriverRequestCopyWithImpl;
@useResult
$Res call({
 String rideId, String serviceType, String vehicleType, RidePoint pickup, RidePoint dropoff, int distanceM, int durationS, String? routePolyline, int offeredFare, int recommendedFare, String paymentMethod, String? comment, RideDetails details, DateTime createdAt, DateTime expiresAt, PublicUser passenger, int? pickupDistanceM, int? pickupEtaSec, MyOffer? myOffer
});


$RidePointCopyWith<$Res> get pickup;$RidePointCopyWith<$Res> get dropoff;$RideDetailsCopyWith<$Res> get details;$PublicUserCopyWith<$Res> get passenger;$MyOfferCopyWith<$Res>? get myOffer;

}
/// @nodoc
class _$DriverRequestCopyWithImpl<$Res>
    implements $DriverRequestCopyWith<$Res> {
  _$DriverRequestCopyWithImpl(this._self, this._then);

  final DriverRequest _self;
  final $Res Function(DriverRequest) _then;

/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rideId = null,Object? serviceType = null,Object? vehicleType = null,Object? pickup = null,Object? dropoff = null,Object? distanceM = null,Object? durationS = null,Object? routePolyline = freezed,Object? offeredFare = null,Object? recommendedFare = null,Object? paymentMethod = null,Object? comment = freezed,Object? details = null,Object? createdAt = null,Object? expiresAt = null,Object? passenger = null,Object? pickupDistanceM = freezed,Object? pickupEtaSec = freezed,Object? myOffer = freezed,}) {
  return _then(DriverRequest(
rideId: null == rideId ? _self.rideId : rideId // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String,vehicleType: null == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String,pickup: null == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as RidePoint,dropoff: null == dropoff ? _self.dropoff : dropoff // ignore: cast_nullable_to_non_nullable
as RidePoint,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,routePolyline: freezed == routePolyline ? _self.routePolyline : routePolyline // ignore: cast_nullable_to_non_nullable
as String?,offeredFare: null == offeredFare ? _self.offeredFare : offeredFare // ignore: cast_nullable_to_non_nullable
as int,recommendedFare: null == recommendedFare ? _self.recommendedFare : recommendedFare // ignore: cast_nullable_to_non_nullable
as int,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as RideDetails,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,passenger: null == passenger ? _self.passenger : passenger // ignore: cast_nullable_to_non_nullable
as PublicUser,pickupDistanceM: freezed == pickupDistanceM ? _self.pickupDistanceM : pickupDistanceM // ignore: cast_nullable_to_non_nullable
as int?,pickupEtaSec: freezed == pickupEtaSec ? _self.pickupEtaSec : pickupEtaSec // ignore: cast_nullable_to_non_nullable
as int?,myOffer: freezed == myOffer ? _self.myOffer : myOffer // ignore: cast_nullable_to_non_nullable
as MyOffer?,
  ));
}
/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RidePointCopyWith<$Res> get pickup {
  
  return $RidePointCopyWith<$Res>(_self.pickup, (value) {
    return _then(_self.copyWith(pickup: value));
  });
}/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RidePointCopyWith<$Res> get dropoff {
  
  return $RidePointCopyWith<$Res>(_self.dropoff, (value) {
    return _then(_self.copyWith(dropoff: value));
  });
}/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RideDetailsCopyWith<$Res> get details {
  
  return $RideDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicUserCopyWith<$Res> get passenger {
  
  return $PublicUserCopyWith<$Res>(_self.passenger, (value) {
    return _then(_self.copyWith(passenger: value));
  });
}/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyOfferCopyWith<$Res>? get myOffer {
    if (_self.myOffer == null) {
    return null;
  }

  return $MyOfferCopyWith<$Res>(_self.myOffer!, (value) {
    return _then(_self.copyWith(myOffer: value));
  });
}
}


/// Adds pattern-matching-related methods to [DriverRequest].
extension DriverRequestPatterns on DriverRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverRequest value)  $default,){
final _that = this;
switch (_that) {
case _DriverRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DriverRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rideId,  String serviceType,  String vehicleType,  RidePoint pickup,  RidePoint dropoff,  int distanceM,  int durationS,  String? routePolyline,  int offeredFare,  int recommendedFare,  String paymentMethod,  String? comment,  RideDetails details,  DateTime createdAt,  DateTime expiresAt,  PublicUser passenger,  int? pickupDistanceM,  int? pickupEtaSec,  MyOffer? myOffer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverRequest() when $default != null:
return $default(_that.rideId,_that.serviceType,_that.vehicleType,_that.pickup,_that.dropoff,_that.distanceM,_that.durationS,_that.routePolyline,_that.offeredFare,_that.recommendedFare,_that.paymentMethod,_that.comment,_that.details,_that.createdAt,_that.expiresAt,_that.passenger,_that.pickupDistanceM,_that.pickupEtaSec,_that.myOffer);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rideId,  String serviceType,  String vehicleType,  RidePoint pickup,  RidePoint dropoff,  int distanceM,  int durationS,  String? routePolyline,  int offeredFare,  int recommendedFare,  String paymentMethod,  String? comment,  RideDetails details,  DateTime createdAt,  DateTime expiresAt,  PublicUser passenger,  int? pickupDistanceM,  int? pickupEtaSec,  MyOffer? myOffer)  $default,) {final _that = this;
switch (_that) {
case _DriverRequest():
return $default(_that.rideId,_that.serviceType,_that.vehicleType,_that.pickup,_that.dropoff,_that.distanceM,_that.durationS,_that.routePolyline,_that.offeredFare,_that.recommendedFare,_that.paymentMethod,_that.comment,_that.details,_that.createdAt,_that.expiresAt,_that.passenger,_that.pickupDistanceM,_that.pickupEtaSec,_that.myOffer);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rideId,  String serviceType,  String vehicleType,  RidePoint pickup,  RidePoint dropoff,  int distanceM,  int durationS,  String? routePolyline,  int offeredFare,  int recommendedFare,  String paymentMethod,  String? comment,  RideDetails details,  DateTime createdAt,  DateTime expiresAt,  PublicUser passenger,  int? pickupDistanceM,  int? pickupEtaSec,  MyOffer? myOffer)?  $default,) {final _that = this;
switch (_that) {
case _DriverRequest() when $default != null:
return $default(_that.rideId,_that.serviceType,_that.vehicleType,_that.pickup,_that.dropoff,_that.distanceM,_that.durationS,_that.routePolyline,_that.offeredFare,_that.recommendedFare,_that.paymentMethod,_that.comment,_that.details,_that.createdAt,_that.expiresAt,_that.passenger,_that.pickupDistanceM,_that.pickupEtaSec,_that.myOffer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriverRequest implements DriverRequest {
  const _DriverRequest({required this.rideId, required this.serviceType, required this.vehicleType, required this.pickup, required this.dropoff, required this.distanceM, required this.durationS, this.routePolyline, required this.offeredFare, required this.recommendedFare, this.paymentMethod = 'cash', this.comment, this.details = const RideDetails(), required this.createdAt, required this.expiresAt, required this.passenger, this.pickupDistanceM, this.pickupEtaSec, this.myOffer});
  factory _DriverRequest.fromJson(Map<String, dynamic> json) => _$DriverRequestFromJson(json);

@override final  String rideId;
@override final  String serviceType;
@override final  String vehicleType;
@override final  RidePoint pickup;
@override final  RidePoint dropoff;
@override final  int distanceM;
@override final  int durationS;
@override final  String? routePolyline;
@override final  int offeredFare;
@override final  int recommendedFare;
@override@JsonKey() final  String paymentMethod;
@override final  String? comment;
@override@JsonKey() final  RideDetails details;
@override final  DateTime createdAt;
@override final  DateTime expiresAt;
@override final  PublicUser passenger;
@override final  int? pickupDistanceM;
@override final  int? pickupEtaSec;
@override final  MyOffer? myOffer;

/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverRequestCopyWith<_DriverRequest> get copyWith => __$DriverRequestCopyWithImpl<_DriverRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriverRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverRequest&&(identical(other.rideId, rideId) || other.rideId == rideId)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&(identical(other.dropoff, dropoff) || other.dropoff == dropoff)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.routePolyline, routePolyline) || other.routePolyline == routePolyline)&&(identical(other.offeredFare, offeredFare) || other.offeredFare == offeredFare)&&(identical(other.recommendedFare, recommendedFare) || other.recommendedFare == recommendedFare)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.details, details) || other.details == details)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.passenger, passenger) || other.passenger == passenger)&&(identical(other.pickupDistanceM, pickupDistanceM) || other.pickupDistanceM == pickupDistanceM)&&(identical(other.pickupEtaSec, pickupEtaSec) || other.pickupEtaSec == pickupEtaSec)&&(identical(other.myOffer, myOffer) || other.myOffer == myOffer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,rideId,serviceType,vehicleType,pickup,dropoff,distanceM,durationS,routePolyline,offeredFare,recommendedFare,paymentMethod,comment,details,createdAt,expiresAt,passenger,pickupDistanceM,pickupEtaSec,myOffer]);
}

@override
String toString() {
    return 'DriverRequest(rideId: $rideId, serviceType: $serviceType, vehicleType: $vehicleType, pickup: $pickup, dropoff: $dropoff, distanceM: $distanceM, durationS: $durationS, routePolyline: $routePolyline, offeredFare: $offeredFare, recommendedFare: $recommendedFare, paymentMethod: $paymentMethod, comment: $comment, details: $details, createdAt: $createdAt, expiresAt: $expiresAt, passenger: $passenger, pickupDistanceM: $pickupDistanceM, pickupEtaSec: $pickupEtaSec, myOffer: $myOffer)';
}


}

/// @nodoc
abstract mixin class _$DriverRequestCopyWith<$Res> implements $DriverRequestCopyWith<$Res> {
  factory _$DriverRequestCopyWith(_DriverRequest value, $Res Function(_DriverRequest) _then) = __$DriverRequestCopyWithImpl;
@override @useResult
$Res call({
 String rideId, String serviceType, String vehicleType, RidePoint pickup, RidePoint dropoff, int distanceM, int durationS, String? routePolyline, int offeredFare, int recommendedFare, String paymentMethod, String? comment, RideDetails details, DateTime createdAt, DateTime expiresAt, PublicUser passenger, int? pickupDistanceM, int? pickupEtaSec, MyOffer? myOffer
});


@override $RidePointCopyWith<$Res> get pickup;@override $RidePointCopyWith<$Res> get dropoff;@override $RideDetailsCopyWith<$Res> get details;@override $PublicUserCopyWith<$Res> get passenger;@override $MyOfferCopyWith<$Res>? get myOffer;

}
/// @nodoc
class __$DriverRequestCopyWithImpl<$Res>
    implements _$DriverRequestCopyWith<$Res> {
  __$DriverRequestCopyWithImpl(this._self, this._then);

  final _DriverRequest _self;
  final $Res Function(_DriverRequest) _then;

/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rideId = null,Object? serviceType = null,Object? vehicleType = null,Object? pickup = null,Object? dropoff = null,Object? distanceM = null,Object? durationS = null,Object? routePolyline = freezed,Object? offeredFare = null,Object? recommendedFare = null,Object? paymentMethod = null,Object? comment = freezed,Object? details = null,Object? createdAt = null,Object? expiresAt = null,Object? passenger = null,Object? pickupDistanceM = freezed,Object? pickupEtaSec = freezed,Object? myOffer = freezed,}) {
  return _then(_DriverRequest(
rideId: null == rideId ? _self.rideId : rideId // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String,vehicleType: null == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String,pickup: null == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as RidePoint,dropoff: null == dropoff ? _self.dropoff : dropoff // ignore: cast_nullable_to_non_nullable
as RidePoint,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,routePolyline: freezed == routePolyline ? _self.routePolyline : routePolyline // ignore: cast_nullable_to_non_nullable
as String?,offeredFare: null == offeredFare ? _self.offeredFare : offeredFare // ignore: cast_nullable_to_non_nullable
as int,recommendedFare: null == recommendedFare ? _self.recommendedFare : recommendedFare // ignore: cast_nullable_to_non_nullable
as int,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as RideDetails,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,passenger: null == passenger ? _self.passenger : passenger // ignore: cast_nullable_to_non_nullable
as PublicUser,pickupDistanceM: freezed == pickupDistanceM ? _self.pickupDistanceM : pickupDistanceM // ignore: cast_nullable_to_non_nullable
as int?,pickupEtaSec: freezed == pickupEtaSec ? _self.pickupEtaSec : pickupEtaSec // ignore: cast_nullable_to_non_nullable
as int?,myOffer: freezed == myOffer ? _self.myOffer : myOffer // ignore: cast_nullable_to_non_nullable
as MyOffer?,
  ));
}

/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RidePointCopyWith<$Res> get pickup {
  
  return $RidePointCopyWith<$Res>(_self.pickup, (value) {
    return _then(_self.copyWith(pickup: value));
  });
}/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RidePointCopyWith<$Res> get dropoff {
  
  return $RidePointCopyWith<$Res>(_self.dropoff, (value) {
    return _then(_self.copyWith(dropoff: value));
  });
}/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RideDetailsCopyWith<$Res> get details {
  
  return $RideDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PublicUserCopyWith<$Res> get passenger {
  
  return $PublicUserCopyWith<$Res>(_self.passenger, (value) {
    return _then(_self.copyWith(passenger: value));
  });
}/// Create a copy of DriverRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyOfferCopyWith<$Res>? get myOffer {
    if (_self.myOffer == null) {
    return null;
  }

  return $MyOfferCopyWith<$Res>(_self.myOffer!, (value) {
    return _then(_self.copyWith(myOffer: value));
  });
}
}


/// @nodoc
mixin _$MyOffer {

 String get id; int get price; String get status;
/// Create a copy of MyOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyOfferCopyWith<MyOffer> get copyWith => _$MyOfferCopyWithImpl<MyOffer>(this as MyOffer, _$identity);

  /// Serializes this MyOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MyOffer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyOffer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MyOffer;
  return Object.hash(runtimeType,_this.id,_this.price,_this.status);
}

@override
String toString() {
  final _this = this as MyOffer;
  return 'MyOffer(id: ${_this.id}, price: ${_this.price}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $MyOfferCopyWith<$Res>  {
  factory $MyOfferCopyWith(MyOffer value, $Res Function(MyOffer) _then) = _$MyOfferCopyWithImpl;
@useResult
$Res call({
 String id, int price, String status
});




}
/// @nodoc
class _$MyOfferCopyWithImpl<$Res>
    implements $MyOfferCopyWith<$Res> {
  _$MyOfferCopyWithImpl(this._self, this._then);

  final MyOffer _self;
  final $Res Function(MyOffer) _then;

/// Create a copy of MyOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? price = null,Object? status = null,}) {
  return _then(MyOffer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MyOffer].
extension MyOfferPatterns on MyOffer {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyOffer() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyOffer value)  $default,){
final _that = this;
switch (_that) {
case _MyOffer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyOffer value)?  $default,){
final _that = this;
switch (_that) {
case _MyOffer() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int price,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyOffer() when $default != null:
return $default(_that.id,_that.price,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int price,  String status)  $default,) {final _that = this;
switch (_that) {
case _MyOffer():
return $default(_that.id,_that.price,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int price,  String status)?  $default,) {final _that = this;
switch (_that) {
case _MyOffer() when $default != null:
return $default(_that.id,_that.price,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyOffer implements MyOffer {
  const _MyOffer({required this.id, required this.price, required this.status});
  factory _MyOffer.fromJson(Map<String, dynamic> json) => _$MyOfferFromJson(json);

@override final  String id;
@override final  int price;
@override final  String status;

/// Create a copy of MyOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyOfferCopyWith<_MyOffer> get copyWith => __$MyOfferCopyWithImpl<_MyOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyOfferToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.price, price) || other.price == price)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,price,status);
}

@override
String toString() {
    return 'MyOffer(id: $id, price: $price, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MyOfferCopyWith<$Res> implements $MyOfferCopyWith<$Res> {
  factory _$MyOfferCopyWith(_MyOffer value, $Res Function(_MyOffer) _then) = __$MyOfferCopyWithImpl;
@override @useResult
$Res call({
 String id, int price, String status
});




}
/// @nodoc
class __$MyOfferCopyWithImpl<$Res>
    implements _$MyOfferCopyWith<$Res> {
  __$MyOfferCopyWithImpl(this._self, this._then);

  final _MyOffer _self;
  final $Res Function(_MyOffer) _then;

/// Create a copy of MyOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? price = null,Object? status = null,}) {
  return _then(_MyOffer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LiveLocation {

 String get rideId; double get lat; double get lng; double? get heading; double? get speed; int? get distanceM; int? get etaSec; int? get distanceToPickupM;
/// Create a copy of LiveLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveLocationCopyWith<LiveLocation> get copyWith => _$LiveLocationCopyWithImpl<LiveLocation>(this as LiveLocation, _$identity);

  /// Serializes this LiveLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LiveLocation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveLocation&&(identical(other.rideId, _this.rideId) || other.rideId == _this.rideId)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.heading, _this.heading) || other.heading == _this.heading)&&(identical(other.speed, _this.speed) || other.speed == _this.speed)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM)&&(identical(other.etaSec, _this.etaSec) || other.etaSec == _this.etaSec)&&(identical(other.distanceToPickupM, _this.distanceToPickupM) || other.distanceToPickupM == _this.distanceToPickupM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LiveLocation;
  return Object.hash(runtimeType,_this.rideId,_this.lat,_this.lng,_this.heading,_this.speed,_this.distanceM,_this.etaSec,_this.distanceToPickupM);
}

@override
String toString() {
  final _this = this as LiveLocation;
  return 'LiveLocation(rideId: ${_this.rideId}, lat: ${_this.lat}, lng: ${_this.lng}, heading: ${_this.heading}, speed: ${_this.speed}, distanceM: ${_this.distanceM}, etaSec: ${_this.etaSec}, distanceToPickupM: ${_this.distanceToPickupM})';
}


}

/// @nodoc
abstract mixin class $LiveLocationCopyWith<$Res>  {
  factory $LiveLocationCopyWith(LiveLocation value, $Res Function(LiveLocation) _then) = _$LiveLocationCopyWithImpl;
@useResult
$Res call({
 String rideId, double lat, double lng, double? heading, double? speed, int? distanceM, int? etaSec, int? distanceToPickupM
});




}
/// @nodoc
class _$LiveLocationCopyWithImpl<$Res>
    implements $LiveLocationCopyWith<$Res> {
  _$LiveLocationCopyWithImpl(this._self, this._then);

  final LiveLocation _self;
  final $Res Function(LiveLocation) _then;

/// Create a copy of LiveLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rideId = null,Object? lat = null,Object? lng = null,Object? heading = freezed,Object? speed = freezed,Object? distanceM = freezed,Object? etaSec = freezed,Object? distanceToPickupM = freezed,}) {
  return _then(LiveLocation(
rideId: null == rideId ? _self.rideId : rideId // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,etaSec: freezed == etaSec ? _self.etaSec : etaSec // ignore: cast_nullable_to_non_nullable
as int?,distanceToPickupM: freezed == distanceToPickupM ? _self.distanceToPickupM : distanceToPickupM // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveLocation].
extension LiveLocationPatterns on LiveLocation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveLocation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveLocation value)  $default,){
final _that = this;
switch (_that) {
case _LiveLocation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveLocation value)?  $default,){
final _that = this;
switch (_that) {
case _LiveLocation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rideId,  double lat,  double lng,  double? heading,  double? speed,  int? distanceM,  int? etaSec,  int? distanceToPickupM)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveLocation() when $default != null:
return $default(_that.rideId,_that.lat,_that.lng,_that.heading,_that.speed,_that.distanceM,_that.etaSec,_that.distanceToPickupM);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rideId,  double lat,  double lng,  double? heading,  double? speed,  int? distanceM,  int? etaSec,  int? distanceToPickupM)  $default,) {final _that = this;
switch (_that) {
case _LiveLocation():
return $default(_that.rideId,_that.lat,_that.lng,_that.heading,_that.speed,_that.distanceM,_that.etaSec,_that.distanceToPickupM);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rideId,  double lat,  double lng,  double? heading,  double? speed,  int? distanceM,  int? etaSec,  int? distanceToPickupM)?  $default,) {final _that = this;
switch (_that) {
case _LiveLocation() when $default != null:
return $default(_that.rideId,_that.lat,_that.lng,_that.heading,_that.speed,_that.distanceM,_that.etaSec,_that.distanceToPickupM);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LiveLocation extends LiveLocation {
  const _LiveLocation({required this.rideId, required this.lat, required this.lng, this.heading, this.speed, this.distanceM, this.etaSec, this.distanceToPickupM}): super._();
  factory _LiveLocation.fromJson(Map<String, dynamic> json) => _$LiveLocationFromJson(json);

@override final  String rideId;
@override final  double lat;
@override final  double lng;
@override final  double? heading;
@override final  double? speed;
@override final  int? distanceM;
@override final  int? etaSec;
@override final  int? distanceToPickupM;

/// Create a copy of LiveLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveLocationCopyWith<_LiveLocation> get copyWith => __$LiveLocationCopyWithImpl<_LiveLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LiveLocationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveLocation&&(identical(other.rideId, rideId) || other.rideId == rideId)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.etaSec, etaSec) || other.etaSec == etaSec)&&(identical(other.distanceToPickupM, distanceToPickupM) || other.distanceToPickupM == distanceToPickupM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rideId,lat,lng,heading,speed,distanceM,etaSec,distanceToPickupM);
}

@override
String toString() {
    return 'LiveLocation(rideId: $rideId, lat: $lat, lng: $lng, heading: $heading, speed: $speed, distanceM: $distanceM, etaSec: $etaSec, distanceToPickupM: $distanceToPickupM)';
}


}

/// @nodoc
abstract mixin class _$LiveLocationCopyWith<$Res> implements $LiveLocationCopyWith<$Res> {
  factory _$LiveLocationCopyWith(_LiveLocation value, $Res Function(_LiveLocation) _then) = __$LiveLocationCopyWithImpl;
@override @useResult
$Res call({
 String rideId, double lat, double lng, double? heading, double? speed, int? distanceM, int? etaSec, int? distanceToPickupM
});




}
/// @nodoc
class __$LiveLocationCopyWithImpl<$Res>
    implements _$LiveLocationCopyWith<$Res> {
  __$LiveLocationCopyWithImpl(this._self, this._then);

  final _LiveLocation _self;
  final $Res Function(_LiveLocation) _then;

/// Create a copy of LiveLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rideId = null,Object? lat = null,Object? lng = null,Object? heading = freezed,Object? speed = freezed,Object? distanceM = freezed,Object? etaSec = freezed,Object? distanceToPickupM = freezed,}) {
  return _then(_LiveLocation(
rideId: null == rideId ? _self.rideId : rideId // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,etaSec: freezed == etaSec ? _self.etaSec : etaSec // ignore: cast_nullable_to_non_nullable
as int?,distanceToPickupM: freezed == distanceToPickupM ? _self.distanceToPickupM : distanceToPickupM // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
