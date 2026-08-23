import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/media_query.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../injection_container.dart';
import '../../bloc/identity_verification/identity_verification_cubit.dart';
import '../../bloc/identity_verification/identity_verification_state.dart';
import '../../widgets/signup_widgets/build_header_for_sign_up.dart';

class SignUpPage3 extends StatefulWidget {
  final bool isFromSignup;
  const SignUpPage3({super.key, this.isFromSignup = true});

  @override
  State<SignUpPage3> createState() => _SignUpPage3State();
}

class _SignUpPage3State extends State<SignUpPage3> with WidgetsBindingObserver {
  late IdentityVerificationCubit _cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cubit = sl<IdentityVerificationCubit>();
    _cubit.getStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _cubit.getStatus();
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('could_not_launch_url'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<IdentityVerificationCubit, IdentityVerificationState>(
        listener: (context, state) {
          if (state is IdentityVerificationSessionCreated) {
            _launchUrl(state.verificationUrl);
          } else if (state is IdentityVerificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          backgroundColor: isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                buildHeaderForSignUp(media, context, subTitle: context.tr('identity_verification')),
                Container(
                  margin: EdgeInsets.only(top: media.height * 0.19, right: 10, left: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: BlocBuilder<IdentityVerificationCubit, IdentityVerificationState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            _buildStatusIcon(state),
                            const SizedBox(height: 20),
                            _buildStatusText(context, state),
                            const SizedBox(height: 40),
                            _buildActionButton(context, state, media),
                            if (widget.isFromSignup) ...[
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.homeScreen,
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  context.tr('skip_for_now'),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.greyColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(IdentityVerificationState state) {
    IconData icon = Icons.badge_outlined;
    Color color = AppColors.primaryColor.withOpacity(0.6);

    if (state is IdentityStatusLoaded) {
      switch (state.identityStatus.status) {
        case 'approved':
          icon = Icons.check_circle_outline;
          color = Colors.green;
          break;
        case 'pending':
        case 'resubmission_requested':
          icon = Icons.hourglass_empty;
          color = Colors.orange;
          break;
        case 'declined':
        case 'expired':
          icon = Icons.error_outline;
          color = Colors.red;
          break;
      }
    }

    return Icon(icon, size: 100, color: color);
  }

  Widget _buildStatusText(BuildContext context, IdentityVerificationState state) {
    String title = context.tr('verify_your_identity');
    String subtitle = context.tr('verification_instruction');

    if (state is IdentityStatusLoaded) {
      switch (state.identityStatus.status) {
        case 'approved':
          title = context.tr('identity_verified');
          subtitle = context.tr('identity_verified_desc');
          break;
        case 'pending':
          title = context.tr('verification_pending');
          subtitle = context.tr('verification_pending_desc');
          break;
        case 'resubmission_requested':
          title = context.tr('resubmission_requested');
          subtitle = context.tr('resubmission_requested_desc');
          break;
        case 'declined':
          title = context.tr('verification_declined');
          subtitle = context.tr('verification_declined_desc');
          break;
        case 'expired':
          title = context.tr('verification_expired');
          subtitle = context.tr('verification_expired_desc');
          break;
      }
    }

    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.greyColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, IdentityVerificationState state, MediaQueryHelper media) {
    String buttonText = context.tr('start_verification');
    bool isLoading = state is IdentityVerificationLoading;
    VoidCallback? onPressed = () => context.read<IdentityVerificationCubit>().startVerification();

    if (state is IdentityStatusLoaded) {
      switch (state.identityStatus.status) {
        case 'approved':
          buttonText = context.tr('continue_to_home');
          onPressed = () {
            if (widget.isFromSignup) {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeScreen, (route) => false);
            } else {
              Navigator.pop(context);
            }
          };
          break;
        case 'pending':
        case 'resubmission_requested':
          buttonText = context.tr('continue_verification');
          break;
        case 'declined':
        case 'expired':
          buttonText = context.tr('try_again');
          break;
      }
    }

    return CustomButton(
      text: buttonText,
      width: media.width * 0.7,
      isLoading: isLoading,
      onPressed: onPressed,
      color: AppColors.primaryColor,
    );
  }
}
