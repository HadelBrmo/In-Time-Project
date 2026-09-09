import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;
  final bool isGroup;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isGroup,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final timeStr = "${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && isGroup) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: message.sender?.profilePicture != null
                  ? NetworkImage(message.sender!.profilePicture!)
                  : null,
              child: message.sender?.profilePicture == null
                  ? Text(
                message.sender?.fullName.isNotEmpty == true
                    ? message.sender!.fullName[0]
                    : "?",
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.65),
              decoration: BoxDecoration(
                color: isMe
                    ? AppColors.secondaryColor
                    : (isLight ? Colors.grey[200] : Colors.grey[800]),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isMe && isGroup)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.sender?.fullName ?? "مستخدم",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  Text(
                    message.content,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isMe
                          ? AppColors.whiteColor
                          : (isLight ? AppColors.blackColor : AppColors.whiteColor),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeStr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isMe
                              ? AppColors.whiteColor.withOpacity(0.7)
                              : (isLight ? Colors.black54 : Colors.white54),
                          fontSize: 10,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        _buildStatusIcon(message),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MessageEntity message) {
    final bool isRead = (message.readCount ?? 0) > 0;
    final bool isReceived = (message.receivedCount ?? 0) > 0;

    if (isRead) {
      return const Icon(Icons.done_all, color: Colors.blueAccent, size: 16);
    } else if (isReceived) {
      return const Icon(Icons.done_all, color: Colors.white70, size: 16);
    } else {
      return const Icon(Icons.done, color: Colors.white70, size: 16);
    }
  }
}
