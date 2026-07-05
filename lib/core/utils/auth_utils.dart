import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_time/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:in_time/injection_container.dart';
import 'package:in_time/core/constants/app_routes.dart';
import 'package:in_time/core/constants/app_colors.dart';

class AuthUtils {
  static bool isLoggedIn() {
    final prefs = sl<SharedPreferences>();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  static void showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تسجيل الدخول مطلوب'),
          content: const Text('يرجى تسجيل الدخول للقيام بهذا الإجراء.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
              child: const Text('تسجيل الدخول', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  static bool checkAuth(BuildContext context) {
    if (isLoggedIn()) {
      return true;
    } else {
      showLoginPrompt(context);
      return false;
    }
  }

  static Future<void> logout(BuildContext context) async {
    final prefs = sl<SharedPreferences>();
    await prefs.remove('token');
    await prefs.remove('refresh_token');

    final authLocal = sl<AuthLocalDataSource>();
    await authLocal.clearToken();

    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }
}
