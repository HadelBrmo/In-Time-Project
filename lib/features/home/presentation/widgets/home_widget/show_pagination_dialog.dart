import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class PaginationDialog extends StatefulWidget {
  final bool isDarkMode;
  final int currentTake;
  final Function(int newTake) onConfirm;

  const PaginationDialog({
    super.key,
    required this.isDarkMode,
    required this.currentTake,
    required this.onConfirm,
  });

  @override
  State<PaginationDialog> createState() => _PaginationDialogState();
}

class _PaginationDialogState extends State<PaginationDialog> {
  late TextEditingController _countController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _countController = TextEditingController(text: widget.currentTake.toString());
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        "تحديد عدد العناصر",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: widget.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "أدخل عدد الخدمات التي ترغب في عرضها بالصفحة القادمة:",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _countController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(color: widget.isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
              decoration: InputDecoration(
                hintText: "مثال: 5",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: widget.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "الرجاء إدخال الرقم";
                }
                final parsed = int.tryParse(value);
                if (parsed == null || parsed <= 0) {
                  return "الرجاء إدخال رقم صحيح أكبر من 0";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("إلغاء", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onConfirm(int.parse(_countController.text.trim()));
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text("تطبيق", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}