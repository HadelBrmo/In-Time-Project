import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class GetMyNotificationsEvent extends NotificationsEvent {}

class MarkNotificationAsReadEvent extends NotificationsEvent {
  final int id;
  const MarkNotificationAsReadEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MarkAllNotificationsAsReadEvent extends NotificationsEvent {}

class GetUnreadNotificationsCountEvent extends NotificationsEvent {}

class UpdateFcmTokenEvent extends NotificationsEvent {
  final String token;
  const UpdateFcmTokenEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class ToggleNotificationsEvent extends NotificationsEvent {
  final bool isEnabled;
  const ToggleNotificationsEvent(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}
