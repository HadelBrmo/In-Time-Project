import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/chatEntity.dart';
import '../bloc/chatBloc/chatBloc.dart';

Widget buildChatTile(BuildContext context, ChatEntity chat, ThemeData theme) {
  final isGroup = chat.type == 'group';
  final chatTitle = isGroup ? (chat.name ?? 'Group') : (chat.otherUser?.fullName ?? 'User');
  final hasUnread = chat.unreadCount > 0;

  return ListTile(
    onTap: () {
      context.read<ChatBloc>().stopChatsPulling();
      Navigator.pushNamed(
        context,
        AppRoutes.chatRoomPage,
        arguments: {
          'chatId': chat.id,
          'chatTitle': chatTitle,
        },
      ).then((_) {
        context.read<ChatBloc>().startChatsPulling();
      });
    },
    leading: CircleAvatar(
      radius: 28,
      backgroundColor: isGroup ? theme.colorScheme.secondary.withAlpha(30) : theme.colorScheme.primary.withAlpha(30),
      backgroundImage: !isGroup && chat.otherUser?.profilePicture != null
          ? NetworkImage(chat.otherUser!.profilePicture!)
          : null,
      child: (isGroup || chat.otherUser?.profilePicture == null)
          ? Icon(isGroup ? Icons.groups_rounded : Icons.person_rounded, color: theme.iconTheme.color, size: 28)
          : null,
    ),
    title: Text(
      chatTitle,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
      ),
    ),
    subtitle: Text(
      chat.latestMessage?.content ?? (isGroup ? context.tr('no_messages_yet') : ''),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: hasUnread ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color?.withAlpha(150),
      ),
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasUnread)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
            child: Text(
              '${chat.unreadCount}',
              style: theme.textTheme.titleMedium?.copyWith(color: AppColors.whiteColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ).animate().scale(curve: Curves.elasticOut, duration: 400.ms),
      ],
    ),
  );
}
