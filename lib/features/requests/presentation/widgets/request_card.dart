import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/media_query.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entity/request_entity.dart';

Widget buildRequestCard({
  required BuildContext context,
  required RequestEntity request,
  required MediaQueryHelper media,
  required bool isDarkMode,
  required VoidCallback onTap,
  required VoidCallback onLongPress,
}) {
  final cardColor = isDarkMode ? AppColors.blackColor : Colors.white;
  final titleColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
  final statusEnum = request.status;

  String formatRequestTime(String createdAtString) {
    try {
      if (createdAtString.isEmpty) return "";
      final DateTime parsedDate = DateTime.parse(createdAtString).toLocal();
      final now = DateTime.now();

      if (parsedDate.year == now.year && parsedDate.month == now.month && parsedDate.day == now.day) {
        return DateFormat('hh:mm a', 'ar').format(parsedDate);
      } else {
        return DateFormat('yyyy/MM/dd').format(parsedDate);
      }
    } catch (e) {
      return "";
    }
  }

  return Container(
    margin: EdgeInsets.only(bottom: media.height * 0.015),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(media.width * 0.035),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(media.width * 0.035),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: media.width * 0.015,
                color: statusEnum.color,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(media.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              request.serving.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: media.width * 0.04,
                                color: titleColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: media.width * 0.025,
                              vertical: media.height * 0.005,
                            ),
                            decoration: BoxDecoration(
                              color: statusEnum.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(media.width * 0.02),
                            ),
                            child: Text(
                              statusEnum.translation,
                              style: TextStyle(
                                color: statusEnum.color,
                                fontWeight: FontWeight.bold,
                                fontSize: media.width * 0.03,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.height * 0.01),
                      Text(
                        request.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: media.width * 0.035,
                          color: isDarkMode ? AppColors.greyColor : Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: media.height * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: AppColors.greyColor,
                                size: media.width * 0.035,
                              ),
                              SizedBox(width: media.width * 0.01),
                              Text(
                                formatRequestTime(request.createdAt),
                                style: TextStyle(
                                  color: AppColors.greyColor,
                                  fontSize: media.width * 0.03,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.greyColor.withOpacity(0.5),
                            size: media.width * 0.035,
                          ),
                        ],
                      ),
                    ],
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