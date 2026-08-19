import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/media_query.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/dialog_utils.dart';
import '../../../../../core/widgets/build_label.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../injection_container.dart';
import '../../bloc/identity_verification/identity_verification_cubit.dart';
import '../../bloc/identity_verification/identity_verification_state.dart';
import '../../widgets/signup_widgets/build_header_for_sign_up.dart';
import '../../widgets/signup_widgets/build_note.dart';

class SignUpPage3 extends StatefulWidget {
  const SignUpPage3({super.key});

  @override
  State<SignUpPage3> createState() => _SignUpPage3State();
}

class _SignUpPage3State extends State<SignUpPage3> {
  String? selectedDocument;
  File? documentImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        documentImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<IdentityVerificationCubit>(),
      child: BlocListener<IdentityVerificationCubit, IdentityVerificationState>(
        listener: (context, state) {
          if (state is IdentityVerificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('verification_sent_message')),
                backgroundColor: Colors.orangeAccent,
                duration: const Duration(seconds: 3),
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.homeScreen,
                  (route) => false,
                );
              }
            });
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
                    child: Directionality(
                      textDirection: Localizations.localeOf(context).languageCode == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Column(
                        children: [
                          Icon(Icons.badge_outlined, size: 100, color: AppColors.primaryColor.withOpacity(0.6)),
                          Text(
                            context.tr('upload_doc_instruction'),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(color: AppColors.greyColor, fontSize: 14),
                          ),
                          Text(
                            context.tr('doc_types_list'),
                            style: theme.textTheme.titleMedium?.copyWith(color: AppColors.greyColor, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 30),
                          buildLabel(context, context.tr('document_type')),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                iconEnabledColor: AppColors.primaryColor,
                                dropdownColor: theme.cardColor,
                                value: selectedDocument,
                                hint: Text(context.tr('select_document_type'), style: theme.textTheme.titleMedium?.copyWith(
                                  color: AppColors.greyColor,
                                  fontSize: 14,
                                )),
                                style: theme.textTheme.titleMedium?.copyWith(color: AppColors.greyColor),
                                isExpanded: true,
                                items: [
                                  context.tr('id_card'),
                                  context.tr('passport'),
                                  context.tr('driver_license')
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (val) => setState(() => selectedDocument = val),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          GestureDetector(
                            onTap: _pickImage,
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                color: AppColors.primaryColor.withOpacity(0.5),
                                strokeWidth: 2,
                                dashPattern: const [8, 4],
                                radius: const Radius.circular(15),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[50],
                                child: documentImage != null
                                    ? Image.file(documentImage!, fit: BoxFit.cover)
                                    : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.camera_alt, color: AppColors.primaryColor, size: 40),
                                    Text(
                                      context.tr('click_to_upload_doc'),
                                      style: theme.textTheme.titleMedium?.copyWith(color: AppColors.primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          buildNote(context.tr('ensure_image_clear')),
                          buildNote(context.tr('all_info_visible')),

                          const SizedBox(height: 30),
                          BlocBuilder<IdentityVerificationCubit, IdentityVerificationState>(
                            builder: (context, state) {
                              return CustomButton(
                                text: context.tr('send_for_verification'),
                                width: media.width * 0.7,
                                isLoading: state is IdentityVerificationLoading,
                                onPressed: () {
                                  if (selectedDocument == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(context.tr('select_document_type'))),
                                    );
                                    return;
                                  }
                                  if (documentImage == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(context.tr('click_to_upload_doc'))),
                                    );
                                    return;
                                  }

                                  String docTypeKey = 'id_card';
                                  if (selectedDocument == context.tr('passport')) {
                                    docTypeKey = 'passport';
                                  } else if (selectedDocument == context.tr('driver_license')) {
                                    docTypeKey = 'driver_license';
                                  }

                                  context.read<IdentityVerificationCubit>().verifyIdentity(
                                    documentType: docTypeKey,
                                    documentImage: documentImage!,
                                  );
                                },
                                color: AppColors.primaryColor,
                              );
                            },
                          ),
                        ],
                      ),
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
}