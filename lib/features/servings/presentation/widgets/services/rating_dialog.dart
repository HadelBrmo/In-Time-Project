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
  final double initialRating;

  const RatingDialog({super.key, required this.serviceId, this.initialRating = 0});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('rate_service_title'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.tr('rate_service_desc'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 15.h),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1.0;
                        });
                      },
                      icon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Icon(
                          index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: index < _rating ? AppColors.yellowColor : Colors.grey,
                          size: 32.sp,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20.h),
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