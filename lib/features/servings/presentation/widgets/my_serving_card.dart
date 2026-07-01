import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../home/presentation/pages/serviceDetailsPage.dart';
import '../../domain/entity/service_entity.dart';

class MyServingCard extends StatelessWidget {
  final ServiceEntity serving;
  final VoidCallback onEdit;

  const MyServingCard({super.key, required this.serving, required this.onEdit});

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      final DateTime parsedDate = DateTime.parse(dateStr).toLocal();
      return DateFormat('yyyy/MM/dd').format(parsedDate);
    } catch (e) {
      return "";
    }
  }

  Map<String, dynamic> _getServingTypeDetails(String? type) {
    switch (type?.toLowerCase()) {
      case 'paid':
        return {'text': 'مدفوعة', 'color': Colors.amber};
      case 'voluntary':
        return {'text': 'تطوعية', 'color': Colors.green};
      case 'exchange':
        return {'text': 'تبادلية', 'color': Colors.purple};
      default:
        return {'text': 'أخرى', 'color': Colors.blue};
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final typeDetails = _getServingTypeDetails(serving.servingTypeName);
    final typeColor = typeDetails['color'] as Color;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailsPage(serviceId: serving.id!),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: media.height * 0.02),
        padding: EdgeInsets.all(media.width * 0.04),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.blackColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
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
                    Icon(Icons.calendar_month_outlined, size: 14, color: AppColors.greyColor),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(serving.createdAt),
                      style: const TextStyle(color: AppColors.greyColor, fontSize: 11),
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
                    style: TextStyle(color: typeColor, fontSize: 11, fontWeight: FontWeight.bold),
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
                    serving.meetingType == 'direct' ? "مباشر" : "أونلاين",
                    style: const TextStyle(color: AppColors.primaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: media.height * 0.01),

            Text(
              serving.description,
              style: TextStyle(
                color: isDarkMode ? AppColors.greyColor : Colors.black54,
                height: 1.3,
                fontSize: media.width * 0.035,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: media.height * 0.015),

            Divider(color: Colors.grey.withOpacity(0.1), height: 1),
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
                          ? "عمل تطوعي"
                          : "${serving.costAmount ?? '0'} ${serving.unitName ?? ''}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: media.width * 0.038,
                        color: serving.servingTypeName == 'voluntary'
                            ? Colors.green
                            : (isDarkMode ? Colors.amber[200] : Colors.amber[800]),
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
            )
          ],
        ),
      ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutBack),
    );
  }
}
