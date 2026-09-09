# Notification Setup Implementation Plan

This plan outlines the steps to enable and fix the notification system in the "In Time" project, including Firebase Cloud Messaging (FCM) and local notifications.

## Proposed Changes

### Core Services

#### [MODIFY] [notification_service.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/core/services/notification_service.dart)
- Uncomment the `LocalNotificationService` class.
- Fix imports and ensure it correctly handles notification taps by calling `FCMService.handleNavigation`.

#### [MODIFY] [fcm_service.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/core/services/fcm_service.dart)
- Uncomment the `FCMService` class.
- Ensure all imports are correct (Firebase Messaging, Notifications BLoC, etc.).
- Fix the `_firebaseMessagingBackgroundHandler` to be a top-level function as required by Firebase.
- Update `processMessage` and `handleNavigation` to match the application's needs.

### Dependency Injection

#### [MODIFY] [injection_container.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/injection_container.dart)
- Register `NotificationRemoteDataSource`, `NotificationRepository`, and all notification use cases.
- Register `NotificationsBloc`.
- Register `LocalNotificationService` and `FCMService` if needed (or just use them as static services as they are currently designed).

### Application Entry Point

#### [MODIFY] [main.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/main.dart)
- Call `LocalNotificationService.initialize()` and `FCMService.initialize()` during app startup.

## Verification Plan

### Automated Tests
- No specific automated tests are planned for this integration task, as it involves external services (Firebase).

### Manual Verification
- Verify that the FCM token is generated and logged in debug mode.
- Verify that permissions are requested on app launch.
- Test foreground notifications: Send a test message from Firebase Console and check if a local notification appears.
- Test background notifications: Send a test message while the app is in the background and check if it appears in the system tray.
- Test notification interaction: Tap on a notification and verify it navigates to the correct page (e.g., Chat Room or My Requests).
