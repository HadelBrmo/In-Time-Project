import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:in_time/core/constants/app_routes.dart';
import 'package:in_time/core/constants/app_colors.dart';
import 'package:in_time/core/constants/media_query.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_error_view.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../bloc/request_bloc.dart';
import '../bloc/request_event.dart';
import '../bloc/request_state.dart';
import '../widgets/request_card.dart';

class PendingConfirmationsView extends StatefulWidget {
  const PendingConfirmationsView({super.key});

  @override
  State<PendingConfirmationsView> createState() => _PendingConfirmationsViewState();
}

class _PendingConfirmationsViewState extends State<PendingConfirmationsView> {
  @override
  void initState() {
    super.initState();
    context.read<RequestsBloc>().add(FetchPendingConfirmationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocConsumer<RequestsBloc, RequestsState>(
      listener: (context, state) {
        if (state is RequestActionSuccessState) {
          SnackBarUtils.showSuccess(context, state.message);
          context.read<RequestsBloc>().add(FetchPendingConfirmationsEvent());
        } else if (state is RequestActionErrorState) {
          SnackBarUtils.showError(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is RequestsLoadingState) {
          return const LoadingWidget();
        }

        if (state is PendingConfirmationsLoadedState) {
          final requests = state.requests;

          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_turned_in_outlined, size: 64, color: AppColors.greyColor.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('no_pending_confirmations'),
                    style: theme.textTheme.titleMedium?.copyWith(color: AppColors.greyColor),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: media.width * 0.05, vertical: media.height * 0.02),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return _buildConfirmationCard(context, request, media, isDarkMode, theme);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildConfirmationCard(BuildContext context, dynamic request, MediaQueryHelper media, bool isDarkMode, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          buildRequestCard(
            context: context,
            request: request,
            media: media,
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.serviceDetailsPage,
                arguments: {
                  'serviceId': request.serving.id ?? 0,
                  'isFromRequests': true,
                },
              );
            },
            onLongPress: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _confirmCompletion(request.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("تأكيد الإنجاز", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showRevisionDialog(request.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("طلب تعديل", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _confirmDispute(request.id),
                  icon: const Icon(Icons.gavel_rounded, color: Colors.red),
                  tooltip: "فتح نزاع",
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  void _confirmCompletion(int requestId) {
    DialogUtils.showConfirmDialog(
      context: context,
      title: "تأكيد إكمال الخدمة",
      message: "هل تؤكد أن مقدم الخدمة قام بالعمل المطلوب؟ سيتم تحويل الساعات لرصيده فوراً.",
      confirmText: "نعم، أؤكد",
      onConfirm: () {
        context.read<RequestsBloc>().add(ConfirmCompletionEvent(requestId));
      },
    );
  }

  void _showRevisionDialog(int requestId) {
    final controller = TextEditingController();
    DialogUtils.showCustomDialog(
      context: context,
      builder: AlertDialog(
        title: const Text("طلب تعديل / مهلة"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("يرجى تحديد عدد الأيام الإضافية التي يحتاجها مقدم الخدمة لإنهاء العمل بشكل صحيح."),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "عدد الأيام",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () {
              final days = int.tryParse(controller.text) ?? 1;
              context.read<RequestsBloc>().add(RequestRevisionEvent(requestId, days));
              Navigator.pop(context);
            },
            child: const Text("إرسال"),
          ),
        ],
      ),
    );
  }

  void _confirmDispute(int requestId) {
    DialogUtils.showConfirmDialog(
      context: context,
      title: "فتح نزاع",
      message: "هل تريد رفع هذه المشكلة للإدارة للتدخل وحل النزاع؟",
      confirmText: "رفع للإدارة",
      confirmColor: Colors.red,
      onConfirm: () {
        context.read<RequestsBloc>().add(DisputeRequestEvent(requestId));
      },
    );
  }
}
