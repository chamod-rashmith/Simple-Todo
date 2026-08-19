// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationItemModel _$NotificationItemModelFromJson(
  Map<String, dynamic> json,
) => _NotificationItemModel(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  scheduledDate: json['scheduledDate'] == null
      ? null
      : DateTime.parse(json['scheduledDate'] as String),
  payload: json['payload'] as String?,
);

Map<String, dynamic> _$NotificationItemModelToJson(
  _NotificationItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'scheduledDate': instance.scheduledDate?.toIso8601String(),
  'payload': instance.payload,
};
