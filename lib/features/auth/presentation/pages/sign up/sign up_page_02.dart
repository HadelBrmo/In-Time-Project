import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:in_time/features/auth/presentation/pages/otp/otp_page.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/widgets/buildLabel.dart';
import '../../../../../core/widgets/customTextFormField.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/global_particles_wrapper.dart';
import '../../bloc/SignUpBloc/sign up_bloc.dart';
import '../../bloc/SignUpBloc/sign up_event.dart';
import '../../widgets/signup_widgets/buildHeaderForSignUp.dart';

class SignUpPage2 extends StatefulWidget {
  const SignUpPage2({super.key});

  @override
  State<SignUpPage2> createState() => _SignUpPage02State();
}

class _SignUpPage02State extends State<SignUpPage2> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final containerBg = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;
    final inputFillColor = isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor;

    return GlobalParticlesWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              buildHeaderForSignUp(media, context, subTitle: context.tr('login_info')),

              Container(
                margin: EdgeInsets.only(
                  top: media.height * 0.19,
                  right: media.width * 0.03,
                  left: media.width * 0.03,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: containerBg,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: media.width * 0.04,
                    vertical: media.height * 0.05,
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildLabel(context, context.tr('email')),
                          CustomTextFormField(
                            fillColor: inputFillColor,
                            controller: _emailController,
                            hintText: context.tr('enter_email'),
                            validator: Validators.validateEmail,
                          ),
                          SizedBox(height: media.height * 0.02),
                          buildLabel(context, context.tr('phone_number')),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: IntlPhoneField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                hintText: context.tr('enter_phone_number'),
                                hintStyle: theme.textTheme.titleMedium?.copyWith(
                                    color: isDarkMode ? AppColors.whiteColor.withOpacity(0.7) : AppColors.greyColor,
                                    fontSize: 14
                                ),
                                filled: true,
                                fillColor: inputFillColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.3)),
                                ),
                              ),
                              initialCountryCode: 'SY',
                              textAlign: TextAlign.right,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                              ),
                              onChanged: (phone) {
                                // phone.completeNumber;
                              },
                            ),
                          ),
                          SizedBox(height: media.height * 0.02),
                          buildLabel(context, context.tr('password')),
                          CustomTextFormField(
                            fillColor: inputFillColor,
                            controller: _passwordController,
                            hintText: context.tr('enter_password'),
                            isPassword: true,
                            validator: Validators.validatePassword,
                          ),
                          SizedBox(height: media.height * 0.02),
                          buildLabel(context, context.tr('confirm_password')),
                          CustomTextFormField(
                            fillColor: inputFillColor,
                            controller: _confirmPasswordController,
                            hintText: context.tr('re_type_password'),
                            isPassword: true,
                            validator: (value) => Validators.validateConfirmPassword(value, _passwordController.text),
                          ),
                          SizedBox(height: media.height * 0.08),
                          Center(
                            child: CustomButton(
                              text: context.tr('next'),
                              width: media.width * 0.65,
                              fontSize: 18,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<SignUpBloc>().add(
                                    UpdateSignUpFieldsEvent(
                                      email: _emailController.text,
                                      phone: _phoneController.text,
                                      password: _passwordController.text,
                                      confirmPassword: _confirmPasswordController.text,
                                    ),
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const OtpPage(email: ""))
                                  );
                                }
                              },
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}