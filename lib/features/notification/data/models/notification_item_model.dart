import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_item.dart';

part 'notification_item_model.freezed.dart';
part 'notification_item_model.g.dart';

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
@freezed
abstract class NotificationItemModel with _$NotificationItemModel {
  const factory NotificationItemModel({
    required String id,
    required String title,
    required String body,
    DateTime? scheduledDate,
    String? payload,
  }) = _NotificationItemModel;

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemModelFromJson(json);
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
