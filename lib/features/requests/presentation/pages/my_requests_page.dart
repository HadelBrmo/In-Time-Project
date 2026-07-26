import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_time/core/constants/app_routes.dart';
import 'package:in_time/core/localization/app_localizations.dart';
import 'package:in_time/core/utils/snackbar_utils.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/media_query.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_error_view.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/responsive_layout.dart';
import 'package:in_time/features/requests/presentation/pages/receivedRequestsView.dart';
import '../bloc/request_bloc.dart';
import '../bloc/request_event.dart';
import '../bloc/request_state.dart';
import '../../domain/entity/request_status.dart';
import '../widgets/request_card.dart';
import '../widgets/showDeleteDialog.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  String searchQuery = "";
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  RequestStatus? selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<RequestsBloc>().add(const FetchMyRequestsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: isSearching
                ? TextField(
              controller: _searchController,
              autofocus: true,
              style: theme.textTheme.titleMedium?.copyWith(color: AppColors.whiteColor, fontSize: 16.sp),
              decoration: InputDecoration(
                hintText: context.tr('search_for_service'),
                hintStyle: const TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            )
                : Text(context.tr('activity_history')),
            actions: [
              IconButton(
                icon: Icon(isSearching ? Icons.close : Icons.search, color: AppColors.whiteColor),
                onPressed: () {
                  setState(() {
                    if (isSearching) {
                      isSearching = false;
                      searchQuery = "";
                      _searchController.clear();
                    } else {
                      isSearching = true;
                    }
                  });
                },
              )
            ],
          ),
          body: ResponsiveLayout(
            mobileBody: _buildContent(media, theme, isDarkMode),
            tabletBody: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _buildContent(media, theme, isDarkMode),
              ),
            ),
            desktopBody: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: _buildContent(media, theme, isDarkMode),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(MediaQueryHelper media, ThemeData theme, bool isDarkMode) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: media.width * 0.05,
            vertical: media.height * 0.02,
          ),
          child: Container(
            height: media.height * 0.055,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              unselectedLabelColor: isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor,
              labelColor: AppColors.whiteColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.assignment_outlined, size: 18),
                      SizedBox(width: media.width * 0.02),
                      Flexible(
                        child: Text(
                          context.tr('my_requests'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.move_to_inbox_outlined, size: 18),
                      SizedBox(width: media.width * 0.02),
                      Flexible(
                        child: Text(
                          context.tr('received_requests'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildFilterBar(media, isDarkMode),
        Expanded(
          child: TabBarView(
            children: [
              BlocListener<RequestsBloc, RequestsState>(
                listener: (context, state) {
                  if (state is RequestDeletedSuccessState) {
                    SnackBarUtils.showSuccess(context, context.tr('request_deleted_success'));
                    context.read<RequestsBloc>().add(FetchMyRequestsEvent());
                  } else if (state is RequestDeleteErrorState) {
                    SnackBarUtils.showError(context, state.message);
                  }
                },
                child: BlocBuilder<RequestsBloc, RequestsState>(
                  builder: (context, state) {
                    if (state is RequestsLoadingState) {
                      return const LoadingWidget();
                    } else if (state is RequestsLoadedState) {
                      final filteredRequests = state.requests.where((req) {
                        return req.serving.title.toLowerCase().contains(searchQuery.toLowerCase());
                      }).toList();

                      if (filteredRequests.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assignment_late_outlined,
                                size: media.width * 0.15,
                                color: AppColors.greyColor,
                              ),
                              SizedBox(height: media.height * 0.015),
                              Text(
                                searchQuery.isEmpty ? context.tr('no_requests') : context.tr('no_search_results'),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: AppColors.greyColor,
                                  fontSize: media.width * 0.04,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: media.width * 0.05,
                          vertical: media.height * 0.01,
                        ),
                        itemCount: filteredRequests.length,
                        itemBuilder: (context, index) {
                          final request = filteredRequests[index];
                          return buildRequestCard(
                            context: context,
                            request: request,
                            media: media,
                            isDarkMode: isDarkMode,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.serviceDetailsPage,
                                arguments: request.serving,
                              );
                            },
                            onLongPress: () {
                              showDeleteDialog(context, request.id);
                            },
                          )
                              .animate()
                              .fadeIn(duration: 350.ms, delay: (index * 80).ms)
                              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
                        },
                      );
                    } else if (state is RequestsErrorState) {
                      return CustomErrorView(
                        message: state.message,
                        statusCode: state.statusCode,
                        onRetry: () {
                          context.read<RequestsBloc>().add(FetchMyRequestsEvent());
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              ReceivedRequestsView(searchQuery: searchQuery),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(MediaQueryHelper media, bool isDarkMode) {
    return Container(
      height: 45.h,
      margin: EdgeInsets.only(bottom: 10.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
        children: [
          _buildFilterChip(
            label: context.tr('view_all'),
            isSelected: selectedStatus == null,
            onTap: () {
              setState(() => selectedStatus = null);
              context.read<RequestsBloc>().add(const FetchMyRequestsEvent());
            },
          ),
          ...RequestStatus.values.map((status) {
            return _buildFilterChip(
              label: status.getTranslation(context),
              isSelected: selectedStatus == status,
              color: status.color,
              onTap: () {
                setState(() => selectedStatus = status);
                context.read<RequestsBloc>().add(FetchMyRequestsEvent(status: status));
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (color ?? AppColors.primaryColor),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12.sp,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.transparent,
        selectedColor: color ?? AppColors.primaryColor,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : (color?.withOpacity(0.5) ?? AppColors.primaryColor.withOpacity(0.3)),
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}