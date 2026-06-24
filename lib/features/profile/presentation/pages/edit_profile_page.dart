import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/constants/mediaQuery.dart';
import 'package:in_time/core/widgets/buildLabel.dart';
import 'package:in_time/core/widgets/customAppBar.dart';
import 'package:in_time/core/widgets/custom_button.dart';
import 'package:in_time/core/widgets/customTextFormField.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final avatarBgColor = isDarkMode ? const Color(0xFF252525) : AppColors.whiteColor;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.3) : AppColors.blackColor.withOpacity(.04);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: const Text(
          'تعديل الملف الشخصي',

        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: media.width * 0.06,
          vertical: media.height * 0.02,
        ),
        child: Column(
          children: [
            SizedBox(height: media.height * 0.01),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: media.width * 0.45,
                    height: media.width * 0.45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: avatarBgColor,
                      border: Border.all(
                        color: AppColors.greyColor.withOpacity(.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      size: media.width * 0.2,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Positioned(
                    bottom: media.height * 0.01,
                    right: media.width * 0.04,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        width: media.width * 0.11,
                        height: media.width * 0.11,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: AppColors.whiteColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: media.height * 0.04),
            Align(
              alignment: Alignment.centerRight,
              child: buildLabel(context,'الاسم الثلاثي'),
            ),
            CustomTextFormField(
              hintText: 'براءة علي الأحمد',
              prefixIcon: Icons.person_add_alt_1,
            ),
            SizedBox(height: media.height * 0.025),
            Align(
              alignment: Alignment.centerRight,
              child: buildLabel(context,'الوظيفة الحالية'),
            ),
            CustomTextFormField(
              hintText: 'هندسة معلوماتية',
              prefixIcon: Icons.work,
            ),
            SizedBox(height: media.height * 0.025),
            Align(
              alignment: Alignment.centerRight,
              child: buildLabel(context,'العنوان'),
            ),
            CustomTextFormField(
              hintText: 'ريف دمشق - جديدة عرطوز',
              prefixIcon: Icons.location_on,
            ),
            SizedBox(height: media.height * 0.025),
            Align(
              alignment: Alignment.centerRight,
              child: buildLabel(context,'الجنس'),
            ),
            CustomTextFormField(
              hintText: 'أنثى',
              prefixIcon: Icons.wc,
            ),
            SizedBox(height: media.height * 0.025),
            Align(
              alignment: Alignment.centerRight,
              child: buildLabel(context,'تاريخ الميلاد'),
            ),
            CustomTextFormField(
              hintText: '2003 / 02 / 07',
              prefixIcon: Icons.calendar_month,
            ),
            SizedBox(height: media.height * 0.05),
            Center(
              child: CustomButton(
                text: 'حفظ',
                color: AppColors.primaryColor,
                width: media.width * 0.55,
                height: media.height * 0.07,
                fontSize: 18,
                onPressed: () {},
              ),
            ),
            SizedBox(height: media.height * 0.03),
          ],
        ),
      ),
    );
  }
}