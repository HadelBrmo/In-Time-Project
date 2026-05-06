import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:in_time/features/auth/presentation/pages/sign%20up/sign%20up_page_03.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/widgets/buildLabel.dart';
import '../../../../../core/widgets/customTextFormField.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../widgets/signup_widgets/buildHeaderForSignUp.dart';


class SignUpPage2 extends StatefulWidget {
  const SignUpPage2({super.key});

  @override
  State<SignUpPage2> createState() => _SignUpPage02State();
}

class _SignUpPage02State extends State<SignUpPage2> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            buildHeaderForSignUp(media, context, subTitle: "معلومات الدخول"),

            Container(
              margin: EdgeInsets.only
                (top: media.height * 0.19,
                  right: media.width * 0.03,
                  left: media.width * 0.03),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildLabel("البريد الإلكتروني"),
                      CustomTextFormField(
                        controller: _emailController,
                        hintText: "ادخل بريدك الإلكتروني",
                      ),
                      SizedBox(height: media.height * 0.02),
                      buildLabel("رقم الموبايل"),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: IntlPhoneField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: 'ادخل رقم الموبايل',
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                            filled: true,
                            fillColor: AppColors.whiteColor,
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
                          style: TextStyle(
                              color: AppColors.blackColor
                          ),
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                        ),
                      ),
                      buildLabel("الرقم الوطني"),
                      CustomTextFormField(
                        controller: _nationalIdController,
                        hintText: "ادخل الرقم الوطني",
                      ),
                      SizedBox(height: media.height * 0.02),
                      buildLabel("كلمة المرور"),
                      CustomTextFormField(
                        controller: _passwordController,
                        hintText: "ادخل كلمة المرور",
                        isPassword: true,
                      ),
                      SizedBox(height: media.height * 0.02),
                      buildLabel("تأكيد كلمة المرور"),
                      CustomTextFormField(
                        controller: _confirmPasswordController,
                        hintText: "اعد كتابة كلمة المرور",
                        isPassword: true,
                      ),

                      SizedBox(height: media.height * 0.04),
                      Center(
                        child: CustomButton(
                          text: "التالي",
                          width: media.width * 0.65,
                          fontSize: 18,
                          onPressed: () {
                            // context.read<SignUpBloc>().add(SubmitSignUpEvent());
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage3()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}