import '../../../../../core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/widgets/customTextFormField.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../bloc/loginBloc/login_bloc.dart';
import '../../bloc/loginBloc/login_event.dart';
import '../../bloc/loginBloc/login_state.dart';

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

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final labelColor = isDarkMode ? Colors.white : AppColors.blackColor;
    final inputFillColor = isDarkMode ? const Color(0xFF2E2E2E) : AppColors.whiteColor;

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          SnackBarUtils.showSuccess(context, "تم تسجيل الدخول بنجاح!");
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
                "البريد الإلكتروني",
                style: TextStyle(color: labelColor, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: media.height * 0.01),
              CustomTextFormField(
                controller: _emailController,
                hintText: "ادخل بريدك الإلكتروني",
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.trim().isEmpty ? "يرجى إدخال البريد" : null,
              ),

              SizedBox(height: media.height * 0.02),

              Text(
                "كلمة المرور",
                style: TextStyle(color: labelColor, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: media.height * 0.01),
              CustomTextFormField(
                controller: _passwordController,
                hintText: "ادخل كلمة المرور",
                isPassword: true,
                validator: (value) => value == null || value.length < 6 ? "كلمة المرور ضعيفة" : null,
              ),

              SizedBox(height: media.height * 0.02),

              _buildRememberMeRow(isDarkMode),

              SizedBox(height: media.height * 0.04),

              Center(
                child: state is LoginLoading
                    ? const LoadingWidget()
                    : CustomButton(
                  width: media.width * 0.7,
                  height: media.height * 0.07,
                  text: "تسجيل الدخول",
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

  Widget _buildRememberMeRow(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: const Text("نسيت كلمة المرور؟", style: TextStyle(color: AppColors.primaryColor)),
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
                return isDarkMode ? const Color(0xFF2E2E2E) : Colors.white;
              }),
              side: BorderSide(
                color: isDarkMode ? Colors.white54 : AppColors.greyColor.withOpacity(0.5),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            const Text(
              "تذكرني",
              style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}