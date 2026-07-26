import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/media_query.dart';
import '../../domain/entity/received_request_entity.dart';

class ReceivedRequestCard extends StatelessWidget {
  final ReceivedRequestItemEntity request;
  final String servingTitle;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const ReceivedRequestCard({
    super.key,
    required this.request,
    required this.servingTitle,
    required this.onAccept,
    required this.onReject,
  });

  String _formatTime(String createdAtString) {
    try {
      if (createdAtString.isEmpty) return "";
      final DateTime parsedDate = DateTime.parse(createdAtString).toLocal();
      final now = DateTime.now();

      if (parsedDate.year == now.year && parsedDate.month == now.month && parsedDate.day == now.day) {
        return DateFormat('hh:mm a', 'ar').format(parsedDate);
      } else {
        return DateFormat('yyyy/MM/dd').format(parsedDate);
      }
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: media.height * 0.015),
      padding: EdgeInsets.all(media.width * 0.04),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.blackColor : Colors.white,
        borderRadius: BorderRadius.circular(media.width * 0.035),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.requesterFullName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: media.width * 0.045,
                        color: isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: media.height * 0.005),
                    Text(
                      "طلب على خدمة: $servingTitle",
                      style: TextStyle(
                        fontSize: media.width * 0.041,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatTime(request.createdAt),
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontSize: media.width * 0.04,
                ),
              ),
            ],
          ),

          SizedBox(height: media.height * 0.015),

          Text(
            request.message.isNotEmpty ? request.message : "لم يتم إرفاق رسالة توضيحية.",
            style: TextStyle(
              fontSize: media.width * 0.037,
              color: isDarkMode ? AppColors.greyColor : Colors.black87,
              height: 1.3,
            ),
          ),

          SizedBox(height: media.height * 0.02),

          _buildActionButtons(media),
        ],
      ),
    );
  }

  Widget _buildActionButtons(MediaQueryHelper media) {
    if (request.status == 'accepted') {
      return SizedBox(
        width: double.infinity,
        height: media.height * 0.045,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.withOpacity(0.12),
            disabledBackgroundColor: Colors.green.withOpacity(0.12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text(
            "تم قبول الطلب",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    if (request.status == 'rejected') {
      return SizedBox(
        width: double.infinity,
        height: media.height * 0.045,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent.withOpacity(0.12),
            disabledBackgroundColor: Colors.redAccent.withOpacity(0.12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text(
            "تم رفض الطلب",
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: media.height * 0.045,
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                "قبول الطلب",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(width: media.width * 0.03),
        Expanded(
          child: SizedBox(
            height: media.height * 0.045,
            child: OutlinedButton(
              onPressed: onReject,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "رفض",
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
