// core/widgets/custom_error_widget.dart

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomErrorView extends StatelessWidget {
  final String message;
  final int? statusCode;
  final VoidCallback onRetry;

  const CustomErrorView({
    super.key,
    required this.message,
    this.statusCode,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    String guidanceMessage = "يرجى التحقق من المدخلات وإعادة المحاولة.";
    if (statusCode == 401) guidanceMessage = "انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً.";
    if (statusCode == 500) guidanceMessage = "هناك مشكلة في السيرفر حالياً، يعمل فريقنا على حلها.";
    if (statusCode == 404) guidanceMessage = "الرابط المطلوب غير موجود.";

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/submit_complaint.png',
              height: media.height * 0.28,
            ),
            SizedBox(height: media.height * 0.03),

            Text(
              statusCode != null ? "خطأ رقم ($statusCode)" : "عذراً، حدث خطأ ما",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent),
            ),
            SizedBox(height: media.height * 0.015),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[800], fontWeight: FontWeight.w500),
            ),
            SizedBox(height: media.height * 0.01),

            Text(
              guidanceMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            SizedBox(height: media.height * 0.04),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text("إعادة المحاولة", style: TextStyle(color: Colors.white, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}