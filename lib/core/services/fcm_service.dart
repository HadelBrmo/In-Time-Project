import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/notifications/presentation/bloc/notifications_event.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../../features/wallet/presentation/bloc/wallet_event.dart';
import '../../injection_container.dart';
import '../constants/app_routes.dart';
import 'notification_service.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted notification permission');
      }
    }

    String? token = await _messaging.getToken();
    if (kDebugMode) {
      print("FCM Token: $token");
    }

    _subscribeToInitialTopics();

    _messaging.onTokenRefresh.listen((newToken) {
      if (sl.isRegistered<NotificationsBloc>()) {
        sl<NotificationsBloc>().add(UpdateFcmTokenEvent(newToken));
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
      }

      if (sl.isRegistered<NotificationsBloc>()) {
        sl<NotificationsBloc>().add(GetMyNotificationsEvent());
        sl<NotificationsBloc>().add(GetUnreadNotificationsCountEvent());
      }

      if (sl.isRegistered<WalletBloc>()) {
        sl<WalletBloc>().add(GetMyWalletsEvent());
      }

      processMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Notification clicked (onMessageOpenedApp)!');
      }
      handleNavigation(message.data);
    });

    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        print('Notification clicked (getInitialMessage)!');
      }
      handleNavigation(initialMessage.data);
    }
  }

  static Future<void> _subscribeToInitialTopics() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      await _messaging.subscribeToTopic('all');
      if (kDebugMode) {
        print('✅ Subscribed to topic: all');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Topic subscription failed (SERVICE_NOT_AVAILABLE), but app will continue. Error: $e');
      }
    }
  }

  static void processMessage(RemoteMessage message) {
    String title = '';
    String body = '';

    if (message.notification != null) {
      title = message.notification!.title ?? '';
      body = message.notification!.body ?? '';
    } else if (message.data.containsKey('title') || message.data.containsKey('body')) {
      title = message.data['title'] ?? 'إشعار جديد';
      body = message.data['body'] ?? '';
    } else {
      final String? type = message.data['type'];
      switch (type) {
        case 'chat':
          title = 'رسالة جديدة';
          body = message.data['message'] ?? 'لقد استلمت رسالة جديدة في الشات';
          break;
        case 'request_received':
          title = 'طلب خدمة جديد';
          body = 'لقد تلقيت طلباً جديداً لخدمتك';
          break;
        case 'request_accepted':
          title = 'تم قبول طلبك';
          body = 'وافق مقدم الخدمة على طلبك، يمكنك البدء بالتواصل';
          break;
        case 'request_rejected':
          title = 'طلب مرفوض';
          body = 'عذراً، تم رفض طلب الخدمة المقدم من قبلك';
          break;
        default:
          title = 'إشعار من In-Time';
          body = 'لديك تحديث جديد في التطبيق';
      }
    }

    if (title.isNotEmpty || body.isNotEmpty) {
      LocalNotificationService.showNotification(
        id: message.hashCode,
        title: title,
        body: body,
        payload: json.encode(message.data),
      );
    }
  }

  static void handleNavigation(Map<String, dynamic> data) {
    final String? type = data['type'];
    if (type == null) return;

    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return;

    switch (type) {
      case 'chat':
        final chatId = int.tryParse(data['chat_id']?.toString() ?? '');
        if (chatId != null) {
          Navigator.pushNamed(
            context,
            AppRoutes.chatRoomPage,
            arguments: {
              'chatId': chatId,
              'chatTitle': data['chat_title'] ?? 'محادثة',
              'isGroup': data['is_group'] == 'true' || data['is_group'] == true,
            },
          );
        }
        break;
      case 'request_received':
      case 'request_accepted':
      case 'request_rejected':
        Navigator.pushNamed(context, AppRoutes.myRequestsPage);
        break;
      default:
        Navigator.pushNamed(context, AppRoutes.notificationsPage);
    }
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  static Future<void> deleteToken() async {
    await _messaging.deleteToken();
  }

  static Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }

  if (message.notification == null) {
    FCMService.processMessage(message);
  }
}