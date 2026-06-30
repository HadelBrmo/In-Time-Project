import 'package:flutter/cupertino.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';

Widget buildGridInfoRow(
    BuildContext context, {
      required IconData icon1,
      required String text1,
      required IconData icon2,
      required String text2,
      required Color infoItemBg,
      required Color textColor,
      required MediaQueryHelper media,
    }) {
  return Row(
    children: [
      Expanded(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: infoItemBg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon1, color: AppColors.primaryColor, size: 20),
            ),
            SizedBox(width: media.width * 0.03),
            Expanded(
              child: Text(
                text1,
                style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: media.width * 0.02),
      Expanded(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: infoItemBg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon2, color: AppColors.primaryColor, size: 20),
            ),
            SizedBox(width: media.width * 0.03),
            Expanded(
              child: Text(
                text2,
                style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}