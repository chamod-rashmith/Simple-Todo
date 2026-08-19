// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationItemModel {

 String get id; String get title; String get body; DateTime? get scheduledDate; String? get payload;
/// Create a copy of NotificationItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationItemModelCopyWith<NotificationItemModel> get copyWith => _$NotificationItemModelCopyWithImpl<NotificationItemModel>(this as NotificationItemModel, _$identity);

  /// Serializes this NotificationItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.payload, payload) || other.payload == payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,scheduledDate,payload);

@override
String toString() {
  return 'NotificationItemModel(id: $id, title: $title, body: $body, scheduledDate: $scheduledDate, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $NotificationItemModelCopyWith<$Res>  {
  factory $NotificationItemModelCopyWith(NotificationItemModel value, $Res Function(NotificationItemModel) _then) = _$NotificationItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String body, DateTime? scheduledDate, String? payload
});




}
/// @nodoc
class _$NotificationItemModelCopyWithImpl<$Res>
    implements $NotificationItemModelCopyWith<$Res> {
  _$NotificationItemModelCopyWithImpl(this._self, this._then);

  final NotificationItemModel _self;
  final $Res Function(NotificationItemModel) _then;

/// Create a copy of NotificationItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? scheduledDate = freezed,Object? payload = freezed,}) {
  return _then(NotificationItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationItemModel].
extension NotificationItemModelPatterns on NotificationItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationItemModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String body,  DateTime? scheduledDate,  String? payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationItemModel() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.scheduledDate,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String body,  DateTime? scheduledDate,  String? payload)  $default,) {final _that = this;
switch (_that) {
case _NotificationItemModel():
return $default(_that.id,_that.title,_that.body,_that.scheduledDate,_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String body,  DateTime? scheduledDate,  String? payload)?  $default,) {final _that = this;
switch (_that) {
case _NotificationItemModel() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.scheduledDate,_that.payload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationItemModel implements NotificationItemModel {
  const _NotificationItemModel({required this.id, required this.title, required this.body, this.scheduledDate, this.payload});
  factory _NotificationItemModel.fromJson(Map<String, dynamic> json) => _$NotificationItemModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String body;
@override final  DateTime? scheduledDate;
@override final  String? payload;

/// Create a copy of NotificationItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationItemModelCopyWith<_NotificationItemModel> get copyWith => __$NotificationItemModelCopyWithImpl<_NotificationItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.payload, payload) || other.payload == payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,scheduledDate,payload);

@override
String toString() {
  return 'NotificationItemModel(id: $id, title: $title, body: $body, scheduledDate: $scheduledDate, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$NotificationItemModelCopyWith<$Res> implements $NotificationItemModelCopyWith<$Res> {
  factory _$NotificationItemModelCopyWith(_NotificationItemModel value, $Res Function(_NotificationItemModel) _then) = __$NotificationItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String body, DateTime? scheduledDate, String? payload
});




}
/// @nodoc
class __$NotificationItemModelCopyWithImpl<$Res>
    implements _$NotificationItemModelCopyWith<$Res> {
  __$NotificationItemModelCopyWithImpl(this._self, this._then);

  final _NotificationItemModel _self;
  final $Res Function(_NotificationItemModel) _then;

/// Create a copy of NotificationItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? scheduledDate = freezed,Object? payload = freezed,}) {
  return _then(_NotificationItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
