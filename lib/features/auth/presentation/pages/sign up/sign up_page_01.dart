import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:in_time/features/auth/presentation/pages/sign%20up/sign%20up_page_02.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/widgets/customTextFormField.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/utils/validators.dart';
import '../../bloc/SignUpBloc/sign up_bloc.dart';
import '../../bloc/SignUpBloc/sign up_event.dart';
import '../../bloc/SignUpBloc/sign up_state.dart';
import '../../widgets/signup_widgets/buildGenderDropdown.dart';
import '../../widgets/signup_widgets/buildHeaderForSignUp.dart';
import '../../../../../core/widgets/buildLabel.dart';
import '../../widgets/signup_widgets/customDatePickerField.dart';
import '../locationPicker/location_picker_page.dart';

class SignUpPage1 extends StatefulWidget {
  const SignUpPage1({super.key});

  @override
  State<SignUpPage1> createState() => _SignUpPage1State();
}

class _SignUpPage1State extends State<SignUpPage1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _jobController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) => previous.address != current.address,
      listener: (context, state) {
        _addressController.text = state.address;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              buildHeaderForSignUp(media, context),
              Stack(
                 alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only
                      (top: media.height * 0.22,
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
                        vertical: media.height * 0.12,
                      ),
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildLabel("الاسم الثلاثي"),
                              CustomTextFormField(
                                controller: _nameController,
                                hintText: "ادخل اسمك الثلاثي",
                                validator: Validators.validateFullName,
                              ),
                              SizedBox(height: media.height * 0.02),
                              buildLabel("الوظيفة الحالية"),
                              CustomTextFormField(
                                controller: _jobController,
                                hintText: "ادخل وظيفتك الحالية",
                                validator: (value) => Validators.validateRequired(value, "الوظيفة الحالية"),
                              ),
                              SizedBox(height: media.height * 0.02),
                              buildLabel("العنوان"),
                              CustomTextFormField(
                                controller: _addressController,
                                hintText: "حدد عنوانك الحالي ",
                                validator: (value) => Validators.validateRequired(value, "العنوان"),
                              ),
                              SizedBox(height: media.height * 0.02),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        buildLabel("الجنس"),
                                        BlocBuilder<SignUpBloc, SignUpState>(
                                          builder: (context, state) =>
                                              buildGenderDropdown(context, state.gender),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: media.width * 0.04),
                                  Expanded(
                                    child: CustomDatePickerField(
                                      controller: _birthDateController,
                                      label: "تاريخ الميلاد",
                                      hintText: "يوم/شهر/سنة",
                                      validator: (value) => Validators.validateRequired(value, "تاريخ الميلاد"),
                                      onDateSelected: (date) {
                                        context.read<SignUpBloc>().add(UpdateBirthDateEvent(date));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: media.height * 0.05),
                              Center(
                                child: CustomButton(
                                  text: "التالي",
                                  width: media.width * 0.65,
                                  height: 55,
                                  fontSize: 18,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<SignUpBloc>().add(
                                        UpdateSignUpFieldsEvent(
                                          fullName: _nameController.text,
                                          currentJob: _jobController.text,
                                          address: _addressController.text,
                                        ),
                                      );
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpPage2()));
                                    }
                                  }, color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: media.height * 0.15,
                    child: BlocBuilder<SignUpBloc, SignUpState>(
                      builder: (context, state) {
                        return Stack(
                          children: [
                            CircleAvatar(
                              radius: media.width * 0.165,
                              backgroundColor: Colors.grey[300],
                              child: GestureDetector(
                                onTap: () => context.read<SignUpBloc>().add(PickProfileImageEvent()),
                                child: CircleAvatar(
                                  radius: media.width * 0.16,
                                  backgroundColor: AppColors.whiteColor,
                                  backgroundImage: state.profileImage != null
                                      ? FileImage(state.profileImage!)
                                      : null,
                                  child: state.profileImage == null
                                      ? Icon(Icons.camera_alt_rounded, size: media.width * 0.10, color: AppColors.primaryColor)
                                      : null,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => context.read<SignUpBloc>().add(PickProfileImageEvent()),
                                child: CircleAvatar(
                                  backgroundColor: AppColors.primaryColor,
                                  radius: 18,
                                  child: const Icon(Icons.edit, color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )],

          ),
        ),
      ),
    );
  }











}