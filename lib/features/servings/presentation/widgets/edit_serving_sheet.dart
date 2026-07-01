import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../domain/entity/service_entity.dart';

class EditServingSheet extends StatefulWidget {
  final ServiceEntity serving;
  final Function(String title, String desc, double price, String type) onSave;

  const EditServingSheet({super.key, required this.serving, required this.onSave});

  @override
  State<EditServingSheet> createState() => _EditServingSheetState();
}

class _EditServingSheetState extends State<EditServingSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late String _selectedMeetingType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.serving.title);
    _descController = TextEditingController(text: widget.serving.description);
    _priceController = TextEditingController(text: widget.serving.costAmount?.toString().split('.').first ?? "0");
    _selectedMeetingType = widget.serving.meetingType ?? "direct";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20, left: 20, right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("تعديل الخدمة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 15),
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: "العنوان")),
              const SizedBox(height: 10),
              TextFormField(controller: _descController, maxLines: 3, decoration: const InputDecoration(labelText: "الوصف")),
              const SizedBox(height: 10),
              TextFormField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "السعر")),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedMeetingType,
                items: const [
                  DropdownMenuItem(value: "direct", child: Text("مباشر")),
                  DropdownMenuItem(value: "online", child: Text("أونلاين")),
                ],
                onChanged: (v) => setState(() => _selectedMeetingType = v!),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave(_titleController.text, _descController.text, double.parse(_priceController.text), _selectedMeetingType);
                    }
                  },
                  child: const Text("حفظ", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
