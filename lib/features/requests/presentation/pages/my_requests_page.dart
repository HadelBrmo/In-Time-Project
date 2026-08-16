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
import 'package:in_time/features/requests/presentation/pages/received_requests_view.dart';
import 'package:in_time/features/requests/presentation/pages/pending_confirmations_view.dart';
import '../bloc/request_bloc.dart';
import '../bloc/request_event.dart';
import '../bloc/request_state.dart';
import '../widgets/request_card.dart';
import '../widgets/show_delete_dialog.dart';
import '../../../../core/constants/enums.dart';

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
        length: 3,
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
            vertical: media.height * 0.03,
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
                          style: const TextStyle(fontWeight: FontWeight.bold,
                              fontFamily: 'Arial',
                          fontSize: 18
                          ),
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
                          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',
                          fontSize: 18,
                          ),
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
                      const Icon(Icons.fact_check_outlined, size: 18),
                      SizedBox(width: media.width * 0.02),
                      Flexible(
                        child: Text(
                          "تأكيدات",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Arial',
                            fontSize: 18,
                          ),
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
        _buildStatusFilter(media, theme, isDarkMode),
        Expanded(
          child: TabBarView(
            children: [
              BlocListener<RequestsBloc, RequestsState>(
                listener: (context, state) {
                  if (state is RequestDeletedSuccessState) {
                    SnackBarUtils.showSuccess(context, context.tr('request_deleted_success'));
                    context.read<RequestsBloc>().add(FetchMyRequestsEvent(status: selectedStatus));
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
                          context.read<RequestsBloc>().add(FetchMyRequestsEvent(status: selectedStatus));
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              ReceivedRequestsView(searchQuery: searchQuery),
              const PendingConfirmationsView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFilter(MediaQueryHelper media, ThemeData theme, bool isDarkMode) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: ChoiceChip(
              label: const Text('الكل'),
              selected: selectedStatus == null,
              selectedColor: AppColors.primaryColor,
              checkmarkColor: Colors.white,
              backgroundColor: AppColors.primaryColor.withOpacity(0.05),
              side: BorderSide(
                color: selectedStatus == null ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.3),
                width: 1,
              ),
              labelStyle: TextStyle(
                color: selectedStatus == null ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
                fontWeight: selectedStatus == null ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    selectedStatus = null;
                  });
                  context.read<RequestsBloc>().add(const FetchMyRequestsEvent());
                }
              },
            ),
          ),
          ...RequestStatus.values.where((s) => s != RequestStatus.unknown).map((status) {
            final isSelected = selectedStatus == status;
            return Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: ChoiceChip(
                label: Text(status.translation),
                selected: isSelected,
                selectedColor: status.color,
                checkmarkColor: Colors.white,
                backgroundColor: status.color.withOpacity(0.05),
                side: BorderSide(
                  color: isSelected ? status.color : status.color.withOpacity(0.4),
                  width: 1,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() {
                      selectedStatus = status;
                    });
                    context.read<RequestsBloc>().add(FetchMyRequestsEvent(status: status));
                  }
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}