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
      top: 15,
      bottom: media.height * 0.03,
    ),
    decoration: BoxDecoration(
      color: inputBg,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("أضف تعليقاً", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF333333) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const Icon(Icons.image_outlined, color: AppColors.greyColor),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: "اكتب تعليقك هنا...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14, color: AppColors.greyColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 120,
          height: 45,
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("إرسال", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.send_rounded, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}