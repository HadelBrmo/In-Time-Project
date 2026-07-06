import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';


class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.greyColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              color: AppColors.primaryColor,
              size: 26,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(
          color: AppColors.greyColor,
          thickness: 1,
        ),
      ],
    );
  }
}