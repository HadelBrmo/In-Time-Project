import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_time/core/constants/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/customErrorView.dart';
import '../bloc/request_bloc.dart';
import '../bloc/request_event.dart';
import '../bloc/request_state.dart';
import '../widgets/request_card.dart';

class MyRequestsPage extends StatefulWidget {
  const MyRequestsPage({super.key});

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RequestsBloc>().add(FetchMyRequestsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg = isDarkMode ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFF8F9FA);
    final textColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
    final cardBg =  AppColors.primaryColor ;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          backgroundColor: scaffoldBg,
          appBar: const CustomAppBar(
            title: Text('سجل الأنشطة'),
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
                    color: isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0E0E0),
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
                            const Icon(Icons.business_center_outlined, size: 18),
                            SizedBox(width: media.width * 0.02),
                            const Text('خدماتي', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    BlocBuilder<RequestsBloc, RequestsState>(
                      builder: (context, state) {
                        if (state is RequestsLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(color: AppColors.primaryColor),
                          );
                        } else if (state is RequestsLoadedState) {
                          if (state.requests.isEmpty) {
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
                                    "لا توجد طلبات مقدمة بعد.",
                                    style: TextStyle(
                                      color: AppColors.greyColor,
                                      fontSize: media.width * 0.04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: media.width * 0.05,
                              vertical: media.height * 0.01,
                            ),
                            itemCount: state.requests.length,
                            itemBuilder: (context, index) {
                              final request = state.requests[index];
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
                              );
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
                    Center(
                      child: Text(
                        'قائمة خدماتي المشهورة تظهر هنا',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}