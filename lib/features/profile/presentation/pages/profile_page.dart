import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/customDrawer.dart';
import '../../../../core/widgets/customErrorView.dart';
import '../../../../injection_container.dart';
import '../../data/models/user_profile_model.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_row.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userId = prefs.getInt('user_id') ?? 0;

    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(FetchProfile(userId)),
      child: ProfileView(userId: userId),
    );
  }
}

class ProfileView extends StatelessWidget {
  final int userId;
  const ProfileView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: ResponsiveLayout.isMobile(context) ? const CustomDrawer() : null,
      appBar: CustomAppBar(
        title: Text(
          context.tr('profile'),
          style: theme.textTheme.titleSmall,
        ),
        actions: [
          IconButton(
            onPressed: () {
              final state = profileBloc.state;
              if (state is ProfileLoaded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: profileBloc,
                      child: EditProfilePage(profile: state.userProfile),
                    ),
                  ),
                ).then((_) {
                  profileBloc.add(FetchProfile(userId));
                });
              }
            },
            icon: const Icon(Icons.edit_outlined, color: AppColors.whiteColor),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return ResponsiveLayout(
              mobileBody: _buildProfileContent(context, state.userProfile),
              tabletBody: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _buildProfileContent(context, state.userProfile),
                ),
              ),
              desktopBody: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: _buildProfileContent(context, state.userProfile),
                ),
              ),
            );
          } else if (state is ProfileError) {
            return CustomErrorView(
              message: state.message,
              onRetry: () {
                profileBloc.add(FetchProfile(userId));
              },
            );
          } else {
            return Center(
              child: Text(
                context.tr('click_to_load'),
                style: theme.textTheme.titleMedium,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProfile profile) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final containerColor = isDarkMode ? const Color(0xFF252525) : AppColors.whiteColor;
    final textColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.3) : AppColors.blackColor.withOpacity(0.08);

    String displayValue(String? value) => (value != null && value.isNotEmpty) ? value : context.tr('not_specified');

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: media.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: media.height * 0.09),
                  padding: EdgeInsets.fromLTRB(
                    media.width * 0.06,
                    media.height * 0.11,
                    media.width * 0.06,
                    media.height * 0.03,
                  ),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        profile.fullName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: media.height * 0.03),
                      ProfileInfoRow(icon: Icons.work_outline, text: displayValue(profile.currentJob)),
                      ProfileInfoRow(icon: Icons.location_on_outlined, text: displayValue(profile.address)),
                      ProfileInfoRow(icon: Icons.email_outlined, text: profile.email),
                      ProfileInfoRow(icon: Icons.phone_outlined, text: displayValue(profile.phoneNumber)),
                      ProfileInfoRow(
                        icon: Icons.person_outline,
                        text: profile.gender == 'not specified' ? context.tr('not_specified') : profile.gender,
                      ),
                      ProfileInfoRow(icon: Icons.calendar_month_outlined, text: displayValue(profile.birthDate)),
                      SizedBox(height: media.height * 0.015),
                    ],
                  ),
                ),
                ProfileHeader(
                  imageUrl: profile.profilePicture,
                ),
              ],
            ),
          ),
          SizedBox(height: media.height * 0.05),
        ],
      ),
    );
  }
}