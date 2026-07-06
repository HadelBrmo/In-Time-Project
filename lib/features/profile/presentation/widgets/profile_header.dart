// lib/features/profile/presentation/widgets/profile_header.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';

class ProfileHeader extends StatelessWidget {
  final String? imageUrl;

  const ProfileHeader({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    
    // تجهيز الرابط بشكل صحيح
    final String? fullImageUrl = (imageUrl != null && imageUrl!.isNotEmpty)
        ? (imageUrl!.startsWith('http')
            ? imageUrl
            : 'http://ali.ba-tech.tech/storage/$imageUrl')
        : null;

    return Positioned(
      top: 0,
      child: Container(
        width: media.width * 0.28,
        height: media.width * 0.28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor,
          border: Border.all(color: AppColors.whiteColor, width: 4),
          image: fullImageUrl != null
              ? DecorationImage(
                  image: NetworkImage(fullImageUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: fullImageUrl == null
            ? const Icon(Icons.person, color: AppColors.whiteColor, size: 40)
            : null,
      ),
    );
  }
}
