import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/widgets/buildLabel.dart';
import 'package:in_time/core/widgets/customAppBar.dart';
import 'package:in_time/core/widgets/custom_button.dart';
import 'package:in_time/core/widgets/customTextFormField.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.whiteColor,

      appBar: CustomAppBar(
        title: const Text(
          'تعديل الملف الشخصي',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        child: Column(
          children: [

            const SizedBox(height: 10),

            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.whiteColor,
                      border: Border.all(
                        color: AppColors.greyColor.withOpacity(.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackColor.withOpacity(.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 120,
                      color: AppColors.primaryColor,
                    ),
                  ),
  
                    Positioned(
                 bottom: 25,
                 right: 25,
                 child: InkWell(
                 onTap: () {
      
                     },
    borderRadius: BorderRadius.circular(25),
    child: Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.camera_alt,
        color: AppColors.whiteColor,
        size: 22,
      ),
    ),
  ),
),
                  
                ],
              ),
            ),

            const SizedBox(height: 40),

            Align(
              alignment: Alignment.centerRight,
              child: buildLabel('الاسم الثلاثي'),
            ),

            CustomTextFormField(
              hintText: 'براءة علي الأحمد',
              prefixIcon: Icons.person_add_alt_1,
            ),

            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerRight,
              child: buildLabel('الوظيفة الحالية'),
            ),

            CustomTextFormField(
              hintText: 'هندسة معلوماتية',
              prefixIcon: Icons.work,
            ),

            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerRight,
              child: buildLabel('العنوان'),
            ),

            CustomTextFormField(
              hintText: 'ريف دمشق - جديدة عرطوز',
              prefixIcon: Icons.location_on,
            ),

            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerRight,
              child: buildLabel('الجنس'),
            ),

            CustomTextFormField(
              hintText: 'أنثى',
              prefixIcon: Icons.wc,
            ),

            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerRight,
              child: buildLabel('تاريخ الميلاد'),
            ),

            CustomTextFormField(
              hintText: '2003 / 02 / 07',
              prefixIcon: Icons.calendar_month,
            ),

            const SizedBox(height: 50),

            Center(
              child: CustomButton(
                text: 'حفظ',
                color: AppColors.primaryColor,
                width: 220,
                height: 60,
                fontSize: 18,
                onPressed: () {},
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

