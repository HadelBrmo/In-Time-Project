import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/widgets/customAppBar.dart';
import '../../../../../core/widgets/customTextFormField.dart';
import '../../../../../core/widgets/buildLabel.dart';
import '../../../../core/widgets/customDrawer.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/SignUpBloc/sign up_bloc.dart';
import '../../../auth/presentation/bloc/SignUpBloc/sign up_event.dart';
import '../../../auth/presentation/pages/locationPicker/location_picker_page.dart';
import '../widgets/buildDropdownColumn.dart';
import '../widgets/build_field_column.dart';
import '../widgets/buildTypeSelector.dart';
import '../widgets/build_image_picker_placeholder.dart';

class VoluntaryServicePage extends StatefulWidget {
  const VoluntaryServicePage({super.key});

  @override
  State<VoluntaryServicePage> createState() => _VoluntaryServicePageState();
}

class _VoluntaryServicePageState extends State<VoluntaryServicePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  List<String> _userSelectedDays = [];
  XFile? _selectedImage;
  String? selectedLocationType;
  String? selectedCategory;

  final List<String> locationOptions = ["أونلاين", "أوفلاين"];
  final List<String> categoryOptions = ["تعليمية", "بيئية", "اجتماعية", "خيرية"];

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _durationController.dispose();
    _locationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: Text("انضم لنظام التطوع", style: TextStyle(fontSize: media.width * 0.045, color: Colors.white))
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(media.width * 0.04),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceTypeSelector(
                initialIndex: 1,
                onTypeChanged: (index) {
                  if (index != 1) Navigator.pop(context);
                },
              ),
              SizedBox(height: media.height * 0.025),
              buildLabel("اختر صورة للنشاط (اختياري)"),
              buildImagePickerPlaceholder(
                media: media,
                selectedImage: _selectedImage,
                onImagePicked: (image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
              ),
              SizedBox(height: media.height * 0.025),

              Row(
                children: [
                  Expanded(child: buildFieldColumn("اسم النشاط", "ادخل اسم النشاط", controller: _nameController, context: context)),
                  SizedBox(width: media.width * 0.025),
                  Expanded(
                    child: buildDropdownColumn(
                      context: context,
                      label: "نوع النشاط",
                      hint: "اختر نوع النشاط",
                      selectedValue: selectedLocationType,
                      items: locationOptions,
                      onChanged: (val) => setState(() => selectedLocationType = val),
                    ),
                  ),
                ],
              ),
              SizedBox(height: media.height * 0.02),
              buildFieldColumn(
                "أيام النشاط",
                "",
                isMultiDay: true,
                userSelectedDays: _userSelectedDays,
                onDaysChanged: (days) {
                  setState(() {
                    _userSelectedDays = days;
                  });
                }, context: context,
              ),
              SizedBox(height: media.height * 0.02),
              buildFieldColumn("وقت النشاط", "", isTimeRange: true, startTimeController: _startTimeController, endTimeController: _endTimeController, context: context),
              SizedBox(height: media.height * 0.02),

              Row(
                children: [
                  Expanded(child: buildFieldColumn("مدة تنفيذ النشاط", "ادخل مدة التنفيذ", controller: _durationController, keyboardType: TextInputType.number, context: context)),
                  SizedBox(width: media.width * 0.025),
                  Expanded(
                    child: buildDropdownColumn(
                      context: context,
                      label: "تصنيف النشاط",
                      hint: "اختر تصنيف النشاط",
                      selectedValue: selectedCategory,
                      items: categoryOptions,
                      onChanged: (val) => setState(() => selectedCategory = val),
                    ),
                  ),
                ],
              ),
              SizedBox(height: media.height * 0.02),
                buildLabel("مكان النشاط"),
                CustomTextFormField(
                  controller: _locationController,
                  hintText: "حدد مكان النشاط",
                  readOnly: true,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
                    );

                    if (result != null && result is Map && mounted) {
                      setState(() {
                        _locationController.text = result['address'];
                      });
                      context.read<SignUpBloc>().add(
                        UpdateLocationEvent(
                          result['position'],
                          result['address'],
                        ),
                      );
                    }
                  },
                  suffixIcon: const Icon(Icons.location_on, color: AppColors.primaryColor),
                ),
                SizedBox(height: media.height * 0.02),

              buildLabel("وصف النشاط"),
              CustomTextFormField(controller: _descController, hintText: "اكتب وصف للنشاط...", maxLines: 4),

              SizedBox(height: media.height * 0.04),

              Row(
                children: [
                  Expanded(child:
                  CustomButton(text: "ارسال", onPressed: (){}, color: AppColors.primaryColor,)),
                  SizedBox(width: media.width * 0.04),
                  Expanded(child: CustomButton(text: "الغاء" ,onPressed: (){}, color: AppColors.greyColor,)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}