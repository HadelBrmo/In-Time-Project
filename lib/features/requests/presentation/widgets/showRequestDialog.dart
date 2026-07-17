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
  final TextEditingController daysController = TextEditingController(text: "14");

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
          content: SingleChildScrollView(
            child: Column(
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
                SizedBox(height: media.height * 0.02),
                Text(
                  'إلغاء الطلب تلقائياً بعد (أيام):',
                  style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: media.height * 0.01),
                TextField(
                  controller: daysController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'مثلاً: 14',
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
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: media.width * 0.04, vertical: media.height * 0.015),
          actions: [
            TextButton(
              onPressed: () {
                final days = int.tryParse(daysController.text) ?? 14;
                Navigator.pop(dialogContext);
                context.read<RequestsBloc>().add(
                  CreateServingRequestEvent(
                    servingId: servingId,
                    message: null,
                    automaticallyCancelAfter: days,
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
                final days = int.tryParse(daysController.text) ?? 14;
                Navigator.pop(dialogContext);
                context.read<RequestsBloc>().add(
                  CreateServingRequestEvent(
                    servingId: servingId,
                    message: messageController.text.trim().isEmpty ? null : messageController.text.trim(),
                    automaticallyCancelAfter: days,
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