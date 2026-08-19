import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/assets_image.dart';
import '../../../../../../core/localization/app_localizations.dart';
import '../../../../../../core/theme/glowing_border.dart';
import '../../../../servings/domain/entity/service_entity.dart';
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
          height: 145.h,
          padding: EdgeInsets.all(10.w),
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
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.secondaryColor.withOpacity(0.6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: serving.imageUrl != null && serving.imageUrl!.isNotEmpty
                          ? Image.network(serving.imageUrl!, fit: BoxFit.cover)
                          : Image.asset(AssetsImage.constantImageForService, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 7,
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
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r)),
                            ),
                            child: Icon(
                              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: isSaved ? AppColors.yellowColor : Colors.white,
                              size: 18.sp,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            serving.userFullName ?? context.tr('system_user'),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: serving.meetingType == 'online'
                                ? AppColors.accentColor.withOpacity(0.15)
                                : AppColors.primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            serving.meetingType == 'online' ? context.tr('online') : context.tr('direct'),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 10.sp,
                              color: serving.meetingType == 'online'
                                  ? (isDarkMode ? const Color(0xFF64FFDA) : AppColors.accentColor)
                                  : (isDarkMode ? AppColors.secondaryColor : AppColors.primaryColor),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Text(
                      serving.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 13.sp,
                        color: isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: typeColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                color: typeColor,
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "${serving.costAmount} ${serving.unitName ?? ''}",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: typeColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            displayAddress,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 11.sp,
                              color: AppColors.greyColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.location_on_outlined, color: AppColors.greyColor, size: 14.sp),
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