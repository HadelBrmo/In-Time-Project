import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/theme/glowingBorder.dart';
import '../../../../servings/presentation/bloc/service/services_bloc.dart';
import '../../../../servings/presentation/bloc/service/services_event.dart';
import '../../../../servings/presentation/widgets/services/build_days_picker.dart';
import '../../../../servings/presentation/widgets/services/build_time_range_picker.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceAvailabilityManager extends StatefulWidget {
  final int serviceId;
  final List<dynamic> existingSlots;
  final Function(Map<String, dynamic> data) onSaveSlots;

  const ServiceAvailabilityManager({
    super.key,
    required this.serviceId,
    required this.existingSlots,
    required this.onSaveSlots,
  });

  @override
  State<ServiceAvailabilityManager> createState() => _ServiceAvailabilityManagerWithState();
}

class _ServiceAvailabilityManagerWithState extends State<ServiceAvailabilityManager> {
  final List<String> _selectedDays = [];
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  bool _isExpanded = false;

  final Map<String, int> _dayToNumberMap = {
    "الإثنين": 1, "الثلاثاء": 2, "الأربعاء": 3, "الخميس": 4, "الجمعة": 5, "السبت": 6, "الأحد": 7
  };

  @override
  void initState() {
    super.initState();
    _parseExistingSlots();
  }

  void _parseExistingSlots() {
    if (widget.existingSlots.isNotEmpty) {
      final firstSlot = widget.existingSlots.first;
      _startTimeController.text = firstSlot['start_time'] ?? '';
      _endTimeController.text = firstSlot['end_time'] ?? '';
    }
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_selectedDays.isEmpty || _startTimeController.text.isEmpty || _endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء تحديد الأيام والأوقات أولاً"), backgroundColor: Colors.orange),
      );
      return;
    }

    String startTime = _startTimeController.text;
    String endTime = _endTimeController.text;

    if (startTime.split(':').length == 2) startTime = "$startTime:00";
    if (endTime.split(':').length == 2) endTime = "$endTime:00";

    final List<Map<String, dynamic>> slotsPayload = _selectedDays.map((day) {
      return {
        "day_of_week": _dayToNumberMap[day] ?? 1,
        "start_time": startTime,
        "end_time": endTime,
        "notes": "Updated via Mobile App"
      };
    }).toList();

    widget.onSaveSlots({"slots": slotsPayload});
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;

    final textColor = isDarkMode ? Colors.white : AppColors.blackColor;
    final innerContainerBg = isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFEBF8F6);

    final glowColors = [
      AppColors.primaryColor,
      AppColors.secondaryColor,
      AppColors.primaryColor,
      AppColors.secondaryColor,
    ];

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is UpdateAvailabilitySuccessState) {
          setState(() {
            _isExpanded = false;
          });
          // Refresh availability slots in the details page
          context.read<ServicesBloc>().add(GetAvailabilitySlotsEvent(widget.serviceId));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم تحديث مواعيد العمل بنجاح"),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is HomeErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: GlowingBorder(
        borderRadius: 25,
        glowColors: glowColors,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(media.width * 0.05),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(25),
            border: isDarkMode ? Border.all(color: const Color(0xFF3A3A3A)) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.17),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.edit_calendar_rounded, color: AppColors.primaryColor, size: 22),
                        SizedBox(width: media.width * 0.02),
                        Text(
                          widget.existingSlots.isEmpty ? "إضافة أوقات وتواريخ العمل" : "تعديل أوقات وتواريخ العمل",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 15),
                Divider(height: 1, color: isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFEEEEEE)),
                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(media.width * 0.04),
                  decoration: BoxDecoration(
                    color: innerContainerBg,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "حدد أيام العمل المتاحة للخدمة:",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      const SizedBox(height: 8),

                      Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: TextTheme(
                            bodyMedium: TextStyle(color: textColor),
                          ),
                        ),
                        child: MultiSelectDaysDropdown(
                          selectedDays: _selectedDays,
                          onChanged: (days) {
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "حدد الساعات المتاحة:",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      const SizedBox(height: 8),

                      Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme: InputDecorationTheme(
                            labelStyle: TextStyle(color: textColor),
                            hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                          ),
                        ),
                        child: buildTimeRangePicker(
                          context: context,
                          startTimeController: _startTimeController,
                          endTimeController: _endTimeController,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: _submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                    label: const Text(
                      "تحديث المواعيد",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}