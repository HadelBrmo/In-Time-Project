import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/customAppBar.dart';
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

  @override
  void initState() {
    super.initState();
    _triggerFetch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerFetch() {
    final query = _searchController.text.trim();
    context.read<HomeBloc>().add(
      FetchHomeServingsEvent(
        name: query.isEmpty ? null : query,
        paymentUnitId: _selectedPaymentUnitId,
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        final List<Map<String, dynamic>> units = [
          {'id': 1, 'name': 'USD'},
          {'id': 2, 'name': 'Hour'},
          {'id': 3, 'name': 'SYP'},
        ];

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "فلترة حسب واحدة الدفع",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                    ),
                  ),
                  if (_selectedPaymentUnitId != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedPaymentUnitId = null;
                          _selectedUnitName = null;
                        });
                        _triggerFetch();
                        Navigator.pop(bottomSheetContext);
                      },
                      child: const Text("إعادة تعيين", style: TextStyle(color: Colors.red)),
                    ),
                ],
              ),
              const SizedBox(height: 15),
              ...units.map((unit) {
                final isSelected = _selectedPaymentUnitId == unit['id'];
                return ListTile(
                  title: Text(
                    unit['name'],
                    style: TextStyle(color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primaryColor)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedPaymentUnitId = unit['id'];
                      _selectedUnitName = unit['name'];
                    });
                    _triggerFetch();
                    Navigator.pop(bottomSheetContext);
                  },
                );
              }).toList(),
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
      appBar: CustomAppBar(
        title: const Text("الخدمات المتاحة"),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: _selectedPaymentUnitId != null ? AppColors.yellowColor : AppColors.whiteColor,
                  size: 28,
                ),
                onPressed: () => _showFilterBottomSheet(context, isDarkMode),
              ),
              if (_selectedPaymentUnitId != null)
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
      ),
      body: Column(
        children: [
          if (_selectedUnitName != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 5),
              child: Row(
                children: [
                  Chip(
                    label: Text("واحدة: $_selectedUnitName"),
                    onDeleted: () {
                      setState(() {
                        _selectedPaymentUnitId = null;
                        _selectedUnitName = null;
                      });
                      _triggerFetch();
                    },
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.015,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (query) => _triggerFetch(),
              style: const TextStyle(color: AppColors.blackColor),
              decoration: InputDecoration(
                hintText: "ابحث عن خدمة...",
                hintStyle: TextStyle(
                  color: isDarkMode ? AppColors.whiteColor : AppColors.darkGreyColor,
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
          ),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadingState) {
                  return Center(child: LoadingWidget());
                } else if (state is HomeErrorState) {
                  return Center(
                    child: CustomErrorView(
                      message: state.message,
                      onRetry: () => _triggerFetch(),
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
                    itemCount: state.servings.length,
                    itemBuilder: (context, index) {
                      final serving = state.servings[index];
                      return buildServiceCard(context, serving, screenWidth, screenHeight);
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