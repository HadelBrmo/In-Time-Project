import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/rewards_bloc.dart';
import '../bloc/rewards_state.dart';
import '../widgets/reward_card.dart';

class MyRewardsPage extends StatelessWidget {
  const MyRewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          title: Text(
            context.tr('view_my_rewards'),
            style: theme.textTheme.titleSmall?.copyWith(color: AppColors.whiteColor, fontSize: 18.sp),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode 
                ? [const Color(0xFF1A1A1A), const Color(0xFF0D0D0D)]
                : [AppColors.primaryColor, AppColors.secondaryColor.withOpacity(0.8)],
            ),
          ),
          child: BlocBuilder<RewardsBloc, RewardsState>(
            builder: (context, state) {
              print("🎨 [MyRewardsPage] Current state: $state");
              if (state is RewardsLoading) {
                return const LoadingWidget();
              } else if (state is RewardsError) {
                return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
              } else if (state is RewardsLoaded) {
                if (state.rewards.isEmpty) {
                  return Center(
                    child: Text(
                      context.tr('no_rewards_yet'),
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                  );
                }

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + kToolbarHeight + 20.h,
                          bottom: 30.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.stars, color: AppColors.yellowColor, size: 60.r)
                                .animate(onPlay: (controller) => controller.repeat())
                                .shimmer(duration: 1200.ms, color: Colors.white)
                                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 1000.ms, curve: Curves.easeInOut),
                            SizedBox(height: 16.h),
                            Text(
                              context.tr('total_hours_earned'),
                              style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w300),
                            ),
                            FittedBox(
                              child: Text(
                                "${state.totalHoursAdded}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 48.sp,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(color: AppColors.yellowColor, blurRadius: 20.r),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final reward = state.rewards[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: RewardCard(
                                title: reward.reason,
                                rewardType: reward.type,
                                hours: reward.hoursAdded,
                                date: reward.createdAt,
                              ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1),
                            );
                          },
                          childCount: state.rewards.length,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
