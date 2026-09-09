import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

enum NotificationsStatus { initial, loading, success, error }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final String? errorMessage;
  final bool isNotificationsEnabled;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.errorMessage,
    this.isNotificationsEnabled = true,
  });

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationEntity>? notifications,
    int? unreadCount,
    String? errorMessage,
    bool? isNotificationsEnabled,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage ?? this.errorMessage,
      isNotificationsEnabled: isNotificationsEnabled ?? this.isNotificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [status, notifications, unreadCount, errorMessage, isNotificationsEnabled];
}
