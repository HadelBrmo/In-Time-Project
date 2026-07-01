import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/assets_image.dart';
import '../../../../../core/theme/glowingBorder.dart';
import '../../../../servings/domain/entity/service_entity.dart';
import '../../pages/serviceDetailsPage.dart';

Widget buildServiceCard(BuildContext context, ServiceEntity serving, double width, double height) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  final address = serving.locationAddress;
  final displayAddress = (address != null && address.isNotEmpty)
      ? address.split(',').take(2).join(' - ')
      : "موقع غير محدد";

  Color typeColor;
  String typeText;
  final typeName = serving.servingTypeName?.toLowerCase() ?? '';

  if (typeName.contains('paid') || typeName.contains('مدفوع')) {
    typeColor = const Color(0xFFE57373);
    typeText = "مدفوعة";
  } else if (typeName.contains('exchange') || typeName.contains('تبادل')) {
    typeColor = const Color(0xFF81C784);
    typeText = "تبادلية";
  } else {
    typeColor = const Color(0xFF4FC3F7);
    typeText = "تطوعية";
  }

  Color categoryBgColor;
  Color categoryTextColor;
  String categoryLabel;
  final categoryIdStr = serving.categoryId?.toString() ?? '';

  switch (categoryIdStr) {
    case "1":
      categoryBgColor = Colors.orange.withOpacity(0.15);
      categoryTextColor = isDarkMode ? Colors.orangeAccent : Colors.orange.shade900;
      categoryLabel = "تعليمية";
      break;
    case "2":
      categoryBgColor = Colors.teal.withOpacity(0.15);
      categoryTextColor = isDarkMode ? Colors.tealAccent : Colors.teal.shade900;
      categoryLabel = "طبية";
      break;
    case "3":
      categoryBgColor = Colors.purple.withOpacity(0.15);
      categoryTextColor = isDarkMode ? Colors.purpleAccent : Colors.purple.shade900;
      categoryLabel = "فنية";
      break;
    case "4":
      categoryBgColor = Colors.blueGrey.withOpacity(0.15);
      categoryTextColor = isDarkMode ? Colors.blueGrey.shade300 : Colors.blueGrey.shade900;
      categoryLabel = "هندسية";
      break;
    default:
      categoryBgColor = Colors.grey.withOpacity(0.15);
      categoryTextColor = isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700;
      categoryLabel = serving.categoryName ?? "أخرى";
  }

  return Padding(
    padding: EdgeInsets.only(bottom: height * 0.03),
    child: GlowingBorder(
      glowColors: [
        AppColors.primaryColor,
        AppColors.secondaryColor,
        AppColors.primaryColor,
        AppColors.secondaryColor,
      ],
      borderRadius: 15,
      strokeWidth: 2.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServiceDetailsPage(
                serviceId: serving.id!,
                isFromMyServings: false,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(width * 0.03,),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
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
              Stack(
                children: [
                  Container(
                    width: width * 0.25,
                    height: width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.secondaryColor.withOpacity(0.6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: serving.imageUrl != null && serving.imageUrl!.isNotEmpty
                          ? Image.network(serving.imageUrl!, fit: BoxFit.cover)
                          : Image.asset(AssetsImage.constantImageForService, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    left: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: typeColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                          )
                        ],
                      ),
                      child: Text(
                        typeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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
                              fontSize: width * 0.044,
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            serving.title,
                            style: TextStyle(
                              fontSize: width * 0.038,
                              color: isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
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
                                fontSize: width * 0.038,
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
                                    fontSize: width * 0.035,
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
      ),
    ),
  );
}