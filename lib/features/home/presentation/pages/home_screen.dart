import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/customDrawer.dart';
import '../../../../core/widgets/customErrorView.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/buildServiceCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedPaymentUnitId;
  String? _selectedUnitName;
  int? _selectedServingTypeId;
  String? _selectedTypeName;

  int _currentSkip = 0;
  int _currentTake = 5;

  @override
  void initState() {
    super.initState();
    _triggerFetch(isRefresh: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerFetch({bool isRefresh = false}) {
    if (isRefresh) {
      _currentSkip = 0;
    }
    final query = _searchController.text.trim();
    context.read<HomeBloc>().add(
      FetchHomeServingsEvent(
        name: query.isEmpty ? null : query,
        paymentUnitId: _selectedPaymentUnitId,
        servingTypeId: _selectedServingTypeId,
        skip: _currentSkip,
        take: _currentTake,
        isRefresh: isRefresh,
      ),
    );
  }

  void _showPaginationDialog(BuildContext context, bool isDarkMode) {
    final TextEditingController countController = TextEditingController(text: _currentTake.toString());
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "تحديد عدد العناصر",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "أدخل عدد الخدمات التي ترغب في عرضها بالصفحة القادمة:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: countController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
                  decoration: InputDecoration(
                    hintText: "مثال: 5",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
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
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("إلغاء", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    _currentTake = int.parse(countController.text.trim());
                    _currentSkip = _currentSkip + _currentTake;
                  });
                  _triggerFetch(isRefresh: false);
                  Navigator.pop(dialogContext);
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
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        final List<Map<String, dynamic>> serviceTypes = [
          {'id': 1, 'name': 'مدفوعة'},
          {'id': 2, 'name': 'تبادلية'},
          {'id': 3, 'name': 'تطوعية'},
        ];

        final List<Map<String, dynamic>> units = [
          {'id': 1, 'name': 'USD'},
          {'id': 2, 'name': 'Hour'},
          {'id': 3, 'name': 'SYP'},
        ];

        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 25,
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
                      color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                    ),
                  ),
                  if (_selectedPaymentUnitId != null || _selectedServingTypeId != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedPaymentUnitId = null;
                          _selectedUnitName = null;
                          _selectedServingTypeId = null;
                          _selectedTypeName = null;
                        });
                        _triggerFetch(isRefresh: true);
                        Navigator.pop(bottomSheetContext);
                      },
                      child: const Text("إعادة تعيين الكل", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const Divider(height: 25, thickness: 1),
              Text(
                "نوع الخدمة",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: serviceTypes.map((type) {
                  final isSelected = _selectedServingTypeId == type['id'];
                  return ChoiceChip(
                    label: Text(type['name']),
                    selected: isSelected,
                    selectedColor: AppColors.primaryColor.withOpacity(0.25),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primaryColor
                          : (isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedServingTypeId = selected ? type['id'] : null;
                        _selectedTypeName = selected ? type['name'] : null;
                      });
                      _triggerFetch(isRefresh: true);
                      Navigator.pop(bottomSheetContext);
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
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: units.map((unit) {
                  final isSelected = _selectedPaymentUnitId == unit['id'];
                  return ChoiceChip(
                    label: Text(unit['name']),
                    selected: isSelected,
                    selectedColor: AppColors.primaryColor.withOpacity(0.25),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primaryColor
                          : (isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedPaymentUnitId = selected ? unit['id'] : null;
                        _selectedUnitName = selected ? unit['name'] : null;
                      });
                      _triggerFetch(isRefresh: true);
                      Navigator.pop(bottomSheetContext);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenHeight = mediaQuery.size.height;
    final double screenWidth = mediaQuery.size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: const Text("الخدمات المتاحة"),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: (_selectedPaymentUnitId != null || _selectedServingTypeId != null) ? AppColors.yellowColor : AppColors.whiteColor,
                    size: 28,
                  ),
                  onPressed: () => _showFilterBottomSheet(context, isDarkMode),
                ),
                if (_selectedPaymentUnitId != null || _selectedServingTypeId != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.yellowColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ).animate().fade(duration: 500.ms),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          if (_selectedUnitName != null || _selectedTypeName != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 5),
              child: Align(
                alignment: Alignment.topRight,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (_selectedTypeName != null)
                      Chip(
                        backgroundColor: AppColors.primaryColor.withOpacity(0.08),
                        label: Text("النوع: $_selectedTypeName", style: const TextStyle(fontSize: 12)),
                        onDeleted: () {
                          setState(() {
                            _selectedServingTypeId = null;
                            _selectedTypeName = null;
                          });
                          _triggerFetch(isRefresh: true);
                        },
                      ),
                    if (_selectedUnitName != null)
                      Chip(
                        backgroundColor: AppColors.primaryColor.withOpacity(0.08),
                        label: Text("الواحدة: $_selectedUnitName", style: const TextStyle(fontSize: 12)),
                        onDeleted: () {
                          setState(() {
                            _selectedPaymentUnitId = null;
                            _selectedUnitName = null;
                          });
                          _triggerFetch(isRefresh: true);
                        },
                      ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.015,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (query) => _triggerFetch(isRefresh: true),
              style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
              decoration: InputDecoration(
                hintText: "ابحث عن خدمة...",
                hintStyle: TextStyle(
                  color: isDarkMode ? AppColors.whiteColor.withOpacity(0.6) : AppColors.darkGreyColor,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primaryColor,
                ),
                filled: true,
                fillColor: isDarkMode
                    ? AppColors.greyColor.withOpacity(0.4)
                    : AppColors.secondaryColor.withOpacity(0.2),
                contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ).animate().slideY(begin: -0.2, duration: 400.ms).fade(),

          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadingState) {
                  return Center(child: LoadingWidget());
                } else if (state is HomeErrorState) {
                  return Center(
                    child: CustomErrorView(
                      message: state.message,
                      onRetry: () => _triggerFetch(isRefresh: true),
                    ),
                  );
                } else if (state is HomeSuccessState) {
                  if (state.servings.isEmpty) {
                    return Center(
                      child: Text(
                        "لا توجد خدمات متاحة حالياً.",
                        style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    itemCount: state.servings.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.servings.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: TextButton(
                              onPressed: () => _showPaginationDialog(context, isDarkMode),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              ),
                              child: const Text(
                                "عرض المزيد",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ).animate().fade(delay: 200.ms);
                      }

                      final serving = state.servings[index];
                      Widget cardWidget = buildServiceCard(context, serving, screenWidth, screenHeight);

                      return cardWidget
                          .animate()
                          .fade(duration: 450.ms, delay: (index * 80).ms)
                          .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad, delay: (index * 80).ms);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}