import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_time/core/widgets/custom_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/widgets/customAppBar.dart';
import '../../../../../core/widgets/customTextFormField.dart';
import '../../../../../core/widgets/buildLabel.dart';
import '../../../../core/widgets/customDrawer.dart';
import '../../../../core/widgets/customErrorView.dart';
import '../../../auth/presentation/pages/locationPicker/location_picker_page.dart';
import '../../domain/entity/service_entity.dart';
import '../bloc/services_bloc.dart';
import '../bloc/services_event.dart';
import '../bloc/services_state.dart';
import '../widgets/buildDropdownColumn.dart';
import '../widgets/build_field_column.dart';
import '../widgets/buildTypeSelector.dart';
import '../widgets/build_image_picker_placeholder.dart';

class PaidServicePage extends StatefulWidget {
  final bool isBarter;
  final bool isVoluntary;

  const PaidServicePage({
    super.key,
    this.isBarter = false,
    this.isVoluntary = false,
  });

  @override
  State<PaidServicePage> createState() => _PaidServicePageState();
}

class _PaidServicePageState extends State<PaidServicePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  XFile? _selectedImage;
  String? selectedMeetingType;
  String? selectedCategory;
  String? selectedPaymentUnit;

  final List<Map<String, dynamic>> paymentUnitsMock = [
    {"id": "1", "name": "ليرة سورية (SYP)"},
    {"id": "2", "name": "دولار أمريكي (USD)"}
  ];

  final List<String> meetingOptions = ["online", "direct"];
  final List<Map<String, dynamic>> categoryOptions = [
    {"id": "1", "name": "تعليمية"},
    {"id": "2", "name": "طبية"},
    {"id": "3", "name": "فنية"},
    {"id": "4", "name": "هندسية"}
  ];

  double? locationLat;
  double? locationLng;

  @override
  void initState() {
    super.initState();
    if (widget.isBarter || widget.isVoluntary) {
      _priceController.text = "0";
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _hoursController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitServiceForm() {
    final ServiceEntity service = ServiceEntity(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      categoryId: selectedCategory ?? '',
      costAmount: _hoursController.text.trim(),
      unitId: widget.isVoluntary ? "1" : selectedPaymentUnit,
      locationAddress: _locationController.text.trim(),
      locationLat: locationLat ?? 33.5138,
      locationLng: locationLng ?? 36.2765,
      meetingType: selectedMeetingType ?? 'direct',
      price: _priceController.text.trim(),
    );

    context.read<ServicesBloc>().add(
      AddServiceSubmittedEvent(
        service: service,
        image: _selectedImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: Text(
              widget.isVoluntary
                  ? "انضم لنظام الخدمات التطوعية"
                  : widget.isBarter
                  ? "انضم لنظام الخدمات التبادلية"
                  : "انضم لنظام الخدمات المدفوعة",
              style: TextStyle(fontSize: 18.sp, color: Colors.white)
          )
      ),
      drawer: const CustomDrawer(),
      body: BlocConsumer<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is AddServiceSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تمت إضافة الخدمة بنجاح!"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is AddServiceErrorState) {
            return CustomErrorView(
              message: state.errorMessage,
              onRetry: () {
                _submitServiceForm();
              },
            );
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(media.width * 0.04),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ServiceTypeSelector(
                        initialIndex: widget.isBarter ? 0 : widget.isVoluntary ? 1 : 2,
                        onTypeChanged: (index) {
                          int currentIndex = widget.isBarter ? 0 : widget.isVoluntary ? 1 : 2;
                          if (index == currentIndex) return;

                          if (index == 0) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const PaidServicePage(isBarter: true, isVoluntary: false)),
                            );
                          } else if (index == 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const PaidServicePage(isBarter: false, isVoluntary: true)),
                            );
                          } else if (index == 2) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const PaidServicePage(isBarter: false, isVoluntary: false)),
                            );
                          }
                        },
                      ),
                      SizedBox(height: media.height * 0.025),

                      buildLabel("اختر صورة للخدمة (اختياري)"),
                      buildImagePickerPlaceholder(
                        media: media,
                        selectedImage: _selectedImage,
                        onImagePicked: (image) => setState(() => _selectedImage = image),
                      ),
                      SizedBox(height: media.height * 0.025),

                      Row(
                        children: [
                          Expanded(child: buildFieldColumn("اسم الخدمة", "ادخل اسم الخدمة", controller: _titleController, context: context)),
                          SizedBox(width: media.width * 0.025),
                          Expanded(
                            child: buildDropdownColumn(
                              context: context,
                              label: "نوع الخدمة",
                              hint: "اختر نوع الخدمة",
                              selectedValue: selectedMeetingType,
                              items: meetingOptions,
                              onChanged: (val) => setState(() => selectedMeetingType = val),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.height * 0.02),

                      Row(
                        children: [
                          Expanded(child: buildFieldColumn("الساعات اللازمة للخدمة", "ادخل عدد الساعات",
                              controller: _hoursController, keyboardType: TextInputType.number, context: context)),
                          SizedBox(width: media.width * 0.025),
                          Expanded(
                            child: buildDropdownColumn(
                              context: context,
                              label: "تصنيف الخدمة",
                              hint: "اختر التصنيف",
                              selectedValue: selectedCategory != null
                                  ? categoryOptions.firstWhere((e) => e['id'] == selectedCategory)['name']
                                  : null,
                              items: categoryOptions.map((e) => e['name'].toString()).toList(),
                              onChanged: (val) {
                                final selected = categoryOptions.firstWhere((element) => element['name'] == val);
                                setState(() => selectedCategory = selected['id']);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.height * 0.02),

                      if (!widget.isBarter && !widget.isVoluntary) ...[
                        Row(
                          children: [
                            Expanded(
                              child: buildFieldColumn(
                                "سعر الخدمة",
                                "حدد السعر",
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                context: context,
                              ),
                            ),
                            SizedBox(width: media.width * 0.025),
                            Expanded(
                              child: buildDropdownColumn(
                                context: context,
                                label: "وحدة الدفع (العملة)",
                                hint: "اختر العملة",
                                selectedValue: selectedPaymentUnit != null
                                    ? paymentUnitsMock.firstWhere((e) => e['id'] == selectedPaymentUnit)['name']
                                    : null,
                                items: paymentUnitsMock.map((e) => e['name'].toString()).toList(),
                                onChanged: (val) {
                                  final selected = paymentUnitsMock.firstWhere((e) => e['name'] == val);
                                  setState(() => selectedPaymentUnit = selected['id']);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: media.height * 0.02),
                      ],

                      buildLabel("مكان الخدمة"),
                      CustomTextFormField(
                        controller: _locationController,
                        hintText: "حدد مكان الخدمة من الخريطة",
                        readOnly: true,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LocationPickerPage()),
                          );

                          if (result != null && result is Map && mounted) {
                            setState(() {
                              _locationController.text = result['address'];
                              locationLat = result['position'].latitude;
                              locationLng = result['position'].longitude;
                            });
                          }
                        },
                        suffixIcon: const Icon(Icons.location_on, color: AppColors.primaryColor),
                      ),
                      SizedBox(height: media.height * 0.02),

                      buildLabel("وصف الخدمة"),
                      CustomTextFormField(controller: _descController, hintText: "اكتب وصفاً دقيقاً للخدمة هنا...", maxLines: 4),

                      SizedBox(height: media.height * 0.04),

                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "إرسال الخدمة",
                              onPressed: state is AddServiceLoadingState ? () {} : _submitServiceForm,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(width: media.width * 0.04),
                          Expanded(
                            child: CustomButton(
                              text: "إلغاء",
                              onPressed: () => Navigator.pop(context),
                              color: AppColors.greyColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (state is AddServiceLoadingState)
                Container(
                  color: Colors.black.withValues(alpha: 0.25),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}