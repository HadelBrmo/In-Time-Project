import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/media_query.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../data/models/user_profile_model.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';


class EditProfilePage extends StatefulWidget {
  final UserProfile profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _jobController;
  late TextEditingController _addressController;
  late TextEditingController _genderController;
  late TextEditingController _birthDateController;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p.fullName);
    _emailController = TextEditingController(text: p.email);
    _phoneController = TextEditingController(text: p.phoneNumber ?? '');
    _jobController = TextEditingController(text: p.currentJob ?? '');
    _addressController = TextEditingController(text: p.address ?? '');
    _genderController = TextEditingController(text: p.gender);
    _birthDateController = TextEditingController(text: p.birthDate ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobController.dispose();
    _addressController.dispose();
    _genderController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_birthDateController.text) ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final bgColor = isDarkMode ? theme.scaffoldBackgroundColor : Colors.grey[50]!;
    final textColor = isDarkMode ? AppColors.whiteColor : Colors.black87;

    final dropdownFillColor = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;
    final dropdownBorderColor = isDarkMode ? AppColors.greyColor : AppColors.greyColor.withOpacity(0.3);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            SnackBarUtils.showSuccess(context, state.message);
            Navigator.pop(context, true);
          } else if (state is ProfileError) {
            SnackBarUtils.showError(context, '❌ ${state.message}');
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bgColor,
            appBar: CustomAppBar(title: Text(context.tr('edit_profile'))),
            body: ResponsiveLayout(
              mobileBody: _buildEditForm(media, theme, textColor, dropdownFillColor, dropdownBorderColor, state),
              tabletBody: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _buildEditForm(media, theme, textColor, dropdownFillColor, dropdownBorderColor, state),
                ),
              ),
              desktopBody: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: _buildEditForm(media, theme, textColor, dropdownFillColor, dropdownBorderColor, state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditForm(MediaQueryHelper media, ThemeData theme, Color textColor, Color dropdownFillColor, Color dropdownBorderColor, ProfileState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: media.width * 0.05, vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryColor, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 58,
                      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (widget.profile.profilePicture != null && widget.profile.profilePicture!.isNotEmpty
                          ? NetworkImage(widget.profile.profilePicture!.startsWith('http')
                          ? widget.profile.profilePicture!
                          : 'http://ali.ba-tech.tech/storage/${widget.profile.profilePicture}')
                          : null) as ImageProvider?,
                      child: (_imageFile == null && (widget.profile.profilePicture == null || widget.profile.profilePicture!.isEmpty))
                          ? const Icon(Icons.person, size: 55, color: AppColors.primaryColor)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: InkWell(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(Icons.camera_alt_rounded, color: AppColors.whiteColor, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            CustomTextFormField(
              hintText: context.tr('full_name'),
              controller: _nameController,
              prefixIcon: Icons.person_outline,
              validator: Validators.validateFullName,
            ),
            const SizedBox(height: 14),

            CustomTextFormField(
              hintText: context.tr('email'),
              controller: _emailController,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 14),

            CustomTextFormField(
              hintText: context.tr('phone_number'),
              controller: _phoneController,
              prefixIcon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => Validators.validateRequired(v, context.tr('phone_number')),
            ),
            const SizedBox(height: 14),

            CustomTextFormField(
              hintText: context.tr('job'),
              controller: _jobController,
              prefixIcon: Icons.work_outline,
              validator: (v) => Validators.validateRequired(v, context.tr('job')),
            ),
            const SizedBox(height: 14),

            CustomTextFormField(
              hintText: context.tr('address'),
              controller: _addressController,
              prefixIcon: Icons.location_on_outlined,
              validator: (v) => Validators.validateRequired(v, context.tr('address')),
            ),
            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: DropdownButtonFormField<String>(
                value: ['male', 'female'].contains(_genderController.text) ? _genderController.text : null,
                style: theme.textTheme.titleMedium?.copyWith(color: textColor, fontSize: 15),
                dropdownColor: dropdownFillColor,
                validator: (v) => Validators.validateRequired(v, context.tr('gender')),
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
                decoration: InputDecoration(
                  hintText: context.tr('gender'),
                  filled: true,
                  fillColor: dropdownFillColor,
                  prefixIcon: const Icon(Icons.wc_outlined, color: AppColors.primaryColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: dropdownBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: dropdownBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'male', child: Text(context.tr('male'))),
                  DropdownMenuItem(value: 'female', child: Text(context.tr('female'))),
                ],
                onChanged: (value) {
                  if (value != null) _genderController.text = value;
                },
              ),
            ),
            const SizedBox(height: 14),

            CustomTextFormField(
              hintText: context.tr('birth_date'),
              controller: _birthDateController,
              prefixIcon: Icons.calendar_month_outlined,
              readOnly: true,
              onTap: () => _selectBirthDate(context),
              validator: (v) => Validators.validateRequired(v, context.tr('birth_date')),
            ),

            SizedBox(height: media.height * 0.05),

            if (state is ProfileUpdating)
              const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
            else
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ProfileBloc>().add(
                        UpdateProfile(
                          userId: widget.profile.id,
                          fullName: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          phoneNumber: _phoneController.text.trim(),
                          currentJob: _jobController.text.trim(),
                          address: _addressController.text.trim(),
                          gender: _genderController.text,
                          birthDate: _birthDateController.text,
                          profilePicturePath: _imageFile?.path,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 1,
                  ),
                  child: Text(
                    context.tr('save_changes'),
                    style: theme.textTheme.titleMedium?.copyWith(color: AppColors.whiteColor, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}