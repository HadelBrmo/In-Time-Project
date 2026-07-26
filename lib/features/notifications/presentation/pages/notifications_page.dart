import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(GetMyNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(context.tr('notifications')),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: context.tr('mark_all_as_read'),
            onPressed: () {
              context.read<NotificationsBloc>().add(MarkAllNotificationsAsReadEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state.status == NotificationsStatus.loading) {
            return const Center(child: LoadingWidget());
          }

          if (state.status == NotificationsStatus.error) {
            return Center(child: Text(state.errorMessage ?? context.tr('error_loading_notifications')));
          }

          if (state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 80.r, color: AppColors.greyColor),
                  SizedBox(height: 16.h),
                  Text(
                    context.tr('no_notifications'),
                    style: TextStyle(fontSize: 18.sp, color: AppColors.greyColor),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationsBloc>().add(GetMyNotificationsEvent());
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return _buildNotificationTile(context, notification);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context, NotificationEntity notification) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.transparent : AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: notification.isRead ? AppColors.greyColor.withOpacity(0.2) : AppColors.primaryColor.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundColor: notification.isRead ? AppColors.greyColor.withOpacity(0.2) : AppColors.primaryColor,
          child: Icon(
            Icons.notifications_outlined,
            color: notification.isRead ? AppColors.greyColor : AppColors.whiteColor,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              notification.body,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(notification.createdAt),
              style: TextStyle(fontSize: 12.sp, color: AppColors.greyColor),
            ),
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            context.read<NotificationsBloc>().add(MarkNotificationAsReadEvent(notification.id));
          }
          // Optionally handle navigation based on notification data
        },
      ),
    );
  }
}
