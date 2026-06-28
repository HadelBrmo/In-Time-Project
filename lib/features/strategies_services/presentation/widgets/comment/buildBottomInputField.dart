import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../bloc/comment/comment_bloc.dart';
import '../../bloc/comment/comment_event.dart';

Widget buildBottomInputField(
    BuildContext context,
    MediaQueryHelper media,
    bool isDarkMode,
    TextEditingController commentController,
    int servingId,
    ) {
  final inputBg = isDarkMode ? const Color(0xFF252525) : Colors.white;

  return Container(
    padding: EdgeInsets.only(
      left: media.width * 0.05,
      right: media.width * 0.05,
      top: media.height * 0.02,
      bottom: media.height * 0.03,
    ),
    decoration: BoxDecoration(
      color: inputBg,
      borderRadius: BorderRadius.vertical(top: Radius.circular(media.width * 0.06)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, -4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "أضف تعليقاً",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: media.width * 0.038),
        ),
        SizedBox(height: media.height * 0.012),
        Container(
          padding: EdgeInsets.symmetric(horizontal: media.width * 0.04),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF333333) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(media.width * 0.035),
          ),
          child: Row(
            children: [
              Icon(Icons.image_outlined, color: AppColors.greyColor, size: media.width * 0.055),
              SizedBox(width: media.width * 0.025),
              Expanded(
                child: TextField(
                  controller: commentController,
                  style: TextStyle(fontSize: media.width * 0.035),
                  decoration: InputDecoration(
                    hintText: "اكتب تعليقك هنا...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: media.width * 0.035, color: AppColors.greyColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: media.height * 0.02),
        SizedBox(
          width: media.width * 0.32,
          height: media.height * 0.055,
          child: ElevatedButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                context.read<CommentBloc>().add(
                  AddCommentEvent(servingId: servingId, content: commentController.text),
                );
                commentController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(media.width * 0.025),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "إرسال",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: media.width * 0.038,
                  ),
                ),
                SizedBox(width: media.width * 0.02),
                Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: media.width * 0.042,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}