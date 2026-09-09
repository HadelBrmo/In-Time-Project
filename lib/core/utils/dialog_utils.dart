import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DialogUtils {
  static Future<void> showCustomDialog({
    required BuildContext context,
    required Widget builder,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        // Automatically adapt text direction based on the current locale
        final isRtl = Localizations.localeOf(context).languageCode == 'ar';
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: builder,
        );
      },
    );
  }

  static void showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    Color confirmColor = AppColors.primaryColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showCustomDialog(
      context: context,
      builder: AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onCancel != null) onCancel();
            },
            child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onConfirm != null) onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(confirmText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static void showInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'حسناً',
  }) {
    showCustomDialog(
      context: context,
      builder: AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText, style: const TextStyle(color: AppColors.primaryColor)),
          ),
        ],
      ),
    );
  }
}
