import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/media_query.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/widgets/build_label.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/widgets/global_particles_wrapper.dart';
import '../../bloc/sign_up_bloc/sign_up_bloc.dart';
import '../../bloc/sign_up_bloc/sign_up_event.dart';
import '../../bloc/sign_up_bloc/sign_up_state.dart';
import '../../widgets/signup_widgets/build_gender_dropdown.dart';
import '../../widgets/signup_widgets/build_header_for_sign_up.dart';
import '../../widgets/signup_widgets/custom_date_picker_field.dart';
import 'sign_up_page_02.dart';

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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final media = MediaQueryHelper(context);

    final containerBg = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;
    final avatarOuterBg = isDarkMode ? const Color(0xFF333333) : AppColors.greyColor.withOpacity(0.3);
    final avatarInnerBg = isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor;

    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) => previous.address != current.address,
      listener: (context, state) {
        _addressController.text = state.address;
      },
      child: GlobalParticlesWrapper(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                buildHeaderForSignUp(media, context),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: media.height * 0.22,
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
                          vertical: media.height * 0.12,
                        ),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLabel(context, context.tr('full_name')),
                                CustomTextFormField(
                                  controller: _nameController,
                                  hintText: context.tr('enter_full_name'),
                                  validator: Validators.validateFullName,
                                ),
                                SizedBox(height: media.height * 0.02),
                                buildLabel(context, context.tr('current_job')),
                                CustomTextFormField(
                                  fillColor: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
                                  controller: _jobController,
                                  hintText: context.tr('enter_current_job'),
                                  validator: (value) => Validators.validateRequired(value, context.tr('current_job')),
                                ),
                                SizedBox(height: media.height * 0.02),
                                buildLabel(context, context.tr('address')),
                                CustomTextFormField(
                                  fillColor: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
                                  controller: _addressController,
                                  hintText: context.tr('select_current_address'),
                                  validator: (value) => Validators.validateRequired(value, context.tr('address')),
                                ),
                                SizedBox(height: media.height * 0.02),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          buildLabel(context, context.tr('gender')),
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
                                        label: context.tr('birth_date'),
                                        hintText: context.tr('date_format_hint'),
                                        validator: (value) => Validators.validateRequired(value, context.tr('birth_date')),
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
                                    text: context.tr('next'),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SignUpPage2()),
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
                    Positioned(
                      top: media.height * 0.15,
                      child: BlocBuilder<SignUpBloc, SignUpState>(
                        builder: (context, state) {
                          return Stack(
                            children: [
                              CircleAvatar(
                                radius: media.width * 0.165,
                                backgroundColor: avatarOuterBg,
                                child: GestureDetector(
                                  onTap: () => context.read<SignUpBloc>().add(PickProfileImageEvent()),
                                  child: CircleAvatar(
                                    radius: media.width * 0.16,
                                    backgroundColor: avatarInnerBg,
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
                                  child: const CircleAvatar(
                                    backgroundColor: AppColors.primaryColor,
                                    radius: 18,
                                    child: Icon(Icons.edit, color: AppColors.whiteColor, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}