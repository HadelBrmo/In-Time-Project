import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/leaderboard_user_entity.dart';

class LeaderboardItem extends StatelessWidget {
  final LeaderboardUserEntity user;
  const LeaderboardItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryColor.withOpacity(0.1),
            backgroundImage: (user.profilePicture != null && user.profilePicture!.isNotEmpty)
                ? NetworkImage(user.profilePicture!)
                : null,
            child: (user.profilePicture == null || user.profilePicture!.isEmpty)
                ? const Icon(Icons.person, color: AppColors.primaryColor)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              user.fullName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${user.rank}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
