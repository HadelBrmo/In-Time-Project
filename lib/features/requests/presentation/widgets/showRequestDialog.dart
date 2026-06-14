import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../bloc/request_bloc.dart';
import '../bloc/request_event.dart';

void showRequestDialog({
  required BuildContext context,
  required int servingId,
  required MediaQueryHelper media,
  required bool isDarkMode,
  required Color cardBg,
  required Color textColor,
}) {
  final TextEditingController messageController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'إرسال طلب خدمة',
            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'هل تود ترك رسالة اختيارية لمقدم الخدمة؟',
                style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[700], fontSize: 14),
              ),
              SizedBox(height: media.height * 0.015),
              TextField(
                controller: messageController,
                maxLines: 3,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك هنا (اختياري)...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  filled: true,
                  fillColor: isDarkMode ? const Color(0xFF333333) : const Color(0xFFF0F0F0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: media.width * 0.04, vertical: media.height * 0.015),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<RequestsBloc>().add(
                  CreateServingRequestEvent(
                    servingId: servingId,
                    message: null,
                  ),
                );
              },
              child: Text(
                'تخطي وإرسال',
                style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<RequestsBloc>().add(
                  CreateServingRequestEvent(
                    servingId: servingId,
                    message: messageController.text.trim().isEmpty ? null : messageController.text.trim(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'إرسال الطلب',
                style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    },
  );
}