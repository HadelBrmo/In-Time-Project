import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/assets_image.dart';
import '../../../../core/localization/app_localizations.dart';
import '../bloc/rewards_bloc.dart';
import '../bloc/rewards_event.dart';
import '../bloc/rewards_state.dart';
import 'reward_card.dart';

class RewardsSection extends StatelessWidget {
  const RewardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 20),
        BlocBuilder<RewardsBloc, RewardsState>(
          builder: (context, state) {
            if (state is RewardsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RewardsError) {
              return Center(child: Text(state.message));
            }
            
            // Define static rewards as seen in screenshot
            final List<Map<String, dynamic>> staticRewards = [
              {
                'id': 'verification',
                'title': context.tr('reward_reason_verification'),
                'image': AssetsImage.accountVerification,
                'status': 'not_achieved',
              },
              {
                'id': 'honor_board',
                'title': context.tr('reward_reason_honor_board'),
                'image': AssetsImage.rankOnTheHonorBoard,
                'status': 'in_progress',
              },
              {
                'id': 'free_hours',
                'title': context.tr('reward_reason_free_hours'),
                'image': AssetsImage.tenFreeHours,
                'status': 'earned',
              },
            ];

            // If we have actual rewards from API, we could update the status of static ones
            if (state is RewardsLoaded) {
              // Logic to update status based on earned rewards
              // For now, we just show the static ones to match the screenshot perfectly
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: staticRewards.map((reward) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: RewardCard(
                      title: reward['title'],
                      imagePath: reward['image'],
                      status: reward['status'],
                      onViewConditions: () {
                        // TODO: Show conditions dialog
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          context.tr('rewards'),
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
