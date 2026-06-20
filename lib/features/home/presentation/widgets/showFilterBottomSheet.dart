import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class FilterBottomSheet extends StatelessWidget {
  final bool isDarkMode;
  final int? selectedPaymentUnitId;
  final int? selectedServingTypeId;
  final Function(int? typeId, String? typeName, int? unitId, String? unitName) onApply;

  const FilterBottomSheet({
    super.key,
    required this.isDarkMode,
    required this.selectedPaymentUnitId,
    required this.selectedServingTypeId,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
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
        bottom: MediaQuery.of(context).viewInsets.bottom + 25,
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
                    onApply(null, null, null, null);
                    Navigator.pop(context);
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
                  onApply(
                    selected ? type['id'] : null,
                    selected ? type['name'] : null,
                    selectedPaymentUnitId,
                    null, // سيتم تحديث الاسم المختار عبر الـ HomeScreen لاحقاً أو الحفاظ عليه
                  );
                  Navigator.pop(context);
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
                  onApply(
                    selectedServingTypeId,
                    null,
                    selected ? unit['id'] : null,
                    selected ? unit['name'] : null,
                  );
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}