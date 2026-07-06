import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/customErrorView.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../bloc/received_requests/received_requests_bloc.dart';
import '../bloc/received_requests/received_requests_event.dart';
import '../bloc/received_requests/received_requests_state.dart';
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
    final theme = Theme.of(context);

    return BlocConsumer<ReceivedRequestsBloc, ReceivedRequestsState>(
      listener: (context, state) {
        if (state is AcceptRequestSuccessState) {
          SnackBarUtils.showSuccess(context, context.tr('request_accepted_success'));
          context.read<ReceivedRequestsBloc>().add(FetchReceivedRequestsEvent());
        } else if (state is RejectRequestSuccessState) {
          SnackBarUtils.showSuccess(context, context.tr('request_rejected_success'));
          context.read<ReceivedRequestsBloc>().add(FetchReceivedRequestsEvent());
        } else if (state is AcceptRequestErrorState) {
          SnackBarUtils.showError(context, state.message);
        } else if (state is RejectRequestErrorState) {
          SnackBarUtils.showError(context, state.message);
        }
      },
      builder: (context, state) {
        bool isProcessing = state is AcceptRequestLoadingState || state is RejectRequestLoadingState;

        if (state is ReceivedRequestsLoadingState) {
          return const LoadingWidget();
        }

        if (state is ReceivedRequestsLoadedState || isProcessing) {
          final currentState = context.read<ReceivedRequestsBloc>().state;
          final currentGroups = currentState is ReceivedRequestsLoadedState
              ? currentState.requestGroups
              : [];

          final allRequests = <Map<String, dynamic>>[];
          for (var group in currentGroups) {
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
              child: Text(
                widget.searchQuery.isEmpty ? context.tr('no_received_requests') : context.tr('no_search_results'),
                style: theme.textTheme.titleMedium?.copyWith(color: AppColors.greyColor, fontSize: media.width * 0.04),
              ),
            );
          }

          return Stack(
            children: [
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: media.width * 0.05, vertical: media.height * 0.01),
                itemCount: filteredReceived.length,
                itemBuilder: (context, index) {
                  final item = filteredReceived[index];
                  final reqItem = item['request'];
                  final servingTitle = item['servingTitle'];

                  return ReceivedRequestCard(
                    request: reqItem,
                    servingTitle: servingTitle,
                    onAccept: () {
                      context.read<ReceivedRequestsBloc>().add(AcceptRequestEvent(reqItem.id));
                    },
                    onReject: () {
                      context.read<ReceivedRequestsBloc>().add(RejectRequestEvent(reqItem.id));
                    },
                  );
                },
              ),
              if (isProcessing)
                Container(
                  color: Colors.black12,
                  child: const LoadingWidget(),
                ),
            ],
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
