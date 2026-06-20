import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

void showFilterBottomSheet({
  required BuildContext context,
  required bool isDarkMode,
  required int? selectedPaymentUnitId,
  required int? selectedServingTypeId,
  required Function(int? id, String? name) onTypeSelected,
  required Function(int? id, String? name) onUnitSelected,
  required VoidCallback onClearAll,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (bottomSheetContext) {
      final List<Map<String, dynamic>> serviceTypes = [
        {'id': 1, 'name': 'مدفوعة'},
        {'id': 2, 'name': 'تبادلية'},
        {'id': 3, 'name': 'تطوعية'},
      ];

      final List<Map<String, dynamic>> units = [
        {'id': 1, 'name': 'USD'},
        {'id': 2, 'name': 'Hour'},
        {'id': 3, 'name': 'SYP'},
      ];

      return Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "تصفية وفق خياراتك",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                  ),
                ),
                if (selectedPaymentUnitId != null || selectedServingTypeId != null)
                  TextButton(
                    onPressed: () {
                      onClearAll();
                      Navigator.pop(bottomSheetContext);
                    },
                    child: const Text("إعادة تعيين الكل", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const Divider(height: 25, thickness: 1),
            Text(
              "نوع الخدمة",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: serviceTypes.map((type) {
                final isSelected = selectedServingTypeId == type['id'];
                return ChoiceChip(
                  label: Text(type['name']),
                  selected: isSelected,
                  selectedColor: AppColors.primaryColor.withOpacity(0.25),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primaryColor
                        : (isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    onTypeSelected(
                      selected ? type['id'] : null,
                      selected ? type['name'] : null,
                    );
                    Navigator.pop(bottomSheetContext);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              "واحدة الدفع (العملة / الزمن)",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: units.map((unit) {
                final isSelected = selectedPaymentUnitId == unit['id'];
                return ChoiceChip(
                  label: Text(unit['name']),
                  selected: isSelected,
                  selectedColor: AppColors.primaryColor.withOpacity(0.25),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primaryColor
                        : (isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    onUnitSelected(
                      selected ? unit['id'] : null,
                      selected ? unit['name'] : null,
                    );
                    Navigator.pop(bottomSheetContext);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      );
    },
  );
}