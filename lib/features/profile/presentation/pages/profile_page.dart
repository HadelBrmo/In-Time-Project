import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/media_query.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_drawer.dart';
import '../../../../core/widgets/custom_error_view.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../bloc/portfolio/portfolio_bloc.dart';
import '../bloc/portfolio/portfolio_event.dart';
import '../bloc/portfolio/portfolio_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_row.dart';
import '../widgets/portfolio_action_button.dart';
import 'edit_profile_page.dart';
import 'portfolio_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userId = prefs.getInt('user_id') ?? 0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ProfileBloc>()..add(FetchProfile(userId))),
        BlocProvider(create: (context) => sl<PortfolioBloc>()),
      ],
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

    return BlocListener<PortfolioBloc, PortfolioState>(
      listener: (context, state) {
        if (state is PortfolioUploading) {
          _showLoading(context);
        } else if (state is PortfolioUploadSuccess) {
          _hideLoading(context);
          _showMessage(context, 'تم رفع العنصر إلى السيرفر بنجاح');
        } else if (state is PortfolioUploadError) {
          _hideLoading(context);
          _showMessage(context, state.message, isError: true);
        }
      },
      child: Scaffold(
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
      ),
    );
  }

  void _showLoading(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            profile.fullName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 24,
                              color: textColor,
                            ),
                          ),
                          if (profile.isVerified) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 24,
                            ),
                          ],
                        ],
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
          SizedBox(height: media.height * 0.03),
          _buildPortfolioSection(context, media, theme, isDarkMode, containerColor, shadowColor),
          SizedBox(height: media.height * 0.05),
        ],
      ),
    );
  }


  Future<void> _uploadImage(BuildContext context) async {
    try {
      final picker = sl<ImagePicker>();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null || !context.mounted) return;

      final title = await _askTitle(context, 'عنوان الصورة', image.name);
      if (!context.mounted || title == null) return;

      context.read<PortfolioBloc>().add(UploadPortfolioImage(
        userId: userId,
        image: image,
        title: title,
      ));
    } catch (e) {
      if (context.mounted) _showMessage(context, _errorText(e), isError: true);
    }
  }

  Future<void> _uploadFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty || !context.mounted) return;

      final file = result.files.first;
      final title = await _askTitle(context, 'عنوان الملف', file.name);
      if (!context.mounted || title == null) return;

      context.read<PortfolioBloc>().add(UploadPortfolioFile(
        userId: userId,
        file: file,
        title: title,
      ));
    } catch (e) {
      if (context.mounted) _showMessage(context, _errorText(e), isError: true);
    }
  }

  Future<void> _uploadLink(BuildContext context) async {
    final result = await _askLink(context);
    if (!context.mounted || result == null) return;

    try {
      context.read<PortfolioBloc>().add(UploadPortfolioLink(
        userId: userId,
        url: result.url,
        title: result.title,
      ));
    } catch (e) {
      if (context.mounted) _showMessage(context, _errorText(e), isError: true);
    }
  }

  Future<String?> _askTitle(
      BuildContext context,
      String label,
      String fallback,
      ) async {
    final controller = TextEditingController(text: fallback);

    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(label),
        content: TextField(
          controller: controller,
          autofocus: true,
          textDirection: TextDirection.rtl,
          decoration: const InputDecoration(
            hintText: 'اكتب عنواناً',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('رفع'),
          ),
        ],
      ),
    );

    controller.dispose();
    if (value == null) return null;
    return value.trim().isEmpty ? fallback : value.trim();
  }

  Future<_LinkUploadData?> _askLink(BuildContext context) async {
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    final value = await showDialog<_LinkUploadData>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إضافة رابط'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                labelText: 'عنوان الرابط',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'الرابط',
                hintText: 'https://example.com',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final url = urlController.text.trim();
              final uri = Uri.tryParse(url);
              if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('أدخل رابطاً صحيحاً يبدأ بـ http أو https')),
                );
                return;
              }
              Navigator.pop(
                dialogContext,
                _LinkUploadData(
                  title: titleController.text.trim().isEmpty ? url : titleController.text.trim(),
                  url: url,
                ),
              );
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );

    titleController.dispose();
    urlController.dispose();
    return value;
  }

  void _showMessage(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _errorText(Object error) {
    final text = error.toString();
    return text.startsWith('Exception: ') ? text.substring(11) : text;
  }

  Widget _buildPortfolioSection(
      BuildContext context,
      MediaQueryHelper media,
      ThemeData theme,
      bool isDarkMode,
      Color containerColor,
      Color shadowColor,
      ) {
    final textColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
    final portfolioBloc = BlocProvider.of<PortfolioBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('add_to_portfolio'),
            style: theme.textTheme.titleSmall?.copyWith(color: textColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: media.height * 0.015),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(media.width * 0.04),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: shadowColor, blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: PortfolioActionButton(
                        title: context.tr('image'),
                        icon: Icons.image_outlined,
                        onTap: () => _uploadImage(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PortfolioActionButton(
                        title: context.tr('file'),
                        icon: Icons.folder_outlined,
                        onTap: () => _uploadFile(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PortfolioActionButton(
                        title: context.tr('link'),
                        icon: Icons.link_rounded,
                        onTap: () => _uploadLink(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.height * 0.015),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PortfolioPage(
                          userId: userId,
                          bloc: portfolioBloc..add(FetchPortfolio(userId)),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    context.tr('view_all'),
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: media.height * 0.01),
          Center(
            child: Text(
              context.tr('portfolio_benefit_hint'),
              style: theme.textTheme.headlineSmall?.copyWith(color: AppColors.greyColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkUploadData {
  final String title;
  final String url;

  const _LinkUploadData({required this.title, required this.url});
}
