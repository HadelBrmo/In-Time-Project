import '../../../../../core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/media_query.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../bloc/login_bloc/login_bloc.dart';
import '../../bloc/login_bloc/login_event.dart';
import '../../bloc/login_bloc/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isRememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final labelColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          SnackBarUtils.showSuccess(context, context.tr('login_success'));
          Navigator.pushReplacementNamed(context, '/homeScreen');
        }

        if (state is LoginError) {
          SnackBarUtils.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('email'),
                style: theme.textTheme.headlineSmall?.copyWith(color: labelColor),
              ),
              SizedBox(height: media.height * 0.01),
              CustomTextFormField(
                controller: _emailController,
                hintText: context.tr('enter_email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.trim().isEmpty ? context.tr('please_enter_email') : null,
              ),

              SizedBox(height: media.height * 0.02),

              Text(
                context.tr('password'),
                style: theme.textTheme.headlineSmall?.copyWith(color: labelColor),
              ),
              SizedBox(height: media.height * 0.01),
              CustomTextFormField(
                controller: _passwordController,
                hintText: context.tr('enter_password'),
                isPassword: true,
                validator: (value) => value == null || value.length < 6 ? context.tr('weak_password') : null,
              ),

              SizedBox(height: media.height * 0.02),

              _buildRememberMeRow(context, isDarkMode),

              SizedBox(height: media.height * 0.04),

              Center(
                child: state is LoginLoading
                    ? const LoadingWidget()
                    : CustomButton(
                  width: media.width * 0.7,
                  height: media.height * 0.07,
                  text: context.tr('login'),
                  color: AppColors.primaryColor,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<LoginBloc>().add(
                        LoginSubmittedEvent(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRememberMeRow(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            context.tr('forgot_password'),
            style: theme.textTheme.titleMedium?.copyWith(color: AppColors.primaryColor),
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: isRememberMe,
              onChanged: (val) => setState(() => isRememberMe = val!),
              activeColor: AppColors.primaryColor,
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryColor;
                }
                return isDarkMode ? const Color(0xFF2E2E2E) : AppColors.whiteColor;
              }),
              side: BorderSide(
                color: isDarkMode ? Colors.white54 : AppColors.greyColor.withOpacity(0.5),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            Text(
              context.tr('remember_me'),
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}