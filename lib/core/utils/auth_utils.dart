import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_time/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:in_time/injection_container.dart';
import 'package:in_time/core/constants/app_routes.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/utils/dialog_utils.dart';

import '../../features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';

class AuthUtils {
  static bool isLoggedIn() {
    final prefs = sl<SharedPreferences>();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  static void showLoginPrompt(BuildContext context) {
    DialogUtils.showConfirmDialog(
      context: context,
      title: 'تسجيل الدخول مطلوب',
      message: 'يرجى تسجيل الدخول للقيام بهذا الإجراء.',
      confirmText: 'تسجيل الدخول',
      onConfirm: () {
        Navigator.pushNamed(context, AppRoutes.login);
      },
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
    final chatBloc = sl<ChatBloc>();
    chatBloc.clearAllPulling();

    final prefs = sl<SharedPreferences>();
    await prefs.remove('token');
    await prefs.remove('refresh_token');

    final authLocal = sl<AuthLocalDataSource>();
    await authLocal.clearToken();

    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }
}
