import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../features/chat/presentation/bloc/chat_bloc/bloc_event.dart';
import '../../features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import '../../features/complaints/presentation/pages/complaint_details_page.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/bloc/home_event.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/notifications/presentation/bloc/notifications_event.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../../features/wallet/presentation/bloc/wallet_event.dart';
import '../../injection_container.dart';
import '../constants/app_routes.dart';
import '../localization/app_localizations.dart';
import 'notification_service.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static String normalizeNotificationType(String? rawType) {
    String type = (rawType ?? '').trim();

    // Handle Laravel style class names (e.g., App\Notifications\NewMessage)
    if (type.contains('\\')) {
      type = type.split('\\').last;
    } else if (type.contains('.')) {
      type = type.split('.').last;
    }

    type = type.toLowerCase();

    const aliases = {
      // Chat Aliases
      'chat': 'chat',
      'new_chat': 'chat',
      'message_received': 'chat',
      'chat_message': 'chat',
      'newmessage': 'chat',
      'new_message': 'chat',
      'newchatmessage': 'chat',

      // Group Aliases
      'group_added': 'group_added',
      'added_to_group': 'group_added',
      'group_invite': 'group_added',
      'addedtogroup': 'group_added',
      'newgroupnotification': 'group_added',

      // Complaint Aliases
      'complaint': 'complaint',
      'complaint_received': 'complaint',
      'complaint_status_updated': 'complaint',
      'complaint_updated': 'complaint',
      'complaint_rejected': 'complaint',
      'complaint_approved': 'complaint',
      'complaint_resolved': 'complaint',
      'complaint_processed': 'complaint',
      'complaint_created': 'complaint',
      'new_complaint': 'complaint',
      'complaint_filed': 'complaint',
      'complaint_against': 'complaint',
      'complaint_against_you': 'complaint',
      'documents_requested': 'complaint',
      'complaintupdated': 'complaint',
      'complaintcreated': 'complaint',

      // Request Aliases
      'request_received': 'request_received',
      'request_accepted': 'request_accepted',
      'request_rejected': 'request_rejected',
      'request_cancelled': 'request_rejected',
      'request_pending': 'request_received',
      'request_status_updated': 'request_received',
      'requestreceived': 'request_received',
      'new_request': 'request_received',
      'requestaccepted': 'request_accepted',
      'requestrejected': 'request_rejected',

      // Completion Aliases
      'request_completion': 'request_completion',
      'completion_requested': 'request_completion',
      'request_completed': 'request_completion',
      'service_completed': 'request_completion',
      'requestcompletion': 'request_completion',

      // Comment Aliases
      'comment_added': 'comment_added',
      'service_commented': 'comment_added',
      'comment_on_service': 'comment_added',
      'new_comment': 'comment_added',
      'comment_received': 'comment_added',
      'commentadded': 'comment_added',
    };

    return aliases[type] ?? type;
  }

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

    if (token != null && sl.isRegistered<NotificationsBloc>()) {
      sl<NotificationsBloc>().add(UpdateFcmTokenEvent(token));
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

      final type = normalizeNotificationType(message.data['type']?.toString());
      if (sl.isRegistered<ChatBloc>() && (type == 'chat' || type == 'group_added')) {
        sl<ChatBloc>().add(const GetChatsEvent(isSilent: true));
      }

      if (sl.isRegistered<HomeBloc>() && (type == 'service_updated' || type == 'service_deactivated')) {
        sl<HomeBloc>().add(const FetchHomeServingsEvent(isRefresh: true));
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
      final String type = normalizeNotificationType(message.data['type']?.toString());
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
        case 'comment_added':
          title = 'تم تعليق جديد';
          body = 'تمت إضافة تعليق جديد على الخدمة';
          break;
        case 'complaint':
          title = 'تم تحديث شكوى';
          body = 'لديك إشعار جديد حول الشكوى';
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

  static int? _extractInt(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value == null) continue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      if (value is num) return value.toInt();
    }
    return null;
  }

  static void _openComplaintDetails(BuildContext context, Map<String, dynamic> data) {
    final complaintId = _extractInt(data, ['complaint_id', 'id', 'complaintId']);

    if (complaintId == null) {
      Navigator.pushNamed(context, AppRoutes.notificationsPage);
      return;
    }

    final rawStatus = data['status']?.toString() ?? data['complaint_status']?.toString();
    String statusText = context.tr('pending');
    if (rawStatus == 'resolved') {
      statusText = context.tr('resolved');
    } else if (rawStatus == 'rejected') {
      statusText = context.tr('rejected');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ComplaintDetailsPage(
          complaintId: complaintId.toString(),
          status: statusText,
          complaintType: data['complaint_type']?.toString() ?? data['reason']?.toString() ?? context.tr('complaint'),
          complaintDescription: data['description']?.toString() ??
              data['complaint_description']?.toString() ??
              data['body']?.toString() ??
              '',
        ),
      ),
    );
  }

  static void handleNavigation(Map<String, dynamic> data) {
    if (kDebugMode) {
      print('FCMService.handleNavigation: Data=$data');
    }
    final String type = normalizeNotificationType(data['type']?.toString());
    if (kDebugMode) {
      print('FCMService.handleNavigation: Normalized Type=$type');
    }
    if (type.isEmpty) return;

    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return;

    switch (type) {
      case 'chat':
        final chatId = _extractInt(data, ['chat_id', 'id', 'chatId']);
        if (sl.isRegistered<ChatBloc>()) {
          sl<ChatBloc>().add(const GetChatsEvent(isSilent: true));
        }
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
          return;
        }
        break;
      case 'request_received':
        final requestId = _extractInt(data, ['request_id', 'id', 'requestId']);
        Navigator.pushNamed(context, AppRoutes.myRequestsPage, arguments: {
          'initialTabIndex': 1,
          'requestId': requestId,
        });
        return;
      case 'request_accepted':
      case 'request_rejected':
        final requestId = _extractInt(data, ['request_id', 'id', 'requestId']);
        Navigator.pushNamed(context, AppRoutes.myRequestsPage, arguments: {
          'initialTabIndex': 0,
          'requestId': requestId,
        });
        return;
      case 'request_completion':
        final requestId = _extractInt(data, ['request_id', 'id', 'requestId']);
        Navigator.pushNamed(context, AppRoutes.myRequestsPage, arguments: {
          'initialTabIndex': 2,
          'requestId': requestId,
        });
        return;
      case 'group_added':
        final chatId = _extractInt(data, ['chat_id', 'group_id', 'id', 'groupId', 'chatId']);
        if (sl.isRegistered<ChatBloc>()) {
          sl<ChatBloc>().add(const GetChatsEvent(isSilent: true));
        }
        if (chatId != null) {
          Navigator.pushNamed(
            context,
            AppRoutes.chatRoomPage,
            arguments: {
              'chatId': chatId,
              'chatTitle': data['chat_title'] ?? data['group_name'] ?? 'مجموعة',
              'isGroup': true,
            },
          );
          return;
        }
        Navigator.pushNamed(context, AppRoutes.notificationsPage);
        return;
      case 'comment_added':
        final servingId = _extractInt(data, ['serving_id', 'service_id', 'id']);
        if (servingId != null) {
          Navigator.pushNamed(
            context,
            AppRoutes.serviceDetailsPage,
            arguments: servingId,
          );
          return;
        }
        Navigator.pushNamed(context, AppRoutes.notificationsPage);
        return;
      case 'complaint':
        _openComplaintDetails(context, data);
        return;
      default:
        if (kDebugMode) {
          print('FCMService.handleNavigation: Unknown type "$type", navigating to notificationsPage');
        }
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