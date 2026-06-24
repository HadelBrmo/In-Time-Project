import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/constants/mediaQuery.dart'; // استيراد الـ MediaQuery المساعد
import 'package:in_time/core/widgets/customAppBar.dart';
import 'package:in_time/core/widgets/customDrawer.dart';
import 'package:in_time/features/profile/presentation/widgets/profile_header.dart';
import '../widgets/profile_info_row.dart';
import '../widgets/portfolio_action_button.dart';
import 'package:in_time/features/profile/presentation/pages/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final containerColor = isDarkMode ? const Color(0xFF252525) : AppColors.whiteColor;
    final textColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.3) : AppColors.blackColor.withOpacity(0.08);

    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(
        title: const Text(
          'الملف الشخصي',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfilePage(),
                ),
              );
            },
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: media.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: media.width * 0.05,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: media.height * 0.09),
                    padding: EdgeInsets.fromLTRB(
                      media.width * 0.06,
                      media.height * 0.11,
                      media.width * 0.06,
                      media.height * 0.03,
                    ),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'براءة علي الأحمد',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: media.height * 0.03),
                        const ProfileInfoRow(
                          icon: Icons.work_outline,
                          text: 'مصمم واجهات UI/UX',
                        ),
                        const ProfileInfoRow(
                          icon: Icons.location_on_outlined,
                          text: 'سوريا - دمشق',
                        ),
                        const ProfileInfoRow(
                          icon: Icons.person_outline,
                          text: 'أنثى',
                        ),
                        const ProfileInfoRow(
                          icon: Icons.calendar_month_outlined,
                          text: '12 / 05 / 2000',
                        ),
                        SizedBox(height: media.height * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 24,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.greyColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.star_border,
                              color: AppColors.primaryColor,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const ProfileHeader(),
                ],
              ),
            ),
            SizedBox(height: media.height * 0.025),
            Padding(
              padding: EdgeInsets.only(
                left: media.width * 0.05,
                right: media.width * 0.07,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'أضف معرض أعمالك',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: media.height * 0.012),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: media.width * 0.05,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: media.width * 0.05,
                vertical: media.height * 0.03,
              ),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: media.height * 0.01),
                  const Text(
                    'معرض أعمالك يزيد من فرص طلب خدماتك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: media.height * 0.03),
                  Row(
                    children: [
                      Expanded(
                        child: PortfolioActionButton(
                          title: 'رابط',
                          icon: Icons.link,
                          onTap: () {},
                        ),
                      ),
                      SizedBox(width: media.width * 0.025),
                      Expanded(
                        child: PortfolioActionButton(
                          title: 'ملف',
                          icon: Icons.description_outlined,
                          onTap: () {},
                        ),
                      ),
                      SizedBox(width: media.width * 0.025),
                      Expanded(
                        child: PortfolioActionButton(
                          title: 'صورة',
                          icon: Icons.image_outlined,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: media.height * 0.03),
                  Container(
                    width: media.width * 0.14,
                    height: media.width * 0.14,
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF3A3A3A) : AppColors.greyColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: media.height * 0.05),
          ],
        ),
      ),
    );
  }
}