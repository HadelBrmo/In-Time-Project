import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/localization/app_localizations.dart';
import '../../../../../../core/theme/glowing_border.dart';
import '../../../../../../core/widgets/custom_image_view.dart';
import 'package:in_time/features/servings/domain/entity/service_entity.dart';
import '../../../../servings/presentation/bloc/saved_services/saved_services_bloc.dart';
import '../../pages/service_details_page.dart';

Widget buildServiceCard(BuildContext context, ServiceEntity serving, double width, double height, {VoidCallback? onLongPress, EdgeInsetsGeometry? padding}) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  final address = serving.locationAddress;
  final displayAddress = (address != null && address.isNotEmpty)
      ? address.split(',').take(2).join(' - ')
      : context.tr('unspecified_location');

  Color typeColor;
  final typeName = serving.servingTypeName?.toLowerCase() ?? '';

  if (serving.unitId == "2" || typeName.contains('exchange') || typeName.contains('تبادل')) {
    typeColor = const Color(0xFF81C784);
  } else if (typeName.contains('paid') || typeName.contains('مدفوع')) {
    typeColor = const Color(0xFFE57373);
  } else {
    typeColor = const Color(0xFF4FC3F7);
  }

  return Padding(
    padding: padding ?? EdgeInsets.only(bottom: height * 0.03),
    child: GlowingBorder(
      glowColors: const [
        AppColors.primaryColor,
        AppColors.secondaryColor,
        AppColors.primaryColor,
        AppColors.secondaryColor,
      ],
      borderRadius: 15,
      strokeWidth: 2.0,
      child: InkWell(
        onTap: () {
          if (serving.id != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ServiceDetailsPage(
                  serviceId: serving.id!,
                  isFromMyServings: false,
                ),
              ),
            );
          }
        },
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 110.h,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
            border: isDarkMode ? Border.all(color: const Color(0xFF3A3A3A), width: 1) : null,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black.withOpacity(0.2) : AppColors.blackColor.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 85.w,
                    height: 94.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColors.secondaryColor.withOpacity(0.1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: CustomImageView(
                        imageUrl: serving.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: BlocBuilder<SavedServicesBloc, SavedServicesState>(
                      builder: (context, state) {
                        bool isSaved = false;
                        if (state is SavedServicesLoaded) {
                          isSaved = state.savedServices.any((s) => s.id == serving.id);
                        }
                        return GestureDetector(
                          onTap: () {
                            context.read<SavedServicesBloc>().add(ToggleSaveServiceEvent(serving));
                          },
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.r),
                                bottomRight: Radius.circular(10.r),
                              ),
                            ),
                            child: Icon(
                              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: isSaved ? AppColors.yellowColor : Colors.white,
                              size: 14.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  serving.userFullName ?? context.tr('system_user'),
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5.sp,
                                    color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (serving.isUserVerified == true) ...[
                                SizedBox(width: 3.w),
                                Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                  size: 13.sp,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: serving.meetingType == 'online'
                                ? AppColors.accentColor.withOpacity(0.1)
                                : AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            serving.meetingType == 'online' ? context.tr('online') : context.tr('direct'),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 9.sp,
                              color: serving.meetingType == 'online'
                                  ? (isDarkMode ? const Color(0xFF64FFDA) : AppColors.accentColor)
                                  : (isDarkMode ? AppColors.secondaryColor : AppColors.primaryColor),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      serving.title.trim().split(RegExp(r'\s+')).take(2).join(' '),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 12.sp,
                        color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (serving.categoryName != null && serving.categoryName!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.grid_view_rounded, size: 10.sp, color: AppColors.primaryColor),
                          SizedBox(width: 4.w),
                          Text(
                            serving.categoryName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10.sp,
                              color: isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                color: typeColor,
                                size: 13.sp,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "${serving.costAmount} ${serving.unitName ?? ''}",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: typeColor,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              displayAddress,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 10.sp,
                                color: AppColors.greyColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: 3.w),
                            Icon(Icons.location_on_outlined, color: AppColors.greyColor, size: 11.sp),
                          ],
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
