// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String get id; String get phone; String? get name; String? get email; String? get photoUrl; String get language; double get rating; int get ratingCount; DateTime? get createdAt;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.ratingCount, _this.ratingCount) || other.ratingCount == _this.ratingCount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppUser;
  return Object.hash(runtimeType,_this.id,_this.phone,_this.name,_this.email,_this.photoUrl,_this.language,_this.rating,_this.ratingCount,_this.createdAt);
}

@override
String toString() {
  final _this = this as AppUser;
  return 'AppUser(id: ${_this.id}, phone: ${_this.phone}, name: ${_this.name}, email: ${_this.email}, photoUrl: ${_this.photoUrl}, language: ${_this.language}, rating: ${_this.rating}, ratingCount: ${_this.ratingCount}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String id, String phone, String? name, String? email, String? photoUrl, String language, double rating, int ratingCount, DateTime? createdAt
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? phone = null,Object? name = freezed,Object? email = freezed,Object? photoUrl = freezed,Object? language = null,Object? rating = null,Object? ratingCount = null,Object? createdAt = freezed,}) {
  return _then(AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String phone,  String? name,  String? email,  String? photoUrl,  String language,  double rating,  int ratingCount,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.phone,_that.name,_that.email,_that.photoUrl,_that.language,_that.rating,_that.ratingCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String phone,  String? name,  String? email,  String? photoUrl,  String language,  double rating,  int ratingCount,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.phone,_that.name,_that.email,_that.photoUrl,_that.language,_that.rating,_that.ratingCount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String phone,  String? name,  String? email,  String? photoUrl,  String language,  double rating,  int ratingCount,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.phone,_that.name,_that.email,_that.photoUrl,_that.language,_that.rating,_that.ratingCount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser implements AppUser {
  const _AppUser({required this.id, required this.phone, this.name, this.email, this.photoUrl, this.language = 'en', this.rating = 5, this.ratingCount = 0, this.createdAt});
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String id;
@override final  String phone;
@override final  String? name;
@override final  String? email;
@override final  String? photoUrl;
@override@JsonKey() final  String language;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int ratingCount;
@override final  DateTime? createdAt;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.language, language) || other.language == language)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,phone,name,email,photoUrl,language,rating,ratingCount,createdAt);
}

@override
String toString() {
    return 'AppUser(id: $id, phone: $phone, name: $name, email: $email, photoUrl: $photoUrl, language: $language, rating: $rating, ratingCount: $ratingCount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String phone, String? name, String? email, String? photoUrl, String language, double rating, int ratingCount, DateTime? createdAt
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? phone = null,Object? name = freezed,Object? email = freezed,Object? photoUrl = freezed,Object? language = null,Object? rating = null,Object? ratingCount = null,Object? createdAt = freezed,}) {
  return _then(_AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Vehicle {

 String get type; String get make; String get model; String get color; int? get year; String get plateNumber; String? get photoUrl;
/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleCopyWith<Vehicle> get copyWith => _$VehicleCopyWithImpl<Vehicle>(this as Vehicle, _$identity);

  /// Serializes this Vehicle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Vehicle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vehicle&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.make, _this.make) || other.make == _this.make)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.plateNumber, _this.plateNumber) || other.plateNumber == _this.plateNumber)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Vehicle;
  return Object.hash(runtimeType,_this.type,_this.make,_this.model,_this.color,_this.year,_this.plateNumber,_this.photoUrl);
}

@override
String toString() {
  final _this = this as Vehicle;
  return 'Vehicle(type: ${_this.type}, make: ${_this.make}, model: ${_this.model}, color: ${_this.color}, year: ${_this.year}, plateNumber: ${_this.plateNumber}, photoUrl: ${_this.photoUrl})';
}


}

/// @nodoc
abstract mixin class $VehicleCopyWith<$Res>  {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) _then) = _$VehicleCopyWithImpl;
@useResult
$Res call({
 String type, String make, String model, String color, int? year, String plateNumber, String? photoUrl
});




}
/// @nodoc
class _$VehicleCopyWithImpl<$Res>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._self, this._then);

  final Vehicle _self;
  final $Res Function(Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? make = null,Object? model = null,Object? color = null,Object? year = freezed,Object? plateNumber = null,Object? photoUrl = freezed,}) {
  return _then(Vehicle(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,plateNumber: null == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Vehicle].
extension VehiclePatterns on Vehicle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vehicle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vehicle value)  $default,){
final _that = this;
switch (_that) {
case _Vehicle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vehicle value)?  $default,){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String make,  String model,  String color,  int? year,  String plateNumber,  String? photoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.type,_that.make,_that.model,_that.color,_that.year,_that.plateNumber,_that.photoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String make,  String model,  String color,  int? year,  String plateNumber,  String? photoUrl)  $default,) {final _that = this;
switch (_that) {
case _Vehicle():
return $default(_that.type,_that.make,_that.model,_that.color,_that.year,_that.plateNumber,_that.photoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String make,  String model,  String color,  int? year,  String plateNumber,  String? photoUrl)?  $default,) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.type,_that.make,_that.model,_that.color,_that.year,_that.plateNumber,_that.photoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vehicle extends Vehicle {
  const _Vehicle({required this.type, required this.make, required this.model, required this.color, this.year, required this.plateNumber, this.photoUrl}): super._();
  factory _Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

@override final  String type;
@override final  String make;
@override final  String model;
@override final  String color;
@override final  int? year;
@override final  String plateNumber;
@override final  String? photoUrl;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleCopyWith<_Vehicle> get copyWith => __$VehicleCopyWithImpl<_Vehicle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vehicle&&(identical(other.type, type) || other.type == type)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.color, color) || other.color == color)&&(identical(other.year, year) || other.year == year)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,make,model,color,year,plateNumber,photoUrl);
}

@override
String toString() {
    return 'Vehicle(type: $type, make: $make, model: $model, color: $color, year: $year, plateNumber: $plateNumber, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class _$VehicleCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$VehicleCopyWith(_Vehicle value, $Res Function(_Vehicle) _then) = __$VehicleCopyWithImpl;
@override @useResult
$Res call({
 String type, String make, String model, String color, int? year, String plateNumber, String? photoUrl
});




}
/// @nodoc
class __$VehicleCopyWithImpl<$Res>
    implements _$VehicleCopyWith<$Res> {
  __$VehicleCopyWithImpl(this._self, this._then);

  final _Vehicle _self;
  final $Res Function(_Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? make = null,Object? model = null,Object? color = null,Object? year = freezed,Object? plateNumber = null,Object? photoUrl = freezed,}) {
  return _then(_Vehicle(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,plateNumber: null == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DriverProfile {

 String get status; String? get rejectionReason; String get cnicNumber; String get licenseNumber; Vehicle get vehicle; List<String> get services; Map<String, String> get docs; double get rating; int get ratingCount; int get balance; bool get isOnline;
/// Create a copy of DriverProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverProfileCopyWith<DriverProfile> get copyWith => _$DriverProfileCopyWithImpl<DriverProfile>(this as DriverProfile, _$identity);

  /// Serializes this DriverProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DriverProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverProfile&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.rejectionReason, _this.rejectionReason) || other.rejectionReason == _this.rejectionReason)&&(identical(other.cnicNumber, _this.cnicNumber) || other.cnicNumber == _this.cnicNumber)&&(identical(other.licenseNumber, _this.licenseNumber) || other.licenseNumber == _this.licenseNumber)&&(identical(other.vehicle, _this.vehicle) || other.vehicle == _this.vehicle)&&const DeepCollectionEquality().equals(other.services, _this.services)&&const DeepCollectionEquality().equals(other.docs, _this.docs)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.ratingCount, _this.ratingCount) || other.ratingCount == _this.ratingCount)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.isOnline, _this.isOnline) || other.isOnline == _this.isOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DriverProfile;
  return Object.hash(runtimeType,_this.status,_this.rejectionReason,_this.cnicNumber,_this.licenseNumber,_this.vehicle,const DeepCollectionEquality().hash(_this.services),const DeepCollectionEquality().hash(_this.docs),_this.rating,_this.ratingCount,_this.balance,_this.isOnline);
}

@override
String toString() {
  final _this = this as DriverProfile;
  return 'DriverProfile(status: ${_this.status}, rejectionReason: ${_this.rejectionReason}, cnicNumber: ${_this.cnicNumber}, licenseNumber: ${_this.licenseNumber}, vehicle: ${_this.vehicle}, services: ${_this.services}, docs: ${_this.docs}, rating: ${_this.rating}, ratingCount: ${_this.ratingCount}, balance: ${_this.balance}, isOnline: ${_this.isOnline})';
}


}

/// @nodoc
abstract mixin class $DriverProfileCopyWith<$Res>  {
  factory $DriverProfileCopyWith(DriverProfile value, $Res Function(DriverProfile) _then) = _$DriverProfileCopyWithImpl;
@useResult
$Res call({
 String status, String? rejectionReason, String cnicNumber, String licenseNumber, Vehicle vehicle, List<String> services, Map<String, String> docs, double rating, int ratingCount, int balance, bool isOnline
});


$VehicleCopyWith<$Res> get vehicle;

}
/// @nodoc
class _$DriverProfileCopyWithImpl<$Res>
    implements $DriverProfileCopyWith<$Res> {
  _$DriverProfileCopyWithImpl(this._self, this._then);

  final DriverProfile _self;
  final $Res Function(DriverProfile) _then;

/// Create a copy of DriverProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? rejectionReason = freezed,Object? cnicNumber = null,Object? licenseNumber = null,Object? vehicle = null,Object? services = null,Object? docs = null,Object? rating = null,Object? ratingCount = null,Object? balance = null,Object? isOnline = null,}) {
  return _then(DriverProfile(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,cnicNumber: null == cnicNumber ? _self.cnicNumber : cnicNumber // ignore: cast_nullable_to_non_nullable
as String,licenseNumber: null == licenseNumber ? _self.licenseNumber : licenseNumber // ignore: cast_nullable_to_non_nullable
as String,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as Vehicle,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<String>,docs: null == docs ? _self.docs : docs // ignore: cast_nullable_to_non_nullable
as Map<String, String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DriverProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleCopyWith<$Res> get vehicle {
  
  return $VehicleCopyWith<$Res>(_self.vehicle, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}


/// Adds pattern-matching-related methods to [DriverProfile].
extension DriverProfilePatterns on DriverProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverProfile value)  $default,){
final _that = this;
switch (_that) {
case _DriverProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverProfile value)?  $default,){
final _that = this;
switch (_that) {
case _DriverProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? rejectionReason,  String cnicNumber,  String licenseNumber,  Vehicle vehicle,  List<String> services,  Map<String, String> docs,  double rating,  int ratingCount,  int balance,  bool isOnline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverProfile() when $default != null:
return $default(_that.status,_that.rejectionReason,_that.cnicNumber,_that.licenseNumber,_that.vehicle,_that.services,_that.docs,_that.rating,_that.ratingCount,_that.balance,_that.isOnline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? rejectionReason,  String cnicNumber,  String licenseNumber,  Vehicle vehicle,  List<String> services,  Map<String, String> docs,  double rating,  int ratingCount,  int balance,  bool isOnline)  $default,) {final _that = this;
switch (_that) {
case _DriverProfile():
return $default(_that.status,_that.rejectionReason,_that.cnicNumber,_that.licenseNumber,_that.vehicle,_that.services,_that.docs,_that.rating,_that.ratingCount,_that.balance,_that.isOnline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? rejectionReason,  String cnicNumber,  String licenseNumber,  Vehicle vehicle,  List<String> services,  Map<String, String> docs,  double rating,  int ratingCount,  int balance,  bool isOnline)?  $default,) {final _that = this;
switch (_that) {
case _DriverProfile() when $default != null:
return $default(_that.status,_that.rejectionReason,_that.cnicNumber,_that.licenseNumber,_that.vehicle,_that.services,_that.docs,_that.rating,_that.ratingCount,_that.balance,_that.isOnline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriverProfile implements DriverProfile {
  const _DriverProfile({required this.status, this.rejectionReason, required this.cnicNumber, required this.licenseNumber, required this.vehicle,  List<String> services = const [],  Map<String, String> docs = const {}, this.rating = 5, this.ratingCount = 0, this.balance = 0, this.isOnline = false}): _services = services,_docs = docs;
  factory _DriverProfile.fromJson(Map<String, dynamic> json) => _$DriverProfileFromJson(json);

@override final  String status;
@override final  String? rejectionReason;
@override final  String cnicNumber;
@override final  String licenseNumber;
@override final  Vehicle vehicle;
 final  List<String> _services;
@override@JsonKey() List<String> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

 final  Map<String, String> _docs;
@override@JsonKey() Map<String, String> get docs {
  if (_docs is EqualUnmodifiableMapView) return _docs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_docs);
}

@override@JsonKey() final  double rating;
@override@JsonKey() final  int ratingCount;
@override@JsonKey() final  int balance;
@override@JsonKey() final  bool isOnline;

/// Create a copy of DriverProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverProfileCopyWith<_DriverProfile> get copyWith => __$DriverProfileCopyWithImpl<_DriverProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriverProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverProfile&&(identical(other.status, status) || other.status == status)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.cnicNumber, cnicNumber) || other.cnicNumber == cnicNumber)&&(identical(other.licenseNumber, licenseNumber) || other.licenseNumber == licenseNumber)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&const DeepCollectionEquality().equals(other.services, _services)&&const DeepCollectionEquality().equals(other.docs, _docs)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,rejectionReason,cnicNumber,licenseNumber,vehicle,const DeepCollectionEquality().hash(_services),const DeepCollectionEquality().hash(_docs),rating,ratingCount,balance,isOnline);
}

@override
String toString() {
    return 'DriverProfile(status: $status, rejectionReason: $rejectionReason, cnicNumber: $cnicNumber, licenseNumber: $licenseNumber, vehicle: $vehicle, services: $services, docs: $docs, rating: $rating, ratingCount: $ratingCount, balance: $balance, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class _$DriverProfileCopyWith<$Res> implements $DriverProfileCopyWith<$Res> {
  factory _$DriverProfileCopyWith(_DriverProfile value, $Res Function(_DriverProfile) _then) = __$DriverProfileCopyWithImpl;
@override @useResult
$Res call({
 String status, String? rejectionReason, String cnicNumber, String licenseNumber, Vehicle vehicle, List<String> services, Map<String, String> docs, double rating, int ratingCount, int balance, bool isOnline
});


@override $VehicleCopyWith<$Res> get vehicle;

}
/// @nodoc
class __$DriverProfileCopyWithImpl<$Res>
    implements _$DriverProfileCopyWith<$Res> {
  __$DriverProfileCopyWithImpl(this._self, this._then);

  final _DriverProfile _self;
  final $Res Function(_DriverProfile) _then;

/// Create a copy of DriverProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? rejectionReason = freezed,Object? cnicNumber = null,Object? licenseNumber = null,Object? vehicle = null,Object? services = null,Object? docs = null,Object? rating = null,Object? ratingCount = null,Object? balance = null,Object? isOnline = null,}) {
  return _then(_DriverProfile(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,cnicNumber: null == cnicNumber ? _self.cnicNumber : cnicNumber // ignore: cast_nullable_to_non_nullable
as String,licenseNumber: null == licenseNumber ? _self.licenseNumber : licenseNumber // ignore: cast_nullable_to_non_nullable
as String,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as Vehicle,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<String>,docs: null == docs ? _self._docs : docs // ignore: cast_nullable_to_non_nullable
as Map<String, String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DriverProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleCopyWith<$Res> get vehicle {
  
  return $VehicleCopyWith<$Res>(_self.vehicle, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}


/// @nodoc
mixin _$Me {

 AppUser get user; DriverProfile? get driver;
/// Create a copy of Me
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeCopyWith<Me> get copyWith => _$MeCopyWithImpl<Me>(this as Me, _$identity);

  /// Serializes this Me to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Me;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Me&&(identical(other.user, _this.user) || other.user == _this.user)&&(identical(other.driver, _this.driver) || other.driver == _this.driver));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Me;
  return Object.hash(runtimeType,_this.user,_this.driver);
}

@override
String toString() {
  final _this = this as Me;
  return 'Me(user: ${_this.user}, driver: ${_this.driver})';
}


}

/// @nodoc
abstract mixin class $MeCopyWith<$Res>  {
  factory $MeCopyWith(Me value, $Res Function(Me) _then) = _$MeCopyWithImpl;
@useResult
$Res call({
 AppUser user, DriverProfile? driver
});


$AppUserCopyWith<$Res> get user;$DriverProfileCopyWith<$Res>? get driver;

}
/// @nodoc
class _$MeCopyWithImpl<$Res>
    implements $MeCopyWith<$Res> {
  _$MeCopyWithImpl(this._self, this._then);

  final Me _self;
  final $Res Function(Me) _then;

/// Create a copy of Me
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? driver = freezed,}) {
  return _then(Me(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,driver: freezed == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as DriverProfile?,
  ));
}
/// Create a copy of Me
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of Me
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverProfileCopyWith<$Res>? get driver {
    if (_self.driver == null) {
    return null;
  }

  return $DriverProfileCopyWith<$Res>(_self.driver!, (value) {
    return _then(_self.copyWith(driver: value));
  });
}
}


/// Adds pattern-matching-related methods to [Me].
extension MePatterns on Me {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Me value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Me() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Me value)  $default,){
final _that = this;
switch (_that) {
case _Me():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Me value)?  $default,){
final _that = this;
switch (_that) {
case _Me() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppUser user,  DriverProfile? driver)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Me() when $default != null:
return $default(_that.user,_that.driver);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppUser user,  DriverProfile? driver)  $default,) {final _that = this;
switch (_that) {
case _Me():
return $default(_that.user,_that.driver);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppUser user,  DriverProfile? driver)?  $default,) {final _that = this;
switch (_that) {
case _Me() when $default != null:
return $default(_that.user,_that.driver);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Me implements Me {
  const _Me({required this.user, this.driver});
  factory _Me.fromJson(Map<String, dynamic> json) => _$MeFromJson(json);

@override final  AppUser user;
@override final  DriverProfile? driver;

/// Create a copy of Me
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeCopyWith<_Me> get copyWith => __$MeCopyWithImpl<_Me>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Me&&(identical(other.user, user) || other.user == user)&&(identical(other.driver, driver) || other.driver == driver));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,user,driver);
}

@override
String toString() {
    return 'Me(user: $user, driver: $driver)';
}


}

/// @nodoc
abstract mixin class _$MeCopyWith<$Res> implements $MeCopyWith<$Res> {
  factory _$MeCopyWith(_Me value, $Res Function(_Me) _then) = __$MeCopyWithImpl;
@override @useResult
$Res call({
 AppUser user, DriverProfile? driver
});


@override $AppUserCopyWith<$Res> get user;@override $DriverProfileCopyWith<$Res>? get driver;

}
/// @nodoc
class __$MeCopyWithImpl<$Res>
    implements _$MeCopyWith<$Res> {
  __$MeCopyWithImpl(this._self, this._then);

  final _Me _self;
  final $Res Function(_Me) _then;

/// Create a copy of Me
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? driver = freezed,}) {
  return _then(_Me(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,driver: freezed == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as DriverProfile?,
  ));
}

/// Create a copy of Me
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of Me
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverProfileCopyWith<$Res>? get driver {
    if (_self.driver == null) {
    return null;
  }

  return $DriverProfileCopyWith<$Res>(_self.driver!, (value) {
    return _then(_self.copyWith(driver: value));
  });
}
}


/// @nodoc
mixin _$PublicUser {

 String get id; String get name; String? get photoUrl; double get rating; int get ratingCount; String? get phone;
/// Create a copy of PublicUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicUserCopyWith<PublicUser> get copyWith => _$PublicUserCopyWithImpl<PublicUser>(this as PublicUser, _$identity);

  /// Serializes this PublicUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PublicUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.ratingCount, _this.ratingCount) || other.ratingCount == _this.ratingCount)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PublicUser;
  return Object.hash(runtimeType,_this.id,_this.name,_this.photoUrl,_this.rating,_this.ratingCount,_this.phone);
}

@override
String toString() {
  final _this = this as PublicUser;
  return 'PublicUser(id: ${_this.id}, name: ${_this.name}, photoUrl: ${_this.photoUrl}, rating: ${_this.rating}, ratingCount: ${_this.ratingCount}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $PublicUserCopyWith<$Res>  {
  factory $PublicUserCopyWith(PublicUser value, $Res Function(PublicUser) _then) = _$PublicUserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? photoUrl, double rating, int ratingCount, String? phone
});




}
/// @nodoc
class _$PublicUserCopyWithImpl<$Res>
    implements $PublicUserCopyWith<$Res> {
  _$PublicUserCopyWithImpl(this._self, this._then);

  final PublicUser _self;
  final $Res Function(PublicUser) _then;

/// Create a copy of PublicUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? photoUrl = freezed,Object? rating = null,Object? ratingCount = null,Object? phone = freezed,}) {
  return _then(PublicUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicUser].
extension PublicUserPatterns on PublicUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicUser value)  $default,){
final _that = this;
switch (_that) {
case _PublicUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicUser value)?  $default,){
final _that = this;
switch (_that) {
case _PublicUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? photoUrl,  double rating,  int ratingCount,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicUser() when $default != null:
return $default(_that.id,_that.name,_that.photoUrl,_that.rating,_that.ratingCount,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? photoUrl,  double rating,  int ratingCount,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _PublicUser():
return $default(_that.id,_that.name,_that.photoUrl,_that.rating,_that.ratingCount,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? photoUrl,  double rating,  int ratingCount,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _PublicUser() when $default != null:
return $default(_that.id,_that.name,_that.photoUrl,_that.rating,_that.ratingCount,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicUser implements PublicUser {
  const _PublicUser({required this.id, required this.name, this.photoUrl, this.rating = 5, this.ratingCount = 0, this.phone});
  factory _PublicUser.fromJson(Map<String, dynamic> json) => _$PublicUserFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? photoUrl;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int ratingCount;
@override final  String? phone;

/// Create a copy of PublicUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicUserCopyWith<_PublicUser> get copyWith => __$PublicUserCopyWithImpl<_PublicUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,photoUrl,rating,ratingCount,phone);
}

@override
String toString() {
    return 'PublicUser(id: $id, name: $name, photoUrl: $photoUrl, rating: $rating, ratingCount: $ratingCount, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$PublicUserCopyWith<$Res> implements $PublicUserCopyWith<$Res> {
  factory _$PublicUserCopyWith(_PublicUser value, $Res Function(_PublicUser) _then) = __$PublicUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? photoUrl, double rating, int ratingCount, String? phone
});




}
/// @nodoc
class __$PublicUserCopyWithImpl<$Res>
    implements _$PublicUserCopyWith<$Res> {
  __$PublicUserCopyWithImpl(this._self, this._then);

  final _PublicUser _self;
  final $Res Function(_PublicUser) _then;

/// Create a copy of PublicUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? photoUrl = freezed,Object? rating = null,Object? ratingCount = null,Object? phone = freezed,}) {
  return _then(_PublicUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PublicDriver {

 String get id; String get name; String? get photoUrl; double get rating; int get ratingCount; int get tripsCount; Vehicle get vehicle; String? get phone;
/// Create a copy of PublicDriver
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicDriverCopyWith<PublicDriver> get copyWith => _$PublicDriverCopyWithImpl<PublicDriver>(this as PublicDriver, _$identity);

  /// Serializes this PublicDriver to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PublicDriver;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicDriver&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.ratingCount, _this.ratingCount) || other.ratingCount == _this.ratingCount)&&(identical(other.tripsCount, _this.tripsCount) || other.tripsCount == _this.tripsCount)&&(identical(other.vehicle, _this.vehicle) || other.vehicle == _this.vehicle)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PublicDriver;
  return Object.hash(runtimeType,_this.id,_this.name,_this.photoUrl,_this.rating,_this.ratingCount,_this.tripsCount,_this.vehicle,_this.phone);
}

@override
String toString() {
  final _this = this as PublicDriver;
  return 'PublicDriver(id: ${_this.id}, name: ${_this.name}, photoUrl: ${_this.photoUrl}, rating: ${_this.rating}, ratingCount: ${_this.ratingCount}, tripsCount: ${_this.tripsCount}, vehicle: ${_this.vehicle}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $PublicDriverCopyWith<$Res>  {
  factory $PublicDriverCopyWith(PublicDriver value, $Res Function(PublicDriver) _then) = _$PublicDriverCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? photoUrl, double rating, int ratingCount, int tripsCount, Vehicle vehicle, String? phone
});


$VehicleCopyWith<$Res> get vehicle;

}
/// @nodoc
class _$PublicDriverCopyWithImpl<$Res>
    implements $PublicDriverCopyWith<$Res> {
  _$PublicDriverCopyWithImpl(this._self, this._then);

  final PublicDriver _self;
  final $Res Function(PublicDriver) _then;

/// Create a copy of PublicDriver
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? photoUrl = freezed,Object? rating = null,Object? ratingCount = null,Object? tripsCount = null,Object? vehicle = null,Object? phone = freezed,}) {
  return _then(PublicDriver(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,tripsCount: null == tripsCount ? _self.tripsCount : tripsCount // ignore: cast_nullable_to_non_nullable
as int,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as Vehicle,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PublicDriver
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleCopyWith<$Res> get vehicle {
  
  return $VehicleCopyWith<$Res>(_self.vehicle, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}


/// Adds pattern-matching-related methods to [PublicDriver].
extension PublicDriverPatterns on PublicDriver {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicDriver value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicDriver() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicDriver value)  $default,){
final _that = this;
switch (_that) {
case _PublicDriver():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicDriver value)?  $default,){
final _that = this;
switch (_that) {
case _PublicDriver() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? photoUrl,  double rating,  int ratingCount,  int tripsCount,  Vehicle vehicle,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicDriver() when $default != null:
return $default(_that.id,_that.name,_that.photoUrl,_that.rating,_that.ratingCount,_that.tripsCount,_that.vehicle,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? photoUrl,  double rating,  int ratingCount,  int tripsCount,  Vehicle vehicle,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _PublicDriver():
return $default(_that.id,_that.name,_that.photoUrl,_that.rating,_that.ratingCount,_that.tripsCount,_that.vehicle,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? photoUrl,  double rating,  int ratingCount,  int tripsCount,  Vehicle vehicle,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _PublicDriver() when $default != null:
return $default(_that.id,_that.name,_that.photoUrl,_that.rating,_that.ratingCount,_that.tripsCount,_that.vehicle,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicDriver implements PublicDriver {
  const _PublicDriver({required this.id, required this.name, this.photoUrl, this.rating = 5, this.ratingCount = 0, this.tripsCount = 0, required this.vehicle, this.phone});
  factory _PublicDriver.fromJson(Map<String, dynamic> json) => _$PublicDriverFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? photoUrl;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int ratingCount;
@override@JsonKey() final  int tripsCount;
@override final  Vehicle vehicle;
@override final  String? phone;

/// Create a copy of PublicDriver
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicDriverCopyWith<_PublicDriver> get copyWith => __$PublicDriverCopyWithImpl<_PublicDriver>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicDriverToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicDriver&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.tripsCount, tripsCount) || other.tripsCount == tripsCount)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,photoUrl,rating,ratingCount,tripsCount,vehicle,phone);
}

@override
String toString() {
    return 'PublicDriver(id: $id, name: $name, photoUrl: $photoUrl, rating: $rating, ratingCount: $ratingCount, tripsCount: $tripsCount, vehicle: $vehicle, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$PublicDriverCopyWith<$Res> implements $PublicDriverCopyWith<$Res> {
  factory _$PublicDriverCopyWith(_PublicDriver value, $Res Function(_PublicDriver) _then) = __$PublicDriverCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? photoUrl, double rating, int ratingCount, int tripsCount, Vehicle vehicle, String? phone
});


@override $VehicleCopyWith<$Res> get vehicle;

}
/// @nodoc
class __$PublicDriverCopyWithImpl<$Res>
    implements _$PublicDriverCopyWith<$Res> {
  __$PublicDriverCopyWithImpl(this._self, this._then);

  final _PublicDriver _self;
  final $Res Function(_PublicDriver) _then;

/// Create a copy of PublicDriver
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? photoUrl = freezed,Object? rating = null,Object? ratingCount = null,Object? tripsCount = null,Object? vehicle = null,Object? phone = freezed,}) {
  return _then(_PublicDriver(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,tripsCount: null == tripsCount ? _self.tripsCount : tripsCount // ignore: cast_nullable_to_non_nullable
as int,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as Vehicle,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PublicDriver
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleCopyWith<$Res> get vehicle {
  
  return $VehicleCopyWith<$Res>(_self.vehicle, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}

// dart format on
