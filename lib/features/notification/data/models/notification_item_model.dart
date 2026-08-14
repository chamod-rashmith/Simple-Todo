import '../../domain/entities/notification_item.dart';

/// ============================================================================
/// NotificationItemModel
/// ============================================================================
///
/// **Clean Architecture (Data Layer Model):**
/// Data transfer object (DTO) representing the raw notification payload.
/// 
/// **Strict Clean Architecture Rules:**
/// 1. DataSources only interact with Models, never domain entities.
/// 2. Extension mappers (`NotificationItemModelX`) convert between
///    `NotificationItemModel` (Data Layer) and `NotificationItemEntity` (Domain Layer).
class NotificationItemModel {
  final String id;
  final String title;
  final String body;
  final DateTime? scheduledDate;
  final String? payload;

  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.body,
    this.scheduledDate,
    this.payload,
  });

  /// Factory constructor to deserialize from JSON map if persisted or transported over network.
  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'] as String)
          : null,
      payload: json['payload'] as String?,
    );
  }

  /// Serializes the model into a standard JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'scheduledDate': scheduledDate?.toIso8601String(),
      'payload': payload,
    };
  }
}

/// ============================================================================
/// NotificationItemModelX (Extension Mapper)
/// ============================================================================
///
/// Converts between Domain Entity (`NotificationItemEntity`) and Data Model (`NotificationItemModel`).
extension NotificationItemModelX on NotificationItemModel {
  /// Maps a pure Domain Entity to a Data Model.
  static NotificationItemModel fromEntity(NotificationItemEntity entity) {
    return NotificationItemModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      scheduledDate: entity.scheduledDate,
      payload: entity.payload,
    );
  }

  /// Converts this Data Model back into a pure Domain Entity.
  NotificationItemEntity toEntity() {
    return NotificationItemEntity(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: payload,
    );
  }
}
