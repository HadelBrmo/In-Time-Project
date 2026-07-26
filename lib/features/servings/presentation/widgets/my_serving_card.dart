import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/constants/media_query.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../home/presentation/pages/serviceDetailsPage.dart';
import '../../domain/entity/service_entity.dart';

class MyServingCard extends StatelessWidget {
  final ServiceEntity serving;
  final VoidCallback onEdit;
  final Function(bool) onToggleStatus;

  const MyServingCard({
    super.key,
    required this.serving,
    required this.onEdit,
    required this.onToggleStatus,
  });

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      final DateTime parsedDate = DateTime.parse(dateStr).toLocal();
      return DateFormat('yyyy/MM/dd').format(parsedDate);
    } catch (e) {
      return "";
    }
  }

  Map<String, dynamic> _getServingTypeDetails(BuildContext context, String? type) {
    switch (type?.toLowerCase()) {
      case 'paid':
      case 'مدفوعة':
        return {'text': context.tr('paid'), 'color': Colors.amber};
      case 'voluntary':
      case 'تطوعية':
        return {'text': context.tr('voluntary'), 'color': Colors.green};
      case 'exchange':
      case 'تبادلية':
        return {'text': context.tr('exchange'), 'color': Colors.purple};
      default:
        return {'text': type ?? context.tr('others'), 'color': Colors.blue};
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final typeDetails = _getServingTypeDetails(context, serving.servingTypeName);
    final typeColor = typeDetails['color'] as Color;

    return InkWell(
      onTap: () {
        if (serving.id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServiceDetailsPage(serviceId: serving.id!),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: media.height * 0.02),
        padding: EdgeInsets.all(media.width * 0.04),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.blackColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode
                ? AppColors.whiteColor.withOpacity(0.08)
                : AppColors.greyColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 14, color: AppColors.greyColor),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(serving.createdAt),
                      style: theme.textTheme.titleMedium?.copyWith(color: AppColors.greyColor, fontSize: 11),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    typeDetails['text'],
                    style: theme.textTheme.titleMedium?.copyWith(color: typeColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: media.height * 0.01),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    serving.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: media.width * 0.045,
                      color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    serving.meetingType == 'direct' ? context.tr('direct') : context.tr('online'),
                    style: theme.textTheme.titleMedium?.copyWith(color: AppColors.primaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: media.height * 0.01),

            Text(
              serving.description,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDarkMode ? AppColors.greyColor : Colors.black54,
                height: 1.3,
                fontSize: media.width * 0.035,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: media.height * 0.015),

            Divider(color: AppColors.greyColor.withOpacity(0.1), height: 1),
            SizedBox(height: media.height * 0.01),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      serving.servingTypeName == 'voluntary' ? Icons.favorite : Icons.monetization_on,
                      color: serving.servingTypeName == 'voluntary' ? Colors.green : Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      serving.servingTypeName == 'voluntary'
                          ? context.tr('voluntary_work')
                          : "${serving.costAmount ?? '0'} ${serving.unitName ?? ''}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: media.width * 0.038,
                        color: serving.servingTypeName == 'voluntary'
                            ? Colors.green
                            : (isDarkMode ? Colors.amber[200] : Colors.amber[800]),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          serving.status == 'active' ? context.tr('active') : context.tr('inactive'),
                          style: TextStyle(
                            fontSize: 10,
                            color: serving.status == 'active' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: serving.status == 'active',
                            activeColor: Colors.green,
                            onChanged: (isActive) {
                              if (isActive) {
                                onToggleStatus(true);
                              } else {
                                _showDeactivateConfirmation(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_calendar_outlined, color: AppColors.primaryColor, size: 22),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primaryColor.withOpacity(0.08),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutBack),
    );
  }

  void _showDeactivateConfirmation(BuildContext context) {
    DialogUtils.showConfirmDialog(
      context: context,
      title: context.tr('deactivate_service_title'),
      message: context.tr('deactivate_service_msg'),
      confirmText: context.tr('confirm_deactivation'),
      confirmColor: Colors.red,
      onConfirm: () {
        onToggleStatus(false);
      },
    );
  }
}
