# Fix Notifications and Chat Message Counter

The user reported that notifications are not being received and the message counter (unread badge) is not working. This plan addresses both issues by fixing missing platform configurations, ensuring the FCM token is sent to the server, and implementing a global unread message counter in the UI.

## User Review Required

> [!IMPORTANT]
> The changes include modifications to `AndroidManifest.xml` and `Info.plist` to enable notification permissions and background modes. These are critical for notifications to work on physical devices.

## Proposed Changes

### Configuration & Platform Support

#### [MODIFY] [AndroidManifest.xml](file:///C:/Users/User/StudioProjects/In-Time-Project/android/app/src/main/AndroidManifest.xml)
- Add `POST_NOTIFICATIONS` permission (required for Android 13+).
- Add default notification channel metadata.

#### [MODIFY] [Info.plist](file:///C:/Users/User/StudioProjects/In-Time-Project/ios/Runner/Info.plist)
- Add `remote-notification` to `UIBackgroundModes`.

---

### Core Services

#### [MODIFY] [fcm_service.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/core/services/fcm_service.dart)
- Update `initialize()` to send the initial FCM token to the backend immediately after fetching it.
- This ensures the server always has the correct token even if `onTokenRefresh` hasn't fired yet.

---

### Chat Feature (State Management & Logic)

#### [MODIFY] [bloc_state.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/chat/presentation/bloc/chat_bloc/bloc_state.dart)
- Add `totalUnreadCount` field to the base `ChatState` class.
- Update all subclasses to accept and pass `totalUnreadCount`.

#### [MODIFY] [chat_bloc.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart)
- Calculate the sum of `unreadCount` from all chats whenever the chat list is fetched.
- Ensure the `totalUnreadCount` is persisted across state transitions (e.g., when moving from chat list to a specific chat room).

#### [MODIFY] [main.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/main.dart)
- Trigger an initial silent fetch of chats in `MultiBlocProvider` to populate the message counter on app start.

---

### UI / Presentation

#### [MODIFY] [custom_bottom_nav_bar.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/core/widgets/custom_bottom_nav_bar.dart)
- Wrap the chat navigation item in a `BlocBuilder<ChatBloc, ChatState>`.
- Display a badge with the `totalUnreadCount` if it's greater than zero.

## Verification Plan

### Manual Verification
1. **Notifications**:
   - Verify that the notification permission prompt appears on app start (Android 13+).
   - Send a test notification via Firebase Console and check if it arrives in foreground and background.
2. **Message Counter**:
   - Open the app and observe the bottom navigation bar.
   - Send a message from another account to the current user.
   - Verify that the chat icon badge updates with the correct unread count.
   - Navigate to the chat list and then into a chat room, ensuring the badge persists or updates correctly.
