import 'package:flutter/material.dart';
import '../../../../core/constants/assets_image.dart';
import '../../../../core/constants/mediaQuery.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(media.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: .center,
              children: [
                Image.asset(
                  AssetsImage.onboardingImage1,
                  fit: BoxFit.contain,
                  height: media.isPortrait ? media.height * 0.5 : media.height * 0.5,
                ),
                SizedBox(height: media.height * 0.01),
                Text(
                  'وقتك هو أثمن ما لديك',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: media.isPortrait ? 24 : 22,
                  ),
                ),
                SizedBox(height: media.height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                  child: Text(
                    'استثمر وقتك بحكمة واحصل على رصيد من الساعات',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: media.isPortrait ? 20 : 14,
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
}//شارك مهاراتك معنا
//قدم مهاراتك وساعد الاخرين مقابل وقتهم و خبراتهم