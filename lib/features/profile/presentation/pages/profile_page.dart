import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/widgets/customAppBar.dart';
import 'package:in_time/core/widgets/customDrawer.dart';
import 'package:in_time/features/profile/presentation/widgets/profile_header.dart';
import '../widgets/profile_info_row.dart';
import '../widgets/portfolio_action_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      drawer: const CustomDrawer(),

      appBar: CustomAppBar(
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_outlined,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [

                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 75),
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      95,
                      24,
                      24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackColor.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: const Column(
                      children: [

                        Text(
                          'براءة علي الأحمد',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),

                        SizedBox(height: 30),

                        ProfileInfoRow(
                          icon: Icons.work_outline,
                          text: 'مصمم واجهات UI/UX',
                        ),

                        ProfileInfoRow(
                          icon: Icons.location_on_outlined,
                          text: 'سوريا - دمشق',
                        ),

                        ProfileInfoRow(
                          icon: Icons.person_outline,
                          text: 'أنثى',
                        ),

                        ProfileInfoRow(
                          icon: Icons.calendar_month_outlined,
                          text: '12 / 05 / 2000',
                        ),

                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 26,
                            ),

                            SizedBox(width: 6),

                            Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                   color: AppColors.greyColor,
                              ),
                            ),
                            SizedBox(width:12),

                            const Icon(
                              Icons.star_border,
                              color: AppColors.primaryColor,
                              size: 26,
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

            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.only(left: 20 , right:28), 
            child:SizedBox(
              width: double.infinity,
            child:Text(
                    'أضف معرض أعمالك',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ), ),),
                  const SizedBox(height: 10),
            

            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 25,
              ),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                children: [

                  

                  const SizedBox(height: 10),

                  const Text(
                    'معرض أعمالك يزيد من فرص طلب خدماتك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [

                      Expanded(
                        child: PortfolioActionButton(
                          title: 'رابط',
                          icon: Icons.link,
                          onTap: () {},
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: PortfolioActionButton(
                          title: 'ملف',
                          icon: Icons.description_outlined,
                          onTap: () {},
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: PortfolioActionButton(
                          title: 'صورة',
                          icon: Icons.image_outlined,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 32,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}