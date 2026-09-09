import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_my_notifications.dart';
import '../../domain/usecases/get_unread_notifications_count.dart';
import '../../domain/usecases/mark_all_notifications_as_read.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import '../../domain/usecases/update_fcm_token.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetMyNotificationsUseCase getMyNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;
  final GetUnreadNotificationsCountUseCase getUnreadNotificationsCountUseCase;
  final UpdateFcmTokenUseCase updateFcmTokenUseCase;

  NotificationsBloc({
    required this.getMyNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
    required this.getUnreadNotificationsCountUseCase,
    required this.updateFcmTokenUseCase,
  }) : super(const NotificationsState()) {
    on<GetMyNotificationsEvent>(_onGetMyNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkAsRead);
    on<MarkAllNotificationsAsReadEvent>(_onMarkAllAsRead);
    on<GetUnreadNotificationsCountEvent>(_onGetUnreadCount);
    on<UpdateFcmTokenEvent>(_onUpdateFcmToken);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
  }

  Future<void> _onGetMyNotifications(
    GetMyNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    final result = await getMyNotificationsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: failure.message,
      )),
      (notifications) => emit(state.copyWith(
        status: NotificationsStatus.success,
        notifications: notifications,
      )),
    );
  }

  Future<void> _onMarkAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final oldNotifications = List<NotificationEntity>.from(state.notifications);
    final updatedNotifications = state.notifications.map((n) {
      return n.id == event.id ? n.copyWith(isRead: true) : n;
    }).toList();

    emit(state.copyWith(
      notifications: updatedNotifications,
      unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
    ));

    final result = await markNotificationAsReadUseCase(event.id);
    result.fold(
      (failure) {
        emit(state.copyWith(
          notifications: oldNotifications,
          unreadCount: state.unreadCount + 1,
        ));
      },
      (_) => null,
    );
  }

  Future<void> _onMarkAllAsRead(
    MarkAllNotificationsAsReadEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final oldNotifications = List<NotificationEntity>.from(state.notifications);
    final oldUnreadCount = state.unreadCount;

    final updatedNotifications = state.notifications.map((n) {
      return n.copyWith(isRead: true);
    }).toList();

    emit(state.copyWith(
      notifications: updatedNotifications,
      unreadCount: 0,
    ));

    final result = await markAllNotificationsAsReadUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(
          notifications: oldNotifications,
          unreadCount: oldUnreadCount,
        ));
      },
      (_) => null,
    );
  }

  Future<void> _onGetUnreadCount(
    GetUnreadNotificationsCountEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await getUnreadNotificationsCountUseCase();
    result.fold(
      (failure) => null,
      (count) => emit(state.copyWith(unreadCount: count)),
    );
  }

  Future<void> _onUpdateFcmToken(
    UpdateFcmTokenEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    await updateFcmTokenUseCase(event.token);
  }

  void _onToggleNotifications(
    ToggleNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) {
    emit(state.copyWith(isNotificationsEnabled: event.isEnabled));
  }
}
