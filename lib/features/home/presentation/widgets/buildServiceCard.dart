import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/service_entity.dart';
import '../pages/serviceDetailsPage.dart';

Widget buildServiceCard(BuildContext context, ServicingEntity serving, double width, double height) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  final address = serving.locationAddress;

  final displayAddress = (address != null && address.isNotEmpty)
      ? address.split(',').take(2).join(' - ')
      : "موقع غير محدد";

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ServiceDetailsPage(service: serving),
        ),
      );
    },
    borderRadius: BorderRadius.circular(15),
    child: Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF252525) : AppColors.whiteColor,
        border: isDarkMode ? Border.all(color: const Color(0xFF3A3A3A), width: 1) : null,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.17) : AppColors.blackColor.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width * 0.22,
            height: width * 0.22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.secondaryColor.withOpacity(0.6),
            ),
            child: serving.imageUrl != null && serving.imageUrl!.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(serving.imageUrl!, fit: BoxFit.cover),
            )
                : const SizedBox.shrink(),
          ),
          SizedBox(width: width * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        serving.userFullName ?? "مستخدم النظام",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.042,
                          color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.003),
                      decoration: BoxDecoration(
                        color: serving.meetingType == 'online'
                            ? AppColors.accentColor.withOpacity(0.15)
                            : AppColors.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        serving.meetingType == 'online' ? "أونلاين" : "مباشر",
                        style: TextStyle(
                          fontSize: width * 0.032,
                          color: serving.meetingType == 'online'
                              ? (isDarkMode ? const Color(0xFF64FFDA) : AppColors.accentColor)
                              : (isDarkMode ? AppColors.secondaryColor : AppColors.primaryColor),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.005),

                Text(
                  serving.title,
                  style: TextStyle(
                    fontSize: width * 0.036,
                    color: isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: height * 0.01),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.money_outlined, color: AppColors.yellowColor, size: width * 0.045),
                        SizedBox(width: width * 0.02),
                        Text(
                          "${serving.costAmount} ${serving.unitName ?? ''}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? AppColors.secondaryColor : AppColors.primaryColor,
                            fontSize: width * 0.036,
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              displayAddress,
                              style: TextStyle(
                                fontSize: width * 0.033,
                                color: AppColors.greyColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: width * 0.01),
                          Icon(Icons.location_on_outlined, color: AppColors.greyColor, size: width * 0.04),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}