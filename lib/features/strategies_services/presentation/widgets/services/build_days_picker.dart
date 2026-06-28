import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';

class MultiSelectDaysDropdown extends StatefulWidget {
  final List<String> selectedDays;
  final Function(List<String>) onChanged;

  const MultiSelectDaysDropdown({
    super.key,
    required this.selectedDays,
    required this.onChanged
  });

  @override
  State<MultiSelectDaysDropdown> createState() => _MultiSelectDaysDropdownState();
}

class _MultiSelectDaysDropdownState extends State<MultiSelectDaysDropdown> {
  final List<String> _allDays = [
    "السبت", "الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة"
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    return InkWell(
      onTap: () => _showMultiSelectDialog(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: media.width * 0.03, 
          vertical: media.height * 0.018
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(media.width * 0.04),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.selectedDays.isEmpty
                    ? "اختر أيام الخدمة"
                    : widget.selectedDays.join("، "),
                style: TextStyle(
                  color: widget.selectedDays.isEmpty ? Colors.grey : Colors.black87,
                  fontSize: media.width * 0.04,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: AppColors.primaryColor, size: media.width * 0.06),
          ],
        ),
      ),
    );
  }

  void _showMultiSelectDialog(BuildContext context) {
    final media = MediaQueryHelper(context);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                "أيام الخدمة", 
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: media.width * 0.045, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: _allDays.map((day) {
                    final bool isSelected = widget.selectedDays.contains(day);
                    return CheckboxListTile(
                      title: Text(
                        day, 
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: media.width * 0.04),
                      ),
                      value: isSelected,
                      activeColor: AppColors.primaryColor,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked!) {
                            widget.selectedDays.add(day);
                          } else {
                            widget.selectedDays.remove(day);
                          }
                          widget.onChanged(widget.selectedDays);
                        });
                        setDialogState(() {});
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "تم", 
                    style: TextStyle(color: AppColors.primaryColor, fontSize: media.width * 0.04)
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
