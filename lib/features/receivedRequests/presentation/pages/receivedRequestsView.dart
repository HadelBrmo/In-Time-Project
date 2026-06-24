import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../core/widgets/customErrorView.dart';
import '../bloc/received_requests_bloc.dart';
import '../bloc/received_requests_event.dart';
import '../bloc/received_requests_state.dart';
import '../widgets/received_request_card.dart';

class ReceivedRequestsView extends StatefulWidget {
  final String searchQuery;

  const ReceivedRequestsView({super.key, required this.searchQuery});

  @override
  State<ReceivedRequestsView> createState() => _ReceivedRequestsViewState();
}

class _ReceivedRequestsViewState extends State<ReceivedRequestsView> {
  @override
  void initState() {
    super.initState();
    context.read<ReceivedRequestsBloc>().add(FetchReceivedRequestsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);

    return BlocBuilder<ReceivedRequestsBloc, ReceivedRequestsState>(
      builder: (context, state) {
        if (state is ReceivedRequestsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        } else if (state is ReceivedRequestsLoadedState) {
          final allRequests = <Map<String, dynamic>>[];
          for (var group in state.requestGroups) {
            for (var req in group.requests) {
              allRequests.add({
                'servingTitle': group.servingTitle,
                'request': req,
              });
            }
          }

          final filteredReceived = allRequests.where((item) {
            final title = item['servingTitle'].toString().toLowerCase();
            final name = item['request'].requesterFullName.toString().toLowerCase();
            return title.contains(widget.searchQuery.toLowerCase()) ||
                name.contains(widget.searchQuery.toLowerCase());
          }).toList();

          if (filteredReceived.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.move_to_inbox_outlined,
                    size: media.width * 0.15,
                    color: AppColors.greyColor,
                  ),
                  SizedBox(height: media.height * 0.015),
                  Text(
                    widget.searchQuery.isEmpty ? "لا توجد طلبات واردة بعد." : "لا توجد نتائج تطابق بحثك.",
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
            itemCount: filteredReceived.length,
            itemBuilder: (context, index) {
              final item = filteredReceived[index];
              final reqItem = item['request'];
              final servingTitle = item['servingTitle'];

              return ReceivedRequestCard(
                request: reqItem,
                servingTitle: servingTitle,
                onAccept: () {
                },
                onReject: () {
                },
              )
                  .animate()
                  .fadeIn(duration: 350.ms, delay: (index * 80).ms)
                  .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
            },
          );
        } else if (state is ReceivedRequestsErrorState) {
          return CustomErrorView(
            message: state.message,
            onRetry: () {
              context.read<ReceivedRequestsBloc>().add(FetchReceivedRequestsEvent());
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}