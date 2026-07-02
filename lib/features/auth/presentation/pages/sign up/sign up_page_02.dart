import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:in_time/features/auth/presentation/pages/otp/otp_page.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
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
  final _nationalIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;
    final containerBg = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;
    final inputFillColor = isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor;

    return GlobalParticlesWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              buildHeaderForSignUp(media, context, subTitle: "معلومات الدخول"),

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
                          buildLabel(context, "البريد الإلكتروني"),
                          CustomTextFormField(
                            fillColor: inputFillColor,
                            controller: _emailController,
                            hintText: "ادخل بريدك الإلكتروني",
                            validator: Validators.validateEmail,
                          ),
                          SizedBox(height: media.height * 0.02),
                          buildLabel(context, "رقم الموبايل"),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: IntlPhoneField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                hintText: 'ادخل رقم الموبايل',
                                hintStyle: TextStyle(
                                    color: isDarkMode ? Colors.white70 : Colors.grey,
                                    fontSize: 14
                                ),
                                filled: true,
                                fillColor: inputFillColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: AppColors.greyColor.withValues(alpha: 0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: AppColors.greyColor.withValues(alpha: 0.3)),
                                ),
                              ),
                              initialCountryCode: 'SY',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : AppColors.blackColor,
                              ),
                              onChanged: (phone) {
                                // print(phone.completeNumber);
                              },
                            ),
                          ),
                          SizedBox(height: media.height * 0.02),
                          buildLabel(context, "كلمة المرور"),
                          CustomTextFormField(
                            fillColor: inputFillColor,
                            controller: _passwordController,
                            hintText: "ادخل كلمة المرور",
                            isPassword: true,
                            validator: Validators.validatePassword,
                          ),
                          SizedBox(height: media.height * 0.02),
                          buildLabel(context, "تأكيد كلمة المرور"),
                          CustomTextFormField(
                            fillColor: inputFillColor,
                            controller: _confirmPasswordController,
                            hintText: "اعد كتابة كلمة المرور",
                            isPassword: true,
                            validator: (value) => Validators.validateConfirmPassword(value, _passwordController.text),
                          ),
                          SizedBox(height: media.height * 0.08),
                          Center(
                            child: CustomButton(
                              text: "التالي",
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