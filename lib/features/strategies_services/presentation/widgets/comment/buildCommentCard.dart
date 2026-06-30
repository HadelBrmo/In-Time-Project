import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../domain/entity/comment_entity.dart';
import '../../bloc/comment/comment_bloc.dart';
import '../../bloc/comment/comment_event.dart';
import 'buildReactionIcon.dart';

Widget buildCommentCard(
    BuildContext context,
    CommentEntity comment,
    MediaQueryHelper media,
    bool isDarkMode, {
      required VoidCallback onReplyTap,
    }) {
  final cardColor = isDarkMode ? AppColors.blackColor : Colors.white;
  final nameColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;

  String formatCommentTime(String createdAtString) {
    try {
      if (createdAtString.isEmpty) return "منذ مدة";
      final DateTime parsedDate = DateTime.parse(createdAtString).toLocal();

      final now = DateTime.now();
      if (parsedDate.year == now.year && parsedDate.month == now.month && parsedDate.day == now.day) {
        return DateFormat('hh:mm a', 'ar').format(parsedDate);
      } else {
        return DateFormat('yyyy/MM/dd').format(parsedDate);
      }
    } catch (e) {
      return "منذ فترة";
    }
  }

  List<TextSpan> _buildCommentContentSpans(String content, bool isDarkMode) {
    final List<TextSpan> spans = [];
    final List<String> words = content.split(' ');
    final defaultColor = isDarkMode ? AppColors.greyColor : Colors.black87;

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final space = i == words.length - 1 ? "" : " ";

      if (word.startsWith('@')) {
        spans.add(
          TextSpan(
            text: '$word$space',
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$word$space',
            style: TextStyle(color: defaultColor),
          ),
        );
      }
    }
    return spans;
  }

  final double leftPadding = comment.depth > 0 ? media.width * 0.08 : 0.0;
  final double rightPadding = comment.depth > 0 ? 0.0 : 0.0;

  return Container(
    margin: EdgeInsets.only(
      bottom: media.height * 0.015,
      right: rightPadding,
      left: leftPadding,
    ),
    padding: EdgeInsets.all(media.width * 0.04),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(15),
      border: comment.depth > 0
          ? Border.all(color: isDarkMode ? const Color(0xFF383838) : const Color(0xFFE2E8F0), width: 1)
          : null,
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 3)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: comment.depth > 0 ? 18 : 22,
              backgroundColor: isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0F2F1),
              child: Icon(
                Icons.person,
                color: AppColors.primaryColor,
                size: comment.depth > 0 ? 18 : 22,
              ),
            ),
            SizedBox(width: media.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comment.userFullName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: comment.depth > 0 ? 14 : 15,
                            color: nameColor
                        ),
                      ),
                      const Icon(Icons.more_vert, color: AppColors.greyColor, size: 20),
                    ],
                  ),
                  Text(
                    formatCommentTime(comment.createdAt),
                    style: const TextStyle(color: AppColors.greyColor, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: media.height * 0.01),

        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, height: 1.4),
            children: _buildCommentContentSpans(comment.content, isDarkMode),
          ),
        ),

        SizedBox(height: media.height * 0.015),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (comment.canAddReply)
              InkWell(
                onTap: onReplyTap,
                child: Row(
                  children: const [
                    Text("رد", style: TextStyle(color: AppColors.accentColor, fontWeight: FontWeight.bold)),
                    SizedBox(width: 4),
                    Icon(Icons.reply_rounded, color: AppColors.accentColor, size: 18),
                  ],
                ),
              )
            else
              const SizedBox(),
            Row(
              children: [
                buildReactionIcon(
                  icon: comment.likesCount > 0 ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                  count: comment.likesCount.toString(),
                  onTap: () {
                    context.read<CommentBloc>().add(LikeCommentEvent(comment.id));
                  },
                ),
                const SizedBox(width: 15),
                buildReactionIcon(
                  icon: comment.dislikesCount > 0 ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
                  count: comment.dislikesCount.toString(),
                  onTap: () {
                    context.read<CommentBloc>().add(DislikeCommentEvent(comment.id));
                  },
                ),
              ],
            )
          ],
        ),
      ],
    ),
  );
}