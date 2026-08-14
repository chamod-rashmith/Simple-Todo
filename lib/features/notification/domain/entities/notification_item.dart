import 'package:equatable/equatable.dart';

/// ============================================================================
/// NotificationItemEntity
/// ============================================================================
/// 
/// Represents a pure Domain Entity for notifications and task reminders in the
/// application. 
///
/// **Clean Architecture Principles:**
/// - This file resides in the **Domain Layer** (`domain/entities/`).
/// - It has ZERO third-party UI dependencies (no `package:flutter/material.dart`,
///   no database drivers, and no specific notification plugins).
/// - It represents the core business concept of a scheduled or immediate alert.
///
/// **How to Use:**
/// ```dart
/// final reminder = NotificationItemEntity(
///   id: 'todo_123',
///   title: 'Complete Math Homework',
///   body: 'Your task is due in 10 minutes!',
///   scheduledDate: DateTime.now().add(const Duration(hours: 1)),
///   payload: 'todo_123',
/// );
/// ```
class NotificationItemEntity extends Equatable {
  /// Unique identifier corresponding to the notification.
  /// Often derived from or matching the ToDo task ID.
  final String id;

  /// The headline title displayed on the device status bar and notification shade.
  final String title;

  /// The main message content or description for the reminder.
  final String body;

  /// The precise timestamp when this reminder should trigger on the device.
  /// If `null`, this notification can be shown immediately as an instant alert.
  final DateTime? scheduledDate;

  /// Optional metadata string (e.g. JSON string or ToDo ID) passed back
  /// when the user taps on the notification.
  final String? payload;

  const NotificationItemEntity({
    required this.id,
    required this.title,
    required this.body,
    this.scheduledDate,
    this.payload,
  });

  /// Creates a copy of this entity with updated fields.
  NotificationItemEntity copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? scheduledDate,
    String? payload,
  }) {
    return NotificationItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      payload: payload ?? this.payload,
    );
  }

  @override
  List<Object?> get props => [id, title, body, scheduledDate, payload];
}
