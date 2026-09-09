import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_button.dart';
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
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        top: 20, left: 20, right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('edit_service'),
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _titleController,
                style: theme.textTheme.titleMedium,
                decoration: InputDecoration(labelText: context.tr('title')),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                style: theme.textTheme.titleMedium,
                decoration: InputDecoration(labelText: context.tr('complaint_description')),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: theme.textTheme.titleMedium,
                decoration: InputDecoration(labelText: context.tr('price')),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedMeetingType,
                dropdownColor: theme.cardColor,
                style: theme.textTheme.titleMedium,
                items: [
                  DropdownMenuItem(value: "direct", child: Text(context.tr('direct'))),
                  DropdownMenuItem(value: "online", child: Text(context.tr('online'))),
                ],
                onChanged: (v) => setState(() => _selectedMeetingType = v!),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: context.tr('save'),
                  color: AppColors.primaryColor,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave(_titleController.text, _descController.text, double.parse(_priceController.text), _selectedMeetingType);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}