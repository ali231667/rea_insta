// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FareOption {

 String get vehicleType; String get label; int get recommendedFare; int get minFare; int get maxFare;
/// Create a copy of FareOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FareOptionCopyWith<FareOption> get copyWith => _$FareOptionCopyWithImpl<FareOption>(this as FareOption, _$identity);

  /// Serializes this FareOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FareOption;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FareOption&&(identical(other.vehicleType, _this.vehicleType) || other.vehicleType == _this.vehicleType)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.recommendedFare, _this.recommendedFare) || other.recommendedFare == _this.recommendedFare)&&(identical(other.minFare, _this.minFare) || other.minFare == _this.minFare)&&(identical(other.maxFare, _this.maxFare) || other.maxFare == _this.maxFare));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FareOption;
  return Object.hash(runtimeType,_this.vehicleType,_this.label,_this.recommendedFare,_this.minFare,_this.maxFare);
}

@override
String toString() {
  final _this = this as FareOption;
  return 'FareOption(vehicleType: ${_this.vehicleType}, label: ${_this.label}, recommendedFare: ${_this.recommendedFare}, minFare: ${_this.minFare}, maxFare: ${_this.maxFare})';
}


}

/// @nodoc
abstract mixin class $FareOptionCopyWith<$Res>  {
  factory $FareOptionCopyWith(FareOption value, $Res Function(FareOption) _then) = _$FareOptionCopyWithImpl;
@useResult
$Res call({
 String vehicleType, String label, int recommendedFare, int minFare, int maxFare
});




}
/// @nodoc
class _$FareOptionCopyWithImpl<$Res>
    implements $FareOptionCopyWith<$Res> {
  _$FareOptionCopyWithImpl(this._self, this._then);

  final FareOption _self;
  final $Res Function(FareOption) _then;

/// Create a copy of FareOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vehicleType = null,Object? label = null,Object? recommendedFare = null,Object? minFare = null,Object? maxFare = null,}) {
  return _then(FareOption(
vehicleType: null == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recommendedFare: null == recommendedFare ? _self.recommendedFare : recommendedFare // ignore: cast_nullable_to_non_nullable
as int,minFare: null == minFare ? _self.minFare : minFare // ignore: cast_nullable_to_non_nullable
as int,maxFare: null == maxFare ? _self.maxFare : maxFare // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FareOption].
extension FareOptionPatterns on FareOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FareOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FareOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FareOption value)  $default,){
final _that = this;
switch (_that) {
case _FareOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FareOption value)?  $default,){
final _that = this;
switch (_that) {
case _FareOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String vehicleType,  String label,  int recommendedFare,  int minFare,  int maxFare)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FareOption() when $default != null:
return $default(_that.vehicleType,_that.label,_that.recommendedFare,_that.minFare,_that.maxFare);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String vehicleType,  String label,  int recommendedFare,  int minFare,  int maxFare)  $default,) {final _that = this;
switch (_that) {
case _FareOption():
return $default(_that.vehicleType,_that.label,_that.recommendedFare,_that.minFare,_that.maxFare);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String vehicleType,  String label,  int recommendedFare,  int minFare,  int maxFare)?  $default,) {final _that = this;
switch (_that) {
case _FareOption() when $default != null:
return $default(_that.vehicleType,_that.label,_that.recommendedFare,_that.minFare,_that.maxFare);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FareOption implements FareOption {
  const _FareOption({required this.vehicleType, required this.label, required this.recommendedFare, required this.minFare, required this.maxFare});
  factory _FareOption.fromJson(Map<String, dynamic> json) => _$FareOptionFromJson(json);

@override final  String vehicleType;
@override final  String label;
@override final  int recommendedFare;
@override final  int minFare;
@override final  int maxFare;

/// Create a copy of FareOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FareOptionCopyWith<_FareOption> get copyWith => __$FareOptionCopyWithImpl<_FareOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FareOptionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FareOption&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.label, label) || other.label == label)&&(identical(other.recommendedFare, recommendedFare) || other.recommendedFare == recommendedFare)&&(identical(other.minFare, minFare) || other.minFare == minFare)&&(identical(other.maxFare, maxFare) || other.maxFare == maxFare));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,vehicleType,label,recommendedFare,minFare,maxFare);
}

@override
String toString() {
    return 'FareOption(vehicleType: $vehicleType, label: $label, recommendedFare: $recommendedFare, minFare: $minFare, maxFare: $maxFare)';
}


}

/// @nodoc
abstract mixin class _$FareOptionCopyWith<$Res> implements $FareOptionCopyWith<$Res> {
  factory _$FareOptionCopyWith(_FareOption value, $Res Function(_FareOption) _then) = __$FareOptionCopyWithImpl;
@override @useResult
$Res call({
 String vehicleType, String label, int recommendedFare, int minFare, int maxFare
});




}
/// @nodoc
class __$FareOptionCopyWithImpl<$Res>
    implements _$FareOptionCopyWith<$Res> {
  __$FareOptionCopyWithImpl(this._self, this._then);

  final _FareOption _self;
  final $Res Function(_FareOption) _then;

/// Create a copy of FareOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vehicleType = null,Object? label = null,Object? recommendedFare = null,Object? minFare = null,Object? maxFare = null,}) {
  return _then(_FareOption(
vehicleType: null == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recommendedFare: null == recommendedFare ? _self.recommendedFare : recommendedFare // ignore: cast_nullable_to_non_nullable
as int,minFare: null == minFare ? _self.minFare : minFare // ignore: cast_nullable_to_non_nullable
as int,maxFare: null == maxFare ? _self.maxFare : maxFare // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FareEstimate {

 int get distanceM; int get durationS; String? get routePolyline; String? get routeSource; List<FareOption> get options;
/// Create a copy of FareEstimate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FareEstimateCopyWith<FareEstimate> get copyWith => _$FareEstimateCopyWithImpl<FareEstimate>(this as FareEstimate, _$identity);

  /// Serializes this FareEstimate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FareEstimate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FareEstimate&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM)&&(identical(other.durationS, _this.durationS) || other.durationS == _this.durationS)&&(identical(other.routePolyline, _this.routePolyline) || other.routePolyline == _this.routePolyline)&&(identical(other.routeSource, _this.routeSource) || other.routeSource == _this.routeSource)&&const DeepCollectionEquality().equals(other.options, _this.options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FareEstimate;
  return Object.hash(runtimeType,_this.distanceM,_this.durationS,_this.routePolyline,_this.routeSource,const DeepCollectionEquality().hash(_this.options));
}

@override
String toString() {
  final _this = this as FareEstimate;
  return 'FareEstimate(distanceM: ${_this.distanceM}, durationS: ${_this.durationS}, routePolyline: ${_this.routePolyline}, routeSource: ${_this.routeSource}, options: ${_this.options})';
}


}

/// @nodoc
abstract mixin class $FareEstimateCopyWith<$Res>  {
  factory $FareEstimateCopyWith(FareEstimate value, $Res Function(FareEstimate) _then) = _$FareEstimateCopyWithImpl;
@useResult
$Res call({
 int distanceM, int durationS, String? routePolyline, String? routeSource, List<FareOption> options
});




}
/// @nodoc
class _$FareEstimateCopyWithImpl<$Res>
    implements $FareEstimateCopyWith<$Res> {
  _$FareEstimateCopyWithImpl(this._self, this._then);

  final FareEstimate _self;
  final $Res Function(FareEstimate) _then;

/// Create a copy of FareEstimate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? distanceM = null,Object? durationS = null,Object? routePolyline = freezed,Object? routeSource = freezed,Object? options = null,}) {
  return _then(FareEstimate(
distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,routePolyline: freezed == routePolyline ? _self.routePolyline : routePolyline // ignore: cast_nullable_to_non_nullable
as String?,routeSource: freezed == routeSource ? _self.routeSource : routeSource // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<FareOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [FareEstimate].
extension FareEstimatePatterns on FareEstimate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FareEstimate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FareEstimate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FareEstimate value)  $default,){
final _that = this;
switch (_that) {
case _FareEstimate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FareEstimate value)?  $default,){
final _that = this;
switch (_that) {
case _FareEstimate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int distanceM,  int durationS,  String? routePolyline,  String? routeSource,  List<FareOption> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FareEstimate() when $default != null:
return $default(_that.distanceM,_that.durationS,_that.routePolyline,_that.routeSource,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int distanceM,  int durationS,  String? routePolyline,  String? routeSource,  List<FareOption> options)  $default,) {final _that = this;
switch (_that) {
case _FareEstimate():
return $default(_that.distanceM,_that.durationS,_that.routePolyline,_that.routeSource,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int distanceM,  int durationS,  String? routePolyline,  String? routeSource,  List<FareOption> options)?  $default,) {final _that = this;
switch (_that) {
case _FareEstimate() when $default != null:
return $default(_that.distanceM,_that.durationS,_that.routePolyline,_that.routeSource,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FareEstimate implements FareEstimate {
  const _FareEstimate({required this.distanceM, required this.durationS, this.routePolyline, this.routeSource, required  List<FareOption> options}): _options = options;
  factory _FareEstimate.fromJson(Map<String, dynamic> json) => _$FareEstimateFromJson(json);

@override final  int distanceM;
@override final  int durationS;
@override final  String? routePolyline;
@override final  String? routeSource;
 final  List<FareOption> _options;
@override List<FareOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of FareEstimate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FareEstimateCopyWith<_FareEstimate> get copyWith => __$FareEstimateCopyWithImpl<_FareEstimate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FareEstimateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FareEstimate&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.routePolyline, routePolyline) || other.routePolyline == routePolyline)&&(identical(other.routeSource, routeSource) || other.routeSource == routeSource)&&const DeepCollectionEquality().equals(other.options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,distanceM,durationS,routePolyline,routeSource,const DeepCollectionEquality().hash(_options));
}

@override
String toString() {
    return 'FareEstimate(distanceM: $distanceM, durationS: $durationS, routePolyline: $routePolyline, routeSource: $routeSource, options: $options)';
}


}

/// @nodoc
abstract mixin class _$FareEstimateCopyWith<$Res> implements $FareEstimateCopyWith<$Res> {
  factory _$FareEstimateCopyWith(_FareEstimate value, $Res Function(_FareEstimate) _then) = __$FareEstimateCopyWithImpl;
@override @useResult
$Res call({
 int distanceM, int durationS, String? routePolyline, String? routeSource, List<FareOption> options
});




}
/// @nodoc
class __$FareEstimateCopyWithImpl<$Res>
    implements _$FareEstimateCopyWith<$Res> {
  __$FareEstimateCopyWithImpl(this._self, this._then);

  final _FareEstimate _self;
  final $Res Function(_FareEstimate) _then;

/// Create a copy of FareEstimate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? distanceM = null,Object? durationS = null,Object? routePolyline = freezed,Object? routeSource = freezed,Object? options = null,}) {
  return _then(_FareEstimate(
distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,routePolyline: freezed == routePolyline ? _self.routePolyline : routePolyline // ignore: cast_nullable_to_non_nullable
as String?,routeSource: freezed == routeSource ? _self.routeSource : routeSource // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<FareOption>,
  ));
}


}


/// @nodoc
mixin _$Place {

 String? get id; String? get label; String get name; String get address; double get lat; double get lng;
/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceCopyWith<Place> get copyWith => _$PlaceCopyWithImpl<Place>(this as Place, _$identity);

  /// Serializes this Place to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Place;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Place&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Place;
  return Object.hash(runtimeType,_this.id,_this.label,_this.name,_this.address,_this.lat,_this.lng);
}

@override
String toString() {
  final _this = this as Place;
  return 'Place(id: ${_this.id}, label: ${_this.label}, name: ${_this.name}, address: ${_this.address}, lat: ${_this.lat}, lng: ${_this.lng})';
}


}

/// @nodoc
abstract mixin class $PlaceCopyWith<$Res>  {
  factory $PlaceCopyWith(Place value, $Res Function(Place) _then) = _$PlaceCopyWithImpl;
@useResult
$Res call({
 String? id, String? label, String name, String address, double lat, double lng
});




}
/// @nodoc
class _$PlaceCopyWithImpl<$Res>
    implements $PlaceCopyWith<$Res> {
  _$PlaceCopyWithImpl(this._self, this._then);

  final Place _self;
  final $Res Function(Place) _then;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? label = freezed,Object? name = null,Object? address = null,Object? lat = null,Object? lng = null,}) {
  return _then(Place(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Place].
extension PlacePatterns on Place {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Place value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Place() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Place value)  $default,){
final _that = this;
switch (_that) {
case _Place():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Place value)?  $default,){
final _that = this;
switch (_that) {
case _Place() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? label,  String name,  String address,  double lat,  double lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that.id,_that.label,_that.name,_that.address,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? label,  String name,  String address,  double lat,  double lng)  $default,) {final _that = this;
switch (_that) {
case _Place():
return $default(_that.id,_that.label,_that.name,_that.address,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? label,  String name,  String address,  double lat,  double lng)?  $default,) {final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that.id,_that.label,_that.name,_that.address,_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Place extends Place {
  const _Place({this.id, this.label, required this.name, required this.address, required this.lat, required this.lng}): super._();
  factory _Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

@override final  String? id;
@override final  String? label;
@override final  String name;
@override final  String address;
@override final  double lat;
@override final  double lng;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceCopyWith<_Place> get copyWith => __$PlaceCopyWithImpl<_Place>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Place&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,label,name,address,lat,lng);
}

@override
String toString() {
    return 'Place(id: $id, label: $label, name: $name, address: $address, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$PlaceCopyWith<$Res> implements $PlaceCopyWith<$Res> {
  factory _$PlaceCopyWith(_Place value, $Res Function(_Place) _then) = __$PlaceCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? label, String name, String address, double lat, double lng
});




}
/// @nodoc
class __$PlaceCopyWithImpl<$Res>
    implements _$PlaceCopyWith<$Res> {
  __$PlaceCopyWithImpl(this._self, this._then);

  final _Place _self;
  final $Res Function(_Place) _then;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? label = freezed,Object? name = null,Object? address = null,Object? lat = null,Object? lng = null,}) {
  return _then(_Place(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ChatMessage {

 String get id; String get rideId; String get senderId; String get body; DateTime get createdAt;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.rideId, _this.rideId) || other.rideId == _this.rideId)&&(identical(other.senderId, _this.senderId) || other.senderId == _this.senderId)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMessage;
  return Object.hash(runtimeType,_this.id,_this.rideId,_this.senderId,_this.body,_this.createdAt);
}

@override
String toString() {
  final _this = this as ChatMessage;
  return 'ChatMessage(id: ${_this.id}, rideId: ${_this.rideId}, senderId: ${_this.senderId}, body: ${_this.body}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, String rideId, String senderId, String body, DateTime createdAt
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rideId = null,Object? senderId = null,Object? body = null,Object? createdAt = null,}) {
  return _then(ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rideId: null == rideId ? _self.rideId : rideId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String rideId,  String senderId,  String body,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.rideId,_that.senderId,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String rideId,  String senderId,  String body,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.rideId,_that.senderId,_that.body,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String rideId,  String senderId,  String body,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.rideId,_that.senderId,_that.body,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({required this.id, required this.rideId, required this.senderId, required this.body, required this.createdAt});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override final  String id;
@override final  String rideId;
@override final  String senderId;
@override final  String body;
@override final  DateTime createdAt;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.rideId, rideId) || other.rideId == rideId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,rideId,senderId,body,createdAt);
}

@override
String toString() {
    return 'ChatMessage(id: $id, rideId: $rideId, senderId: $senderId, body: $body, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String rideId, String senderId, String body, DateTime createdAt
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rideId = null,Object? senderId = null,Object? body = null,Object? createdAt = null,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rideId: null == rideId ? _self.rideId : rideId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$NearbyCar {

 String get key; String get vehicleType; double get lat; double get lng; double? get heading; int get distanceM;
/// Create a copy of NearbyCar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyCarCopyWith<NearbyCar> get copyWith => _$NearbyCarCopyWithImpl<NearbyCar>(this as NearbyCar, _$identity);

  /// Serializes this NearbyCar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NearbyCar;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyCar&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.vehicleType, _this.vehicleType) || other.vehicleType == _this.vehicleType)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.heading, _this.heading) || other.heading == _this.heading)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NearbyCar;
  return Object.hash(runtimeType,_this.key,_this.vehicleType,_this.lat,_this.lng,_this.heading,_this.distanceM);
}

@override
String toString() {
  final _this = this as NearbyCar;
  return 'NearbyCar(key: ${_this.key}, vehicleType: ${_this.vehicleType}, lat: ${_this.lat}, lng: ${_this.lng}, heading: ${_this.heading}, distanceM: ${_this.distanceM})';
}


}

/// @nodoc
abstract mixin class $NearbyCarCopyWith<$Res>  {
  factory $NearbyCarCopyWith(NearbyCar value, $Res Function(NearbyCar) _then) = _$NearbyCarCopyWithImpl;
@useResult
$Res call({
 String key, String vehicleType, double lat, double lng, double? heading, int distanceM
});




}
/// @nodoc
class _$NearbyCarCopyWithImpl<$Res>
    implements $NearbyCarCopyWith<$Res> {
  _$NearbyCarCopyWithImpl(this._self, this._then);

  final NearbyCar _self;
  final $Res Function(NearbyCar) _then;

/// Create a copy of NearbyCar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? vehicleType = null,Object? lat = null,Object? lng = null,Object? heading = freezed,Object? distanceM = null,}) {
  return _then(NearbyCar(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,vehicleType: null == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NearbyCar].
extension NearbyCarPatterns on NearbyCar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearbyCar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearbyCar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearbyCar value)  $default,){
final _that = this;
switch (_that) {
case _NearbyCar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearbyCar value)?  $default,){
final _that = this;
switch (_that) {
case _NearbyCar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String vehicleType,  double lat,  double lng,  double? heading,  int distanceM)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearbyCar() when $default != null:
return $default(_that.key,_that.vehicleType,_that.lat,_that.lng,_that.heading,_that.distanceM);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String vehicleType,  double lat,  double lng,  double? heading,  int distanceM)  $default,) {final _that = this;
switch (_that) {
case _NearbyCar():
return $default(_that.key,_that.vehicleType,_that.lat,_that.lng,_that.heading,_that.distanceM);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String vehicleType,  double lat,  double lng,  double? heading,  int distanceM)?  $default,) {final _that = this;
switch (_that) {
case _NearbyCar() when $default != null:
return $default(_that.key,_that.vehicleType,_that.lat,_that.lng,_that.heading,_that.distanceM);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NearbyCar implements NearbyCar {
  const _NearbyCar({required this.key, required this.vehicleType, required this.lat, required this.lng, this.heading, required this.distanceM});
  factory _NearbyCar.fromJson(Map<String, dynamic> json) => _$NearbyCarFromJson(json);

@override final  String key;
@override final  String vehicleType;
@override final  double lat;
@override final  double lng;
@override final  double? heading;
@override final  int distanceM;

/// Create a copy of NearbyCar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearbyCarCopyWith<_NearbyCar> get copyWith => __$NearbyCarCopyWithImpl<_NearbyCar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NearbyCarToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearbyCar&&(identical(other.key, key) || other.key == key)&&(identical(other.vehicleType, vehicleType) || other.vehicleType == vehicleType)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,vehicleType,lat,lng,heading,distanceM);
}

@override
String toString() {
    return 'NearbyCar(key: $key, vehicleType: $vehicleType, lat: $lat, lng: $lng, heading: $heading, distanceM: $distanceM)';
}


}

/// @nodoc
abstract mixin class _$NearbyCarCopyWith<$Res> implements $NearbyCarCopyWith<$Res> {
  factory _$NearbyCarCopyWith(_NearbyCar value, $Res Function(_NearbyCar) _then) = __$NearbyCarCopyWithImpl;
@override @useResult
$Res call({
 String key, String vehicleType, double lat, double lng, double? heading, int distanceM
});




}
/// @nodoc
class __$NearbyCarCopyWithImpl<$Res>
    implements _$NearbyCarCopyWith<$Res> {
  __$NearbyCarCopyWithImpl(this._self, this._then);

  final _NearbyCar _self;
  final $Res Function(_NearbyCar) _then;

/// Create a copy of NearbyCar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? vehicleType = null,Object? lat = null,Object? lng = null,Object? heading = freezed,Object? distanceM = null,}) {
  return _then(_NearbyCar(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,vehicleType: null == vehicleType ? _self.vehicleType : vehicleType // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$EarningPeriod {

 int get rides; int get gross; int get commission; int get net; int get distanceM;
/// Create a copy of EarningPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningPeriodCopyWith<EarningPeriod> get copyWith => _$EarningPeriodCopyWithImpl<EarningPeriod>(this as EarningPeriod, _$identity);

  /// Serializes this EarningPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EarningPeriod;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarningPeriod&&(identical(other.rides, _this.rides) || other.rides == _this.rides)&&(identical(other.gross, _this.gross) || other.gross == _this.gross)&&(identical(other.commission, _this.commission) || other.commission == _this.commission)&&(identical(other.net, _this.net) || other.net == _this.net)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EarningPeriod;
  return Object.hash(runtimeType,_this.rides,_this.gross,_this.commission,_this.net,_this.distanceM);
}

@override
String toString() {
  final _this = this as EarningPeriod;
  return 'EarningPeriod(rides: ${_this.rides}, gross: ${_this.gross}, commission: ${_this.commission}, net: ${_this.net}, distanceM: ${_this.distanceM})';
}


}

/// @nodoc
abstract mixin class $EarningPeriodCopyWith<$Res>  {
  factory $EarningPeriodCopyWith(EarningPeriod value, $Res Function(EarningPeriod) _then) = _$EarningPeriodCopyWithImpl;
@useResult
$Res call({
 int rides, int gross, int commission, int net, int distanceM
});




}
/// @nodoc
class _$EarningPeriodCopyWithImpl<$Res>
    implements $EarningPeriodCopyWith<$Res> {
  _$EarningPeriodCopyWithImpl(this._self, this._then);

  final EarningPeriod _self;
  final $Res Function(EarningPeriod) _then;

/// Create a copy of EarningPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rides = null,Object? gross = null,Object? commission = null,Object? net = null,Object? distanceM = null,}) {
  return _then(EarningPeriod(
rides: null == rides ? _self.rides : rides // ignore: cast_nullable_to_non_nullable
as int,gross: null == gross ? _self.gross : gross // ignore: cast_nullable_to_non_nullable
as int,commission: null == commission ? _self.commission : commission // ignore: cast_nullable_to_non_nullable
as int,net: null == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as int,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EarningPeriod].
extension EarningPeriodPatterns on EarningPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarningPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarningPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarningPeriod value)  $default,){
final _that = this;
switch (_that) {
case _EarningPeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarningPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _EarningPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rides,  int gross,  int commission,  int net,  int distanceM)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarningPeriod() when $default != null:
return $default(_that.rides,_that.gross,_that.commission,_that.net,_that.distanceM);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rides,  int gross,  int commission,  int net,  int distanceM)  $default,) {final _that = this;
switch (_that) {
case _EarningPeriod():
return $default(_that.rides,_that.gross,_that.commission,_that.net,_that.distanceM);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rides,  int gross,  int commission,  int net,  int distanceM)?  $default,) {final _that = this;
switch (_that) {
case _EarningPeriod() when $default != null:
return $default(_that.rides,_that.gross,_that.commission,_that.net,_that.distanceM);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EarningPeriod implements EarningPeriod {
  const _EarningPeriod({this.rides = 0, this.gross = 0, this.commission = 0, this.net = 0, this.distanceM = 0});
  factory _EarningPeriod.fromJson(Map<String, dynamic> json) => _$EarningPeriodFromJson(json);

@override@JsonKey() final  int rides;
@override@JsonKey() final  int gross;
@override@JsonKey() final  int commission;
@override@JsonKey() final  int net;
@override@JsonKey() final  int distanceM;

/// Create a copy of EarningPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningPeriodCopyWith<_EarningPeriod> get copyWith => __$EarningPeriodCopyWithImpl<_EarningPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarningPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarningPeriod&&(identical(other.rides, rides) || other.rides == rides)&&(identical(other.gross, gross) || other.gross == gross)&&(identical(other.commission, commission) || other.commission == commission)&&(identical(other.net, net) || other.net == net)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rides,gross,commission,net,distanceM);
}

@override
String toString() {
    return 'EarningPeriod(rides: $rides, gross: $gross, commission: $commission, net: $net, distanceM: $distanceM)';
}


}

/// @nodoc
abstract mixin class _$EarningPeriodCopyWith<$Res> implements $EarningPeriodCopyWith<$Res> {
  factory _$EarningPeriodCopyWith(_EarningPeriod value, $Res Function(_EarningPeriod) _then) = __$EarningPeriodCopyWithImpl;
@override @useResult
$Res call({
 int rides, int gross, int commission, int net, int distanceM
});




}
/// @nodoc
class __$EarningPeriodCopyWithImpl<$Res>
    implements _$EarningPeriodCopyWith<$Res> {
  __$EarningPeriodCopyWithImpl(this._self, this._then);

  final _EarningPeriod _self;
  final $Res Function(_EarningPeriod) _then;

/// Create a copy of EarningPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rides = null,Object? gross = null,Object? commission = null,Object? net = null,Object? distanceM = null,}) {
  return _then(_EarningPeriod(
rides: null == rides ? _self.rides : rides // ignore: cast_nullable_to_non_nullable
as int,gross: null == gross ? _self.gross : gross // ignore: cast_nullable_to_non_nullable
as int,commission: null == commission ? _self.commission : commission // ignore: cast_nullable_to_non_nullable
as int,net: null == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as int,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WalletTx {

 String get id; int get amount; String get type; String? get rideId; String? get note; DateTime get createdAt;
/// Create a copy of WalletTx
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletTxCopyWith<WalletTx> get copyWith => _$WalletTxCopyWithImpl<WalletTx>(this as WalletTx, _$identity);

  /// Serializes this WalletTx to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WalletTx;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletTx&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.rideId, _this.rideId) || other.rideId == _this.rideId)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WalletTx;
  return Object.hash(runtimeType,_this.id,_this.amount,_this.type,_this.rideId,_this.note,_this.createdAt);
}

@override
String toString() {
  final _this = this as WalletTx;
  return 'WalletTx(id: ${_this.id}, amount: ${_this.amount}, type: ${_this.type}, rideId: ${_this.rideId}, note: ${_this.note}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $WalletTxCopyWith<$Res>  {
  factory $WalletTxCopyWith(WalletTx value, $Res Function(WalletTx) _then) = _$WalletTxCopyWithImpl;
@useResult
$Res call({
 String id, int amount, String type, String? rideId, String? note, DateTime createdAt
});




}
/// @nodoc
class _$WalletTxCopyWithImpl<$Res>
    implements $WalletTxCopyWith<$Res> {
  _$WalletTxCopyWithImpl(this._self, this._then);

  final WalletTx _self;
  final $Res Function(WalletTx) _then;

/// Create a copy of WalletTx
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? type = null,Object? rideId = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(WalletTx(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,rideId: freezed == rideId ? _self.rideId : rideId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletTx].
extension WalletTxPatterns on WalletTx {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletTx value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletTx() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletTx value)  $default,){
final _that = this;
switch (_that) {
case _WalletTx():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletTx value)?  $default,){
final _that = this;
switch (_that) {
case _WalletTx() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int amount,  String type,  String? rideId,  String? note,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletTx() when $default != null:
return $default(_that.id,_that.amount,_that.type,_that.rideId,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int amount,  String type,  String? rideId,  String? note,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WalletTx():
return $default(_that.id,_that.amount,_that.type,_that.rideId,_that.note,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int amount,  String type,  String? rideId,  String? note,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WalletTx() when $default != null:
return $default(_that.id,_that.amount,_that.type,_that.rideId,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletTx implements WalletTx {
  const _WalletTx({required this.id, required this.amount, required this.type, this.rideId, this.note, required this.createdAt});
  factory _WalletTx.fromJson(Map<String, dynamic> json) => _$WalletTxFromJson(json);

@override final  String id;
@override final  int amount;
@override final  String type;
@override final  String? rideId;
@override final  String? note;
@override final  DateTime createdAt;

/// Create a copy of WalletTx
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletTxCopyWith<_WalletTx> get copyWith => __$WalletTxCopyWithImpl<_WalletTx>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletTxToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletTx&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.rideId, rideId) || other.rideId == rideId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,amount,type,rideId,note,createdAt);
}

@override
String toString() {
    return 'WalletTx(id: $id, amount: $amount, type: $type, rideId: $rideId, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WalletTxCopyWith<$Res> implements $WalletTxCopyWith<$Res> {
  factory _$WalletTxCopyWith(_WalletTx value, $Res Function(_WalletTx) _then) = __$WalletTxCopyWithImpl;
@override @useResult
$Res call({
 String id, int amount, String type, String? rideId, String? note, DateTime createdAt
});




}
/// @nodoc
class __$WalletTxCopyWithImpl<$Res>
    implements _$WalletTxCopyWith<$Res> {
  __$WalletTxCopyWithImpl(this._self, this._then);

  final _WalletTx _self;
  final $Res Function(_WalletTx) _then;

/// Create a copy of WalletTx
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? type = null,Object? rideId = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_WalletTx(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,rideId: freezed == rideId ? _self.rideId : rideId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Earnings {

 int get balance; double get commissionRate; EarningPeriod get today; EarningPeriod get week; EarningPeriod get month; List<WalletTx> get transactions;
/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningsCopyWith<Earnings> get copyWith => _$EarningsCopyWithImpl<Earnings>(this as Earnings, _$identity);

  /// Serializes this Earnings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Earnings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Earnings&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.commissionRate, _this.commissionRate) || other.commissionRate == _this.commissionRate)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.week, _this.week) || other.week == _this.week)&&(identical(other.month, _this.month) || other.month == _this.month)&&const DeepCollectionEquality().equals(other.transactions, _this.transactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Earnings;
  return Object.hash(runtimeType,_this.balance,_this.commissionRate,_this.today,_this.week,_this.month,const DeepCollectionEquality().hash(_this.transactions));
}

@override
String toString() {
  final _this = this as Earnings;
  return 'Earnings(balance: ${_this.balance}, commissionRate: ${_this.commissionRate}, today: ${_this.today}, week: ${_this.week}, month: ${_this.month}, transactions: ${_this.transactions})';
}


}

/// @nodoc
abstract mixin class $EarningsCopyWith<$Res>  {
  factory $EarningsCopyWith(Earnings value, $Res Function(Earnings) _then) = _$EarningsCopyWithImpl;
@useResult
$Res call({
 int balance, double commissionRate, EarningPeriod today, EarningPeriod week, EarningPeriod month, List<WalletTx> transactions
});


$EarningPeriodCopyWith<$Res> get today;$EarningPeriodCopyWith<$Res> get week;$EarningPeriodCopyWith<$Res> get month;

}
/// @nodoc
class _$EarningsCopyWithImpl<$Res>
    implements $EarningsCopyWith<$Res> {
  _$EarningsCopyWithImpl(this._self, this._then);

  final Earnings _self;
  final $Res Function(Earnings) _then;

/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,Object? commissionRate = null,Object? today = null,Object? week = null,Object? month = null,Object? transactions = null,}) {
  return _then(Earnings(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as EarningPeriod,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as EarningPeriod,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as EarningPeriod,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<WalletTx>,
  ));
}
/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EarningPeriodCopyWith<$Res> get today {
  
  return $EarningPeriodCopyWith<$Res>(_self.today, (value) {
    return _then(_self.copyWith(today: value));
  });
}/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EarningPeriodCopyWith<$Res> get week {
  
  return $EarningPeriodCopyWith<$Res>(_self.week, (value) {
    return _then(_self.copyWith(week: value));
  });
}/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EarningPeriodCopyWith<$Res> get month {
  
  return $EarningPeriodCopyWith<$Res>(_self.month, (value) {
    return _then(_self.copyWith(month: value));
  });
}
}


/// Adds pattern-matching-related methods to [Earnings].
extension EarningsPatterns on Earnings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Earnings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Earnings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Earnings value)  $default,){
final _that = this;
switch (_that) {
case _Earnings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Earnings value)?  $default,){
final _that = this;
switch (_that) {
case _Earnings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int balance,  double commissionRate,  EarningPeriod today,  EarningPeriod week,  EarningPeriod month,  List<WalletTx> transactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Earnings() when $default != null:
return $default(_that.balance,_that.commissionRate,_that.today,_that.week,_that.month,_that.transactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int balance,  double commissionRate,  EarningPeriod today,  EarningPeriod week,  EarningPeriod month,  List<WalletTx> transactions)  $default,) {final _that = this;
switch (_that) {
case _Earnings():
return $default(_that.balance,_that.commissionRate,_that.today,_that.week,_that.month,_that.transactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int balance,  double commissionRate,  EarningPeriod today,  EarningPeriod week,  EarningPeriod month,  List<WalletTx> transactions)?  $default,) {final _that = this;
switch (_that) {
case _Earnings() when $default != null:
return $default(_that.balance,_that.commissionRate,_that.today,_that.week,_that.month,_that.transactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Earnings implements Earnings {
  const _Earnings({required this.balance, required this.commissionRate, required this.today, required this.week, required this.month,  List<WalletTx> transactions = const []}): _transactions = transactions;
  factory _Earnings.fromJson(Map<String, dynamic> json) => _$EarningsFromJson(json);

@override final  int balance;
@override final  double commissionRate;
@override final  EarningPeriod today;
@override final  EarningPeriod week;
@override final  EarningPeriod month;
 final  List<WalletTx> _transactions;
@override@JsonKey() List<WalletTx> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}


/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningsCopyWith<_Earnings> get copyWith => __$EarningsCopyWithImpl<_Earnings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarningsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Earnings&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate)&&(identical(other.today, today) || other.today == today)&&(identical(other.week, week) || other.week == week)&&(identical(other.month, month) || other.month == month)&&const DeepCollectionEquality().equals(other.transactions, _transactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,balance,commissionRate,today,week,month,const DeepCollectionEquality().hash(_transactions));
}

@override
String toString() {
    return 'Earnings(balance: $balance, commissionRate: $commissionRate, today: $today, week: $week, month: $month, transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class _$EarningsCopyWith<$Res> implements $EarningsCopyWith<$Res> {
  factory _$EarningsCopyWith(_Earnings value, $Res Function(_Earnings) _then) = __$EarningsCopyWithImpl;
@override @useResult
$Res call({
 int balance, double commissionRate, EarningPeriod today, EarningPeriod week, EarningPeriod month, List<WalletTx> transactions
});


@override $EarningPeriodCopyWith<$Res> get today;@override $EarningPeriodCopyWith<$Res> get week;@override $EarningPeriodCopyWith<$Res> get month;

}
/// @nodoc
class __$EarningsCopyWithImpl<$Res>
    implements _$EarningsCopyWith<$Res> {
  __$EarningsCopyWithImpl(this._self, this._then);

  final _Earnings _self;
  final $Res Function(_Earnings) _then;

/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,Object? commissionRate = null,Object? today = null,Object? week = null,Object? month = null,Object? transactions = null,}) {
  return _then(_Earnings(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as EarningPeriod,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as EarningPeriod,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as EarningPeriod,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<WalletTx>,
  ));
}

/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EarningPeriodCopyWith<$Res> get today {
  
  return $EarningPeriodCopyWith<$Res>(_self.today, (value) {
    return _then(_self.copyWith(today: value));
  });
}/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EarningPeriodCopyWith<$Res> get week {
  
  return $EarningPeriodCopyWith<$Res>(_self.week, (value) {
    return _then(_self.copyWith(week: value));
  });
}/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EarningPeriodCopyWith<$Res> get month {
  
  return $EarningPeriodCopyWith<$Res>(_self.month, (value) {
    return _then(_self.copyWith(month: value));
  });
}
}

// dart format on
