import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/localization/app_localizations.dart';
import 'package:in_time/core/utils/snackbar_utils.dart';
import 'package:in_time/core/widgets/custom_button.dart';
import 'package:in_time/features/servings/presentation/bloc/service/services_bloc.dart';
import 'package:in_time/features/servings/presentation/bloc/service/services_event.dart';
import 'package:in_time/features/servings/presentation/bloc/service/services_state.dart';

class RatingDialog extends StatefulWidget {
  final int serviceId;

  const RatingDialog({super.key, required this.serviceId});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocListener<ServicesBloc, ServicesState>(
      listener: (context, state) {
        if (state is RateServiceSuccessState) {
          SnackBarUtils.showSuccess(context, context.tr('rating_success'));
          Navigator.pop(context);
        } else if (state is RateServiceErrorState) {
          SnackBarUtils.showError(context, state.message);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('rate_service_title'),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                context.tr('rate_service_desc'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                    icon: Icon(
                      index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: index < _rating ? AppColors.yellowColor : Colors.grey,
                      size: 40.sp,
                    ),
                  );
                }),
              ),
              SizedBox(height: 25.h),
              BlocBuilder<ServicesBloc, ServicesState>(
                builder: (context, state) {
                  final bool isLoading = state is RateServiceLoadingState;
                  final bool isDisabled = _rating == 0 || isLoading;

                  return CustomButton(
                    text: context.tr('submit_rating'),
                    onPressed: isDisabled
                        ? () {}
                        : () {
                      context.read<ServicesBloc>().add(
                        RateServiceEvent(
                          serviceId: widget.serviceId,
                          rating: _rating,
                        ),
                      );
                    },
                    color: isDisabled ? Colors.grey : AppColors.primaryColor,
                  );
                },
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  context.tr('cancel'),
                  style: TextStyle(color: isDarkMode ? Colors.grey : Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}