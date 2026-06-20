import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../core/widgets/custom_button.dart';

class BalanceCard extends StatelessWidget {
  final int currentHours;
  final int targetHours;

  const BalanceCard({
    super.key,
    required this.currentHours,
    required this.targetHours,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    double progress = targetHours > 0 ? (currentHours / targetHours).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(media.width * 0.06),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: media.width * 0.18,
                color: AppColors.whiteColor,
              ),
              SizedBox(width: media.width * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "رصيد ساعاتك",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        "$currentHours",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentHours == 1 ? "ساعة" : (currentHours == 2 ? "ساعتان" : "ساعات"),
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: media.height * 0.02),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.4),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFB74D)),
            ),
          ),
          SizedBox(height: media.height * 0.015),

          Text(
            "الهدف الشهري  $targetHours / $currentHours ساعة",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: media.height * 0.02),
          ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: media.width * 0.08, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.white, width: 1),
              ),
            ),
            child: const Text(
              "عرض الأنشطة",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}