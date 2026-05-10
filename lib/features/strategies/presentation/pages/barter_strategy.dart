import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_time/core/widgets/customAppBar.dart';
import 'package:in_time/features/strategies/presentation/pages/paid_strategy.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/widgets/customTextFormField.dart';
import '../../../../../core/widgets/buildLabel.dart';
import '../../../../core/widgets/customDrawer.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/SignUpBloc/sign up_bloc.dart';
import '../../../auth/presentation/bloc/SignUpBloc/sign up_event.dart';
import '../../../auth/presentation/pages/locationPicker/location_picker_page.dart';
import '../widgets/buildDropdownColumn.dart';
import '../widgets/build_field_column.dart';
import '../widgets/build_image_picker_placeholder.dart';
import '../widgets/buildTypeSelector.dart';

class BarterStrategyPage extends StatefulWidget {
  const BarterStrategyPage({super.key});

  @override
  State<BarterStrategyPage> createState() => _BarterStrategyPageState();
}

class _BarterStrategyPageState extends State<BarterStrategyPage> {
  int selectedType = 0;
  List<String> _userSelectedDays = [];
  XFile? _selectedImage;
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? selectedServiceLocation;
  String? selectedServiceCategory;
  final List<String> categoryOptions = ["تعليمية", "'طبية'","فنية","هندسية"];
  final List<String> locationOptions = ["اوفلاين", "اونلاين"];
  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    _durationController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: Text("انضم لنظام خدمة مقابل خدمة")),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(media.width * 0.04),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceTypeSelector(
                initialIndex: 0,
                onTypeChanged: (index) {
                  if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaidServicePage()),
                    );
                  } else {
                    setState(() => selectedType = index);
                  }
                },
              ),
              SizedBox(height: media.height * 0.025),
              buildLabel("اختر صورة للخدمة (اختياري)"),
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
                  Expanded(
                    child: buildFieldColumn(
                      "اسم الخدمة",
                      "ادخل اسم الخدمة",
                      controller: TextEditingController(), context: context,
                    ),
                  ),
                  SizedBox(width: media.width * 0.025),
                  Expanded(
                    child: buildDropdownColumn(
                      context: context,
                      label: "نوع الخدمة",
                      hint: "اختر نوع الخدمة",
                      selectedValue: selectedServiceLocation,
                      items: locationOptions,
                      onChanged: (val) {
                        setState(() {
                          selectedServiceLocation = val;
                        });
                        print("تم اختيار: $val");
                      },
                    ),
                  ),                ],
              ),

              SizedBox(height: media.height * 0.02),
              buildFieldColumn(
                "أيام الخدمة",
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
              buildFieldColumn(
                    "توقيت الخدمة المتاحة",
                    "",
                    isTimeRange: true,
                    startTimeController: _startTimeController,
                    endTimeController: _endTimeController, context: context,
                ),

              SizedBox(height: media.height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: buildFieldColumn(
                         keyboardType: TextInputType.numberWithOptions(),
                        "الساعات اللازمة للخدمة",
                        "ادخل الساعات اللازمة للخدمة",
                        controller: _durationController, context: context,
                    ),
                  ),
                  SizedBox(width: media.width * 0.025),
                  Expanded(
                    child: buildDropdownColumn(
                      context: context,
                      label: "تصنيف الخدمة",
                      hint: "اختر تصنيف الخدمة",
                      selectedValue: selectedServiceCategory,
                      items: categoryOptions,
                      onChanged: (val) {
                        setState(() {
                          selectedServiceCategory = val;
                        });
                        print("تم اختيار: $val");
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: media.height * 0.02),
              buildLabel("مكان الخدمة"),
              CustomTextFormField(
                controller: _locationController,
                hintText: "حدد مكان الخدمة",
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
              buildLabel("وصف الخدمة"),
              CustomTextFormField(hintText: "اكتب وصف للخدمة...", maxLines: 4),

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