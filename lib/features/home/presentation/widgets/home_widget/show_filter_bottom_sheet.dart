import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../servings/presentation/bloc/service/services_bloc.dart';
import '../../../../servings/presentation/bloc/service/services_event.dart';
import '../../../../servings/presentation/bloc/service/services_state.dart';

class FilterBottomSheet extends StatefulWidget {
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
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int? tempUnitId;
  String? tempUnitName;
  int? tempTypeId;
  String? tempTypeName;

  @override
  void initState() {
    super.initState();
    tempUnitId = widget.selectedPaymentUnitId;
    tempTypeId = widget.selectedServingTypeId;
    
    context.read<ServicesBloc>().add(GetPaymentUnitsEvent());
    context.read<ServicesBloc>().add(GetServingTypesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
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
                      color: widget.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                    ),
                  ),
                  if (tempUnitId != null || tempTypeId != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          tempUnitId = null;
                          tempUnitName = null;
                          tempTypeId = null;
                          tempTypeName = null;
                        });
                      },
                      child: const Text("إعادة تعيين", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const Divider(height: 25, thickness: 1),
              
              Text(
                "نوع الخدمة",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              if (state is GetServingTypesLoadingState)
                const Center(child: LinearProgressIndicator())
              else if (state is GetServingTypesSuccessState)
                Wrap(
                  spacing: 10,
                  children: state.types.map((type) {
                    final isSelected = tempTypeId == type.id;
                    return ChoiceChip(
                      label: Text(type.name == 'paid' ? 'مدفوعة' : type.name == 'unpaid' ? 'تبادلية' : 'تطوعية'),
                      selected: isSelected,
                      selectedColor: AppColors.primaryColor.withOpacity(0.25),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primaryColor
                            : (widget.isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          tempTypeId = selected ? type.id : null;
                          tempTypeName = selected ? type.name : null;
                        });
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
                  color: widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              if (state is GetPaymentUnitsLoadingState)
                const Center(child: LinearProgressIndicator())
              else if (state is GetPaymentUnitsSuccessState)
                Wrap(
                  spacing: 10,
                  children: state.units.map((unit) {
                    final isSelected = tempUnitId == unit.id;
                    return ChoiceChip(
                      label: Text(unit.name),
                      selected: isSelected,
                      selectedColor: AppColors.primaryColor.withOpacity(0.25),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primaryColor
                            : (widget.isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          tempUnitId = selected ? unit.id : null;
                          tempUnitName = selected ? unit.name : null;
                        });
                      },
                    );
                  }).toList(),
                ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    widget.onApply(tempTypeId, tempTypeName, tempUnitId, tempUnitName);
                    Navigator.pop(context);
                  },
                  child: const Text("تطبيق التصفية", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
