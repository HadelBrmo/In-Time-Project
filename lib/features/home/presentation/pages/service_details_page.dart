import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_time/core/localization/app_localizations.dart';
import 'package:in_time/core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../injection_container.dart';
import '../../../servings/presentation/bloc/service/services_bloc.dart';
import '../../../servings/presentation/bloc/service/services_event.dart';
import '../../../servings/presentation/bloc/service/services_state.dart';
import '../../../servings/presentation/bloc/saved_services/saved_services_bloc.dart';
import '../widgets/service_details/build_details_body.dart';
import '../bloc/home_bloc.dart';

// ✅ 1. استيراد صفحة تقديم الشكوى (بمسار مطلق آمن)
import 'package:in_time/features/complaints/presentation/pages/submit_complaint_page.dart';

class ServiceDetailsPage extends StatelessWidget {
  final int serviceId;
  final bool isFromRequests;
  final bool? isFromMyServings;

  const ServiceDetailsPage({
    super.key,
    required this.serviceId,
    this.isFromRequests = false,
    this.isFromMyServings = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ServicesBloc>()..add(GetServiceDetailsEvent(serviceId)),
        ),
        BlocProvider(
          create: (context) => sl<HomeBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: BlocBuilder<ServicesBloc, ServicesState>(
            builder: (context, state) {
              if (state is ServiceDetailsLoaded) {
                return Text(
                  state.service.title.trim().split(RegExp(r'\s+')).take(2).join(' '),
                  style: theme.textTheme.titleSmall?.copyWith(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                );
              }
              return Text(context.tr('service_details'));
            },
          ),
          actions: [
            BlocBuilder<ServicesBloc, ServicesState>(
              builder: (context, state) {
                if (state is ServiceDetailsLoaded) {
                  final service = state.service;
                  final bool isOwner = (isFromMyServings == true) ? true : (service.isOwner ?? false);

                  if (!isOwner) {
                    return Row(
                      children: [
                        BlocBuilder<SavedServicesBloc, SavedServicesState>(
                          builder: (context, savedState) {
                            bool isSaved = false;
                            if (savedState is SavedServicesLoaded) {
                              isSaved = savedState.savedServices.any((s) => s.id == service.id);
                            }
                            return IconButton(
                              icon: Icon(
                                isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                color: isSaved ? Colors.yellow : Colors.white,
                              ),
                              onPressed: () {
                                context.read<SavedServicesBloc>().add(ToggleSaveServiceEvent(service));
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.warning_amber_rounded, color: Colors.amber),
                          tooltip: 'تقديم شكوى',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubmitComplaintPage(
                                  servingId: service.id ?? 0,
                                  accusedUserId: service.userId ?? 0,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, state) {
            if (state is ServiceDetailsLoading) {
              return const LoadingWidget();
            } else if (state is ServiceDetailsError) {
              return Center(
                child: Text(state.message, style: const TextStyle(color: Colors.red)),
              );
            } else if (state is ServiceDetailsLoaded) {
              final service = state.service;
              final bool isOwner = (isFromMyServings == true) ? true : (service.isOwner ?? false);

              return ResponsiveLayout(
                mobileBody: buildDetailsBody(context, service, isFromRequests, isOwner),
                tabletBody: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: buildDetailsBody(context, service, isFromRequests, isOwner),
                  ),
                ),
                desktopBody: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: buildDetailsBody(context, service, isFromRequests, isOwner),
                  ),
                ),
              );
            }
            return Center(
              child: Text(
                context.tr('preparing_data'),
                style: theme.textTheme.titleMedium,
              ),
            );
          },
        ),
      ),
    );
  }
}