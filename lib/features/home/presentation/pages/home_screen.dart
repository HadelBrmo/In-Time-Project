import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/customDrawer.dart';
import '../../../../core/widgets/customErrorView.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/global_particles_wrapper.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/voice_input_button.dart';
import '../../../auth/presentation/pages/locationPicker/location_picker_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_widget/buildServiceCard.dart';
import '../widgets/home_widget/showFilterBottomSheet.dart';
import '../widgets/home_widget/showPaginationDialog.dart';

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

  void _resetAndFetchAll() {
    setState(() {
      _searchController.clear();
      _selectedPaymentUnitId = null;
      _selectedUnitName = null;
      _selectedServingTypeId = null;
      _selectedTypeName = null;
      _currentSkip = 0;
    });
    _triggerFetch(isRefresh: true);
  }

  void _openFilterBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => FilterBottomSheet(
        isDarkMode: isDarkMode,
        selectedPaymentUnitId: _selectedPaymentUnitId,
        selectedServingTypeId: _selectedServingTypeId,
        onApply: (typeId, typeName, unitId, unitName) {
          setState(() {
            if (typeId != _selectedServingTypeId || typeName != null) {
              _selectedServingTypeId = typeId;
              _selectedTypeName = typeName;
            }
            if (unitId != _selectedPaymentUnitId || unitName != null) {
              _selectedPaymentUnitId = unitId;
              _selectedUnitName = unitName;
            }
          });
          _triggerFetch(isRefresh: true);
        },
      ),
    );
  }

  void _openPaginationDialog(BuildContext context, bool isDarkMode) {
    DialogUtils.showCustomDialog(
      context: context,
      builder: PaginationDialog(
        isDarkMode: isDarkMode,
        currentTake: _currentTake,
        onConfirm: (newTake) {
          setState(() {
            _currentSkip = _currentSkip + _currentTake;
            _currentTake = newTake;
          });
          _triggerFetch(isRefresh: false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenHeight = mediaQuery.size.height;
    final double screenWidth = mediaQuery.size.width;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: Text(
            context.tr('available_services'),
            style: theme.textTheme.titleSmall,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.person,
                color: AppColors.whiteColor,
                size: 24,
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.profilePage);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.near_me_outlined,
                color: AppColors.whiteColor,
                size: 26,
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LocationPickerPage()),
                );

                if (result != null && result is Map) {
                  final LatLng position = result['position'];
                  final String address = result['address'];

                  SnackBarUtils.showSuccess(context, "${context.tr('searching_near')} $address");

                  context.read<HomeBloc>().add(
                    FetchNearbyServingsEvent(
                      lat: position.latitude,
                      lng: position.longitude,
                      skip: 0,
                      take: 20,
                      isRefresh: true,
                    ),
                  );
                }
              },
            ),
          ],
        ).animate().fade(duration: 500.ms),
      ),
      drawer: ResponsiveLayout.isMobile(context) ? CustomDrawer() : null,
      body: GlobalParticlesWrapper(
        child: Column(
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
                          label: Text("${context.tr('type_with_value')} $_selectedTypeName", style: const TextStyle(fontSize: 12)),
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
                          label: Text("${context.tr('unit_with_value')} $_selectedUnitName", style: const TextStyle(fontSize: 12)),
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

            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.019,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode ? AppColors.primaryColor.withOpacity(0.8) : AppColors.primaryColor.withOpacity(0.6),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (query) => _triggerFetch(isRefresh: true),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                            ),
                            decoration: InputDecoration(
                              hintText: context.tr('search_for_service'),
                              hintStyle: theme.textTheme.titleMedium?.copyWith(
                                color: isDarkMode ? AppColors.whiteColor.withOpacity(0.6) : AppColors.darkGreyColor,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.primaryColor,
                              ),

                              suffixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: VoiceInputButton(
                                  controller: _searchController,
                                  onSpeechComplete: () {
                                    _searchController.text = _searchController.text.trim();

                                    _triggerFetch(isRefresh: true);
                                  },
                                ),
                              ),

                              filled: true,
                              fillColor: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
                              contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.whiteColor.withOpacity(0.6), width: 1.8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.6), width: 1.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _openFilterBottomSheet(context, isDarkMode),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (_selectedPaymentUnitId != null || _selectedServingTypeId != null)
                                  ? AppColors.yellowColor
                                  : AppColors.whiteColor.withOpacity(0.6),
                              width: 1.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode ? AppColors.primaryColor.withOpacity(0.8) : AppColors.primaryColor.withOpacity(0.6),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.filter_list,
                                color: (_selectedPaymentUnitId != null || _selectedServingTypeId != null)
                                    ? AppColors.yellowColor
                                    : AppColors.primaryColor,
                                size: 26,
                              ),
                              if (_selectedPaymentUnitId != null || _selectedServingTypeId != null)
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.yellowColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoadingState) {
                    return const Center(child: LoadingWidget());
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
                          context.tr('no_services_available'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                          ),
                        ),
                      );
                    }
                    
                    return ResponsiveLayout(
                      mobileBody: _buildServiceList(state.servings, theme, isDarkMode, screenWidth, screenHeight, 1),
                      tabletBody: _buildServiceList(state.servings, theme, isDarkMode, screenWidth, screenHeight, 2),
                      desktopBody: _buildServiceList(state.servings, theme, isDarkMode, screenWidth, screenHeight, 3),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList(List servings, ThemeData theme, bool isDarkMode, double width, double height, int crossAxisCount) {
    if (crossAxisCount == 1) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        itemCount: servings.length + 1,
        itemBuilder: (context, index) {
          if (index == servings.length) {
            return _buildFooter(theme, isDarkMode);
          }
          final serving = servings[index];
          return buildServiceCard(context, serving, width, height)
              .animate()
              .fade(duration: 450.ms, delay: (index * 80).ms)
              .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad, delay: (index * 80).ms);
        },
      );
    } else {
      return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 140, // Increased slightly for grid
        ),
        itemCount: servings.length + 1,
        itemBuilder: (context, index) {
          if (index == servings.length) {
            return _buildFooter(theme, isDarkMode);
          }
          final serving = servings[index];
          // For grid, we might want to pass a different width to buildServiceCard if it uses hardcoded fractions
          // But buildServiceCard uses width * 0.25 etc. which is fine for list. 
          // For grid, width passed should be the column width ideally.
          final columnWidth = (width - (crossAxisCount + 1) * 16) / crossAxisCount;
          return buildServiceCard(context, serving, columnWidth, height)
              .animate()
              .fade(duration: 450.ms, delay: (index * 80).ms)
              .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad, delay: (index * 80).ms);
        },
      );
    }
  }

  Widget _buildFooter(ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => _openPaginationDialog(context, isDarkMode),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            ),
            child: Text(
              context.tr('view_more'),
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: _resetAndFetchAll,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            ),
            child: Text(
              context.tr('view_all'),
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDarkMode ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 200.ms);
  }
}