import 'package:in_time/core/constants/app_strings.dart';
import 'package:in_time/core/localization/app_localizations.dart';
import 'package:in_time/core/utils/auth_utils.dart';
import 'package:in_time/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:in_time/core/widgets/custom_button.dart';
import 'package:in_time/features/servings/presentation/pages/services/serviceStrategy.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/mediaQuery.dart';
import '../../../../../../core/widgets/customAppBar.dart';
import '../../../../../../core/widgets/customTextFormField.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../core/widgets/buildLabel.dart';
import '../../../../../core/widgets/customDrawer.dart';
import '../../../../auth/presentation/pages/locationPicker/location_picker_page.dart';
import '../../../domain/entity/service_entity.dart';
import '../../../domain/entity/category_entity.dart';
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
  List<CategoryEntity> categoriesFromServer = [];
  final List<String> meetingOptions = ["online", "direct"];
  
  double? locationLat;
  double? locationLng;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ServicesBloc>();
    
    if (widget.isBarter) {
      _serviceStrategy = BarterServiceStrategy();
      _priceController.text = "0";
    } else if (widget.isVoluntary) {
      _serviceStrategy = VolunteerServiceStrategy();
      _priceController.text = "0";
    } else {
      _serviceStrategy = PaidServiceStrategy();
      if (bloc.state is GetPaymentUnitsSuccessState) {
        paymentUnitsFromServer = (bloc.state as GetPaymentUnitsSuccessState).units;
      }
      bloc.add(GetPaymentUnitsEvent());
    }

    if (bloc.state is GetCategoriesSuccessState) {
      categoriesFromServer = (bloc.state as GetCategoriesSuccessState).categories;
    }
    bloc.add(GetCategoriesEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    if (!AuthUtils.checkAuth(context)) return;

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

      String currentEndpoint = ApiStringConstants.addPaidServiceUrl;
      if (widget.isBarter) {
        currentEndpoint = ApiStringConstants.addBarterServiceUrl;
      } else if (widget.isVoluntary) {
        currentEndpoint = ApiStringConstants.addVoluntaryServiceUrl;
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

  Widget _buildCategoryGrid(bool isDarkMode, ServicesState state) {
    final theme = Theme.of(context);
    
    if (state is GetCategoriesLoadingState && categoriesFromServer.isEmpty) {
      return const Center(child: LoadingWidget(size: 30));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(context, context.tr('service_category')),
        SizedBox(height: 8.h),
        SizedBox(
          height: 85.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoriesFromServer.length,
            itemBuilder: (context, index) {
              final cat = categoriesFromServer[index];
              final isSelected = selectedCategory == cat.id.toString();

              final icons = {
                "Home Services": Icons.home_outlined,
                "Education & Tutoring": Icons.school_outlined,
                "Tech Support": Icons.computer_outlined,
                "Health & Wellness": Icons.favorite_border_outlined,
                "Transport": Icons.directions_bus_outlined,
              };

              return GestureDetector(
                onTap: () {
                  setState(() => selectedCategory = cat.id.toString());
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 100.w,
                  margin: EdgeInsets.only(left: 10.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : (isDarkMode ? const Color(0xFF2C2C2C) : AppColors.whiteColor.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected ? AppColors.yellowColor : AppColors.greyColor.withOpacity(0.2),
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
                        icons[cat.name] ?? Icons.category_outlined,
                        color: isSelected ? AppColors.whiteColor : AppColors.primaryColor,
                        size: 24.sp,
                      ),
                      SizedBox(height: 4.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          cat.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 10.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? AppColors.whiteColor
                                : (isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
                          ),
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Theme(
      data: theme.copyWith(
        hintColor: AppColors.whiteColor.withOpacity(0.6),
        textTheme: theme.textTheme.apply(
          bodyColor: AppColors.whiteColor,
          displayColor: AppColors.whiteColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: AppColors.whiteColor),
          hintStyle: TextStyle(color: AppColors.whiteColor.withOpacity(0.6)),
          suffixStyle: const TextStyle(color: AppColors.whiteColor),
          prefixStyle: const TextStyle(color: AppColors.whiteColor),
          counterStyle: TextStyle(color: AppColors.whiteColor.withOpacity(0.6)),
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
                    ? context.tr('join_voluntary_services')
                    : widget.isBarter
                    ? context.tr('join_barter_services')
                    : context.tr('join_paid_services'),
                style: theme.textTheme.titleSmall?.copyWith(fontSize: 18.sp, color: AppColors.whiteColor)
            )
        ),
        drawer: const CustomDrawer(),
        body: BlocConsumer<ServicesBloc, ServicesState>(
          listener: (context, state) {
            if (state is AddServiceSuccessState) {
              _confettiController.play();
              SnackBarUtils.showSuccess(context, context.tr('service_add_success'));
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
                  label: context.tr('retry'),
                  textColor: AppColors.whiteColor,
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

            if (state is GetCategoriesSuccessState) {
              setState(() {
                categoriesFromServer = state.categories;
              });
            }

            if (state is GetCategoriesErrorState) {
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
                          buildLabel(context, context.tr('service_image_optional')),
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
                                  context.tr('service_name'),
                                  context.tr('enter_service_name'),
                                  controller: _titleController,
                                  context: context,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return context.tr('service_name_required');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: media.width * 0.025),
                              Expanded(
                                child: buildDropdownColumn(
                                  context: context,
                                  label: context.tr('service_type'),
                                  hint: context.tr('select_service_type'),
                                  selectedValue: selectedMeetingType,
                                  items: meetingOptions.map((e) => e == 'online' ? context.tr('online') : context.tr('direct')).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                       selectedMeetingType = (val == context.tr('online')) ? 'online' : 'direct';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: media.height * 0.02),

                          Row(
                            children: [
                              Expanded(
                                child: buildFieldColumn(
                                  context.tr('hours_needed'),
                                  context.tr('enter_hours'),
                                  controller: _hoursController,
                                  keyboardType: TextInputType.number,
                                  context: context,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return context.tr('hours_required');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: media.height * 0.02),

                          _buildCategoryGrid(isDarkMode, state),
                          SizedBox(height: media.height * 0.02),

                          if (!widget.isBarter && !widget.isVoluntary) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: buildFieldColumn(
                                    context.tr('service_price'),
                                    context.tr('set_price'),
                                    controller: _priceController,
                                    keyboardType: TextInputType.number,
                                    context: context,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return context.tr('price_required');
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: media.width * 0.025),
                                Expanded(
                                  child: buildDropdownColumn(
                                    context: context,
                                    label: context.tr('payment_unit'),
                                    hint: state is GetPaymentUnitsLoadingState
                                        ? context.tr('loading')
                                        : context.tr('select_currency'),
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

                          buildLabel(context, context.tr('service_location')),
                          CustomTextFormField(
                            controller: _locationController,
                            hintText: context.tr('select_location_map'),
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
                                return context.tr('location_required');
                              }
                              return null;
                            },
                            suffixIcon: const Icon(Icons.location_on, color: AppColors.primaryColor),
                          ),
                          SizedBox(height: media.height * 0.02),

                          buildLabel(context, context.tr('service_description')),
                          CustomTextFormField(
                            controller: _descController,
                            hintText: context.tr('enter_description'),
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return context.tr('desc_required');
                              }
                              if (value.trim().length < 10) {
                                return context.tr('desc_min_length');
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: media.height * 0.04),

                          Row(
                            children: [
                              Expanded(
                                  child: CustomButton(
                                    text: context.tr('submit_service'),
                                    onPressed: state is AddServiceLoadingState ? () {} : _submitServiceForm,
                                    color: AppColors.primaryColor,
                                  )
                              ),
                              SizedBox(width: media.width * 0.04),
                              Expanded(
                                child: CustomButton(
                                  text: context.tr('cancel'),
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
                    colors: const [AppColors.primaryColor, AppColors.yellowColor, AppColors.whiteColor, Colors.green],
                    gravity: 0.25,
                  ),
                ),

                if (state is AddServiceLoadingState)
                  Container(
                    color: Colors.black.withOpacity(0.15),
                    child: const LoadingWidget(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}