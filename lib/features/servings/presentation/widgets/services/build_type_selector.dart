import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/media_query.dart';
import '../../../../../core/localization/app_localizations.dart';

class ServiceTypeSelector extends StatefulWidget {
  final Function(int) onTypeChanged;
  final int initialIndex;

  const ServiceTypeSelector({
    super.key,
    required this.onTypeChanged,
    this.initialIndex = 0,
  });

  @override
  State<ServiceTypeSelector> createState() => _ServiceTypeSelectorState();
}

class _ServiceTypeSelectorState extends State<ServiceTypeSelector> {
  late int selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<String> types = [
      context.tr('exchange'),
      context.tr('voluntary'),
      context.tr('paid')
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(types.length, (index) {
        bool isSelected = selectedType == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedType = index;
            });
            widget.onTypeChanged(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: media.width * 0.012),
            padding: EdgeInsets.symmetric(
                horizontal: media.width * 0.05,
                vertical: media.height * 0.01
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDarkMode ? AppColors.secondaryColor : AppColors.primaryColor)
                  : (isDarkMode ? AppColors.blackColor : Colors.grey[100]),
              borderRadius: BorderRadius.circular(media.width * 0.025),
              border: isDarkMode && !isSelected
                  ? Border.all(color: const Color(0xFF3A3A3A))
                  : null,
            ),
            child: Text(
              types[index],
              style: TextStyle(
                fontSize: media.width * 0.035,
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }
}
