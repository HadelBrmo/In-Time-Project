import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';

class ServiceTypeSelector extends StatefulWidget {
  final Function(int) onTypeChanged;

  const ServiceTypeSelector({super.key, required this.onTypeChanged});

  @override
  State<ServiceTypeSelector> createState() => _ServiceTypeSelectorState();
}

class _ServiceTypeSelectorState extends State<ServiceTypeSelector> {
  int selectedType = 0;
  final List<String> types = ["تبادلية", "تطوعية", "مدفوعة"];

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
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
              color: isSelected ? AppColors.primaryColor : Colors.grey[100],
              borderRadius: BorderRadius.circular(media.width * 0.025),
            ),
            child: Text(
              types[index],
              style: TextStyle(
                fontSize: media.width * 0.035,
                color: isSelected ? Colors.white : AppColors.greyColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }
}
