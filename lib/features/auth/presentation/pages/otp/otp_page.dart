import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../injection_container.dart';
import '../../bloc/otpBloc/otpEvent.dart';
import '../../bloc/otpBloc/otpState.dart';
import '../../bloc/otpBloc/otp_bloc.dart';
import '../sign up/sign up_page_01.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
          _timer?.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getCompleteOtp() {
    return _otpControllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => sl<OtpBloc>(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<OtpBloc, OtpState>(
          listener: (context, state) {
            if (state.status == OtpStatus.success) {
              _startTimer();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("تم إعادة إرسال رمز التحقق بنجاح!"),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state.status == OtpStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("عذراً حدث خطأ، يرجى المحاولة لاحقاً"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: media.width * 0.06),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: media.height * 0.02),
                      Container(
                        padding: EdgeInsets.all(media.width * 0.05),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child:  Icon(
                          Icons.security_outlined,
                          size: media.width * 0.18,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: media.height * 0.04),
                      Text(
                        "التحقق من الحساب",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: media.height * 0.015),

                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 14.sp,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(text: "لقد أرسلنا رمز تفعيل مكون من 6 أرقام إلى بريدك الإلكتروني:\n"),
                            TextSpan(
                              text: widget.email,
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: media.height * 0.05),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: media.width * 0.12,
                            child: TextFormField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                              cursorColor: AppColors.primaryColor,
                              decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: AppColors.greyColor,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                                }
                                if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: media.height * 0.04),
                      Center(
                        child: _canResend
                            ? TextButton(
                          onPressed: state.status == OtpStatus.loading
                              ? null
                              : () {
                            context.read<OtpBloc>().add(
                              SendOtpRequestedEvent(email: widget.email),
                            );
                          },
                          child: const Text(
                            "إعادة إرسال الرمز",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Icon(
                              Icons.access_time,
                              size: 16.sp,
                              color: AppColors.greyColor,
                            ),
                            SizedBox(width: media.width * 0.01),
                            Text(
                              "إعادة الإرسال خلال $_secondsRemaining ثانية",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: media.height * 0.05),

                      state.status == OtpStatus.loading
                          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                          : CustomButton(
                        text: "تأكيد ومتابعة",
                        onPressed: () {
                          String otpCode = _getCompleteOtp();
                          if (otpCode.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("يرجى إدخال الرمز المكون من 6 أرقام كاملاً"),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }
                          print("OTP Verified successfully: $otpCode");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage1(),
                            ),
                          );
                        },
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}