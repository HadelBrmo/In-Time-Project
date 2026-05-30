import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ComplaintTypeDropdown
    extends StatelessWidget {

  final String? selectedType;

  final Function(String?)
      onChanged;

  const ComplaintTypeDropdown({

    super.key,

    required this.selectedType,

    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    final complaintTypes = [

      'مشكلة تقنية',

      'تأخير بالخدمة',

      'إزعاج',

      'أخرى',
    ];

    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedType,

      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color:AppColors.primaryColor,
        size: 30,
      ),

      decoration: InputDecoration(
        alignLabelWithHint: true,
        hintText:
            'اختر نوع الشكوى',

        hintStyle: TextStyle(

          color: AppColors.greyColor,

          fontSize: 18,
        ),

        filled: true,

        fillColor: AppColors.whiteColor,

        contentPadding:
            const EdgeInsets.symmetric(

          horizontal: 24,

          vertical: 22,
        ),

        enabledBorder:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(30),

          borderSide: BorderSide(
            color: AppColors.greyColor,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(30),

          borderSide: const BorderSide(

            color:
                AppColors.primaryColor,

            width: 1.5,
          ),
        ),
      ),

      items: complaintTypes.map(

        (item) {

          return DropdownMenuItem(

            value: item,
             child: Align(alignment: Alignment.centerRight,
            child: Text(item , textAlign: TextAlign.right,),),
          );
        },
      ).toList(),

      onChanged: onChanged,
    );
  }}