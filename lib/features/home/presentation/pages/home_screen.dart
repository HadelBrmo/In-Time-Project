import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_drawer.dart';
import '../../../../core/widgets/custom_error_view.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/global_particles_wrapper.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/voice_input_button.dart';
import '../../../auth/presentation/pages/location_picker/location_picker_page.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../notifications/presentation/bloc/notifications_state.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_widget/build_service_card.dart';
import '../widgets/home_widget/show_filter_bottom_sheet.dart';

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
  int _currentTake = 6;
  bool _isNearbyMode = false;
  LatLng? _lastNearbyLocation;
  bool _isLoadingMore = false;

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
      setState(() => _isLoadingMore = false);
      
      // Only fetch proposed services if we are refreshing the main feed (no active search query)
      // or if it's the initial load.
      if (_searchController.text.trim().isEmpty && !_isNearbyMode) {
        context.read<HomeBloc>().add(const FetchProposedServingsEvent(skip: 0, take: 10));
      }
    } else {
      setState(() => _isLoadingMore = true);
    }

    if (_isNearbyMode && _lastNearbyLocation != null) {
      context.read<HomeBloc>().add(
        FetchNearbyServingsEvent(
          lat: _lastNearbyLocation!.latitude,
          lng: _lastNearbyLocation!.longitude,
          skip: _currentSkip,
          take: _currentTake,
          isRefresh: isRefresh,
        ),
      );
    } else {
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
  }

  void _resetAndFetchAll() {
    setState(() {
      _searchController.clear();
      _selectedPaymentUnitId = null;
      _selectedUnitName = null;
      _selectedServingTypeId = null;
      _selectedTypeName = null;
      _currentSkip = 0;
      _isNearbyMode = false;
      _lastNearbyLocation = null;
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

  void _loadMore() {
    setState(() {
      _currentSkip = _currentSkip + _currentTake;
    });
    _triggerFetch(isRefresh: false);
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
            BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.whiteColor,
                        size: 26,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.notificationsPage);
                      },
                    ),
                    if (state.unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${state.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
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

                  setState(() {
                    _isNearbyMode = true;
                    _lastNearbyLocation = position;
                    _currentSkip = 0;
                  });

                  context.read<HomeBloc>().add(
                    FetchNearbyServingsEvent(
                      lat: position.latitude,
                      lng: position.longitude,
                      skip: 0,
                      take: _currentTake,
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
              child: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is HomeSuccessState || state is HomeErrorState) {
                    setState(() => _isLoadingMore = false);
                  }
                },
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
                        mobileBody: _buildServiceList(state.servings, state.proposedServings, theme, isDarkMode, screenWidth, screenHeight, 1, state.hasReachedMax),
                        tabletBody: _buildServiceList(state.servings, state.proposedServings, theme, isDarkMode, screenWidth, screenHeight, 2, state.hasReachedMax),
                        desktopBody: _buildServiceList(state.servings, state.proposedServings, theme, isDarkMode, screenWidth, screenHeight, 3, state.hasReachedMax),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList(List servings, List proposedServings, ThemeData theme, bool isDarkMode, double width, double height, int crossAxisCount, bool hasReachedMax) {
    if (crossAxisCount == 1) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        itemCount: servings.length + (proposedServings.isNotEmpty ? 1 : 0) + (hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index < servings.length) {
            final serving = servings[index];
            return buildServiceCard(context, serving, width, height)
                .animate()
                .fade(duration: 450.ms)
                .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad);
          }

          final remainingIndex = index - servings.length;

          if (proposedServings.isNotEmpty && remainingIndex == 0) {
            return _buildProposedServicesSection(proposedServings, width, height, isDarkMode, theme);
          }

          final footerIndex = proposedServings.isNotEmpty ? 1 : 0;
          if (remainingIndex == footerIndex) {
            return _buildFooter(theme, isDarkMode);
          }

          return const SizedBox.shrink();
        },
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 140.h,
              ),
              itemCount: servings.length + (hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index == servings.length) {
                  return _buildFooter(theme, isDarkMode);
                }
                final serving = servings[index];
                final columnWidth = (width - (crossAxisCount + 1) * 16) / crossAxisCount;
                return buildServiceCard(context, serving, columnWidth, height)
                    .animate()
                    .fade(duration: 450.ms)
                    .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad);
              },
            ),
          ),
          if (proposedServings.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: _buildProposedServicesSection(proposedServings, width, height, isDarkMode, theme),
            ),
        ],
      );
    }
  }

  Widget _buildProposedServicesSection(List proposedServings, double width, double height, bool isDarkMode, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: AppColors.yellowColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                context.tr('proposed_services'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 210.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: proposedServings.length,
            padding: EdgeInsets.zero,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              final serving = proposedServings[index];
              return Container(
                width: width * 0.45,
                margin: EdgeInsets.only(left: (context.isArabic ? 0 : 12.w), right: (context.isArabic ? 12.w : 0)),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.serviceDetailsPage, arguments: serving.id),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                        child: Stack(
                          children: [
                            Container(
                              height: 100.h,
                              width: double.infinity,
                              color: AppColors.primaryColor.withOpacity(0.05),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: CustomImageView(
                                  imageUrl: serving.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  serving.servingTypeName ?? '',
                                  style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serving.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(Icons.timer_outlined, color: AppColors.primaryColor, size: 12.sp),
                                SizedBox(width: 4.w),
                                Text(
                                  "${serving.costAmount} ${serving.unitName ?? ''}",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, color: AppColors.greyColor, size: 12.sp),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    serving.locationAddress ?? '',
                                    style: TextStyle(color: AppColors.greyColor, fontSize: 11.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fade(duration: 400.ms).scale(begin: const Offset(0.9, 0.9));
            },
          ),
        ),
        const SizedBox(height: 16),
        Divider(color: AppColors.greyColor.withOpacity(0.1), thickness: 1, indent: 20, endIndent: 20),
        const SizedBox(height: 8),
      ],
    );
  }
  Widget _buildFooter(ThemeData theme, bool isDarkMode) {
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: _loadMore,
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