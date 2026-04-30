import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../core/widgets/customTextFormField.dart';
import '../../../../core/widgets/custom_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("البريد الإلكتروني",
              style: TextStyle(color: AppColors.blackColor, fontSize: 15, fontWeight: FontWeight.bold)),
          SizedBox(height: media.height * 0.01),
          CustomTextFormField(
            hintText: "ادخل بريدك الإلكتروني",
            validator: (value) => value!.isEmpty ? "يرجى إدخال البريد" : null,
          ),

          SizedBox(height: media.height * 0.02),

          Text("كلمة المرور",
              style: TextStyle(color: AppColors.blackColor, fontSize: 15, fontWeight: FontWeight.bold)),
          SizedBox(height: media.height * 0.01),
          CustomTextFormField(
            hintText: "ادخل كلمة المرور",
            isPassword: true,
            validator: (value) => value!.length < 6 ? "كلمة المرور ضعيفة" : null,
          ),

          SizedBox(height: media.height * 0.02),

          _buildRememberMeRow(),

          SizedBox(height: media.height * 0.04),

          Center(
            child: CustomButton(
              width: media.width * 0.7,
              height: media.height * 0.07,
              text: "تسجيل الدخول",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: Text("نسيت كلمة المرور؟", style: TextStyle(color: AppColors.primaryColor)),
        ),
        Row(
          children: [
            Checkbox(
              value: isRememberMe,
              onChanged: (val) => setState(() => isRememberMe = val!),
              activeColor: AppColors.primaryColor,
              fillColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? AppColors.primaryColor : Colors.white),
              side: BorderSide(color: AppColors.greyColor.withOpacity(0.5), width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            Text("تذكرني", style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
          ],
        ),

      ],
    );
  }
}