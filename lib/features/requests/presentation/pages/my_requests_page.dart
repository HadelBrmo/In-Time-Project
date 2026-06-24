import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_time/core/constants/app_routes.dart';
import 'package:in_time/core/utils/snackbar_utils.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/customErrorView.dart';
import '../../../receivedRequests/presentation/pages/receivedRequestsView.dart';
import '../bloc/request_bloc.dart';
import '../bloc/request_event.dart';
import '../bloc/request_state.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<RequestsBloc>().add(FetchMyRequestsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBg = AppColors.primaryColor;

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
              style: TextStyle(color: AppColors.whiteColor, fontSize: 16.sp),
              decoration: const InputDecoration(
                hintText: "ابحث عن الخدمة...",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            )
                : const Text('سجل الأنشطة'),
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
          body: Column(
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
                    unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    labelColor: AppColors.whiteColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.assignment_outlined, size: 18),
                            SizedBox(width: media.width * 0.02),
                            const Text('طلباتي', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.move_to_inbox_outlined, size: 18),
                            SizedBox(width: media.width * 0.02),
                            const Text('الطلبات الواردة', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    BlocListener<RequestsBloc, RequestsState>(
                      listener: (context, state) {
                        if (state is RequestDeletedSuccessState) {
                          SnackBarUtils.showSuccess(context, 'تم حذف الطلب بنجاح');
                          context.read<RequestsBloc>().add(FetchMyRequestsEvent());
                        } else if (state is RequestDeleteErrorState) {
                          SnackBarUtils.showError(context, state.message);
                        }
                      },
                      child: BlocBuilder<RequestsBloc, RequestsState>(
                        builder: (context, state) {
                          if (state is RequestsLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(color: AppColors.primaryColor),
                            );
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
                                      searchQuery.isEmpty ? "لا توجد طلبات مقدمة بعد." : "لا توجد نتائج تطابق بحثك.",
                                      style: TextStyle(
                                        color: AppColors.greyColor,
                                        fontSize: media.width * 0.04,
                                        fontWeight: FontWeight.w500,
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
                    ReceivedRequestsView(searchQuery: searchQuery),                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}