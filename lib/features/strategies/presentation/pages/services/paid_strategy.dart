import 'package:in_time/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:in_time/core/widgets/custom_button.dart';
import 'package:in_time/features/strategies/presentation/pages/services/serviceStrategy.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/mediaQuery.dart';
import '../../../../../../core/widgets/customAppBar.dart';
import '../../../../../../core/widgets/customTextFormField.dart';
import '../../../../../../core/widgets/buildLabel.dart';
import '../../../../../core/widgets/customDrawer.dart';
import '../../../../auth/presentation/pages/locationPicker/location_picker_page.dart';
import '../../../domain/entity/service_entity.dart';
import '../../../domain/entity/payment_unit_entity.dart';
import '../../bloc/service/services_bloc.dart';
import '../../bloc/service/services_event.dart';
import '../../bloc/service/services_state.dart';

import '../../widgets/services/buildDropdownColumn.dart';
import '../../widgets/services/buildTypeSelector.dart';
import '../../widgets/services/build_field_column.dart';
import '../../widgets/services/build_image_picker_placeholder.dart';

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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late ServiceStrategy _serviceStrategy;
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  XFile? _selectedImage;
  String? selectedMeetingType;
  String? selectedCategory;
  String? selectedPaymentUnit;
  List<PaymentUnitEntity> paymentUnitsFromServer = [];
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
    if (widget.isBarter) {
      _serviceStrategy = BarterServiceStrategy();
      _priceController.text = "0";
    } else if (widget.isVoluntary) {
      _serviceStrategy = VolunteerServiceStrategy();
      _priceController.text = "0";
    } else {
      _serviceStrategy = PaidServiceStrategy();
      context.read<ServicesBloc>().add(GetPaymentUnitsEvent());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _hoursController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _submitServiceForm() {
    if (_formKey.currentState!.validate()) {
      final ServiceEntity service = _serviceStrategy.prepareService(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        categoryId: selectedCategory ?? '',
        hours: _hoursController.text.trim(),
        priceOrCost: _priceController.text.trim(),
        paymentUnit: selectedPaymentUnit,
        locationAddress: _locationController.text.trim(),
        lat: locationLat,
        lng: locationLng,
        meetingType: selectedMeetingType ?? 'direct',
      );

      String currentEndpoint = '/servings/add-paid';
      if (widget.isBarter) {
        currentEndpoint = '/servings/add-paid';
      } else if (widget.isVoluntary) {
        currentEndpoint = '/servings/add-paid';
      }

      context.read<ServicesBloc>().add(
        AddServiceSubmittedEvent(
          service: service,
          image: _selectedImage,
          endpoint: currentEndpoint,
        ),
      );
    }
  }

  Widget _buildCategoryGrid(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
          ),
          child: buildLabel(context,"تصنيف الخدمة"),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 85.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryOptions.length,
            itemBuilder: (context, index) {
              final cat = categoryOptions[index];
              final isSelected = selectedCategory == cat['id'];

              final icons = {
                "1": Icons.school_outlined,
                "2": Icons.medical_services_outlined,
                "3": Icons.palette_outlined,
                "4": Icons.architecture_outlined,
              };

              return GestureDetector(
                onTap: () {
                  setState(() => selectedCategory = cat['id']);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 85.w,
                  margin: EdgeInsets.only(left: 10.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : (isDarkMode ? const Color(0xFF2C2C2C) : Colors.white.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected ? AppColors.yellowColor : Colors.grey.withOpacity(0.2),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ] : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[cat['id']] ?? Icons.category_outlined,
                        color: isSelected ? Colors.white : AppColors.primaryColor,
                        size: 24.sp,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        cat['name'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(target: isSelected ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 150.ms);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: Theme.of(context).copyWith(
        hintColor: Colors.white60,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Colors.white60),
          suffixStyle: const TextStyle(color: Colors.white),
          prefixStyle: const TextStyle(color: Colors.white),
          counterStyle: const TextStyle(color: Colors.white60),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white38),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
              _confettiController.play();
              SnackBarUtils.showSuccess(context, "تمت إضافة الخدمة بنجاح!");
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) Navigator.pop(context);
              });
            }

            if (state is AddServiceErrorState) {
              SnackBarUtils.showError(
                context,
                state.errorMessage,
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: "إعادة المحاولة",
                  textColor: Colors.white,
                  onPressed: () {
                    _submitServiceForm();
                  },
                ),
              );
            }

            if (state is GetPaymentUnitsSuccessState) {
              setState(() {
                paymentUnitsFromServer = state.units;
              });
            }

            if (state is GetPaymentUnitsErrorState) {
              SnackBarUtils.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(media.width * 0.04),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Form(
                      key: _formKey,
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
                          buildLabel(context,"اختر صورة للخدمة (اختياري)"),
                          buildImagePickerPlaceholder(
                            media: media,
                            selectedImage: _selectedImage,
                            onImagePicked: (image) => setState(() => _selectedImage = image),
                            context: context,
                          ),
                          SizedBox(height: media.height * 0.025),
                          Row(
                            children: [
                              Expanded(
                                child: buildFieldColumn(
                                  "اسم الخدمة",
                                  "ادخل اسم الخدمة",
                                  controller: _titleController,
                                  context: context,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "اسم الخدمة مطلوب";
                                    }
                                    return null;
                                  },
                                ),
                              ),
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
                              Expanded(
                                child: buildFieldColumn(
                                  "الساعات اللازمة للخدمة",
                                  "ادخل عدد الساعات",
                                  controller: _hoursController,
                                  keyboardType: TextInputType.number,
                                  context: context,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "عدد الساعات مطلوب";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: media.height * 0.02),

                          _buildCategoryGrid(isDarkMode),
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
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return "السعر مطلوب";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: media.width * 0.025),
                                Expanded(
                                  child: buildDropdownColumn(
                                    context: context,
                                    label: "وحدة الدفع (العملة)",
                                    hint: state is GetPaymentUnitsLoadingState
                                        ? "جاري التحميل..."
                                        : "اختر العملة",
                                    selectedValue: selectedPaymentUnit != null && paymentUnitsFromServer.isNotEmpty
                                        ? paymentUnitsFromServer
                                        .any((e) => e.id.toString() == selectedPaymentUnit)
                                        ? paymentUnitsFromServer.firstWhere((e) => e.id.toString() == selectedPaymentUnit).name
                                        : null
                                        : null,
                                    items: paymentUnitsFromServer.map((e) => e.name).toList(),
                                    onChanged: (val) {
                                      final selected = paymentUnitsFromServer.firstWhere((e) => e.name == val);
                                      setState(() => selectedPaymentUnit = selected.id.toString());
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: media.height * 0.02),
                          ],

                          buildLabel(context,"مكان الخدمة"),
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
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "يرجى تحديد موقع الخدمة";
                              }
                              return null;
                            },
                            suffixIcon: const Icon(Icons.location_on, color: AppColors.primaryColor),
                          ),
                          SizedBox(height: media.height * 0.02),

                          buildLabel(context,"وصف الخدمة"),
                          CustomTextFormField(
                            controller: _descController,
                            hintText: "اكتب وصفاً دقيقاً للخدمة هنا...",
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "وصف الخدمة مطلوب";
                              }
                              if (value.trim().length < 10) {
                                return "يجب أن يكون الوصف 10 أحرف على الأقل";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: media.height * 0.04),

                          Row(
                            children: [
                              Expanded(
                                  child: CustomButton(
                                    text: "إرسال الخدمة",
                                    onPressed: state is AddServiceLoadingState ? () {} : _submitServiceForm,
                                    color: AppColors.primaryColor,
                                  )
                              ),
                              SizedBox(width: media.width * 0.04),
                              Expanded(
                                child: CustomButton(
                                  text: "إلغاء",
                                  onPressed: () => Navigator.pop(context),
                                  color: isDarkMode ? const Color(0xFF3A3A3A) : AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [AppColors.primaryColor, AppColors.yellowColor, Colors.white, Colors.green],
                    gravity: 0.25,
                  ),
                ),

                if (state is AddServiceLoadingState)
                  Container(
                    color: Colors.black.withOpacity(0.15),
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
      ),
    );
  }
}