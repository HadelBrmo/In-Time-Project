
import 'package:equatable/equatable.dart';

class ComplaintResponse extends Equatable {
  final bool success;
  final ComplaintData data;
  final String message;

  const ComplaintResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ComplaintResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintResponse(
      success: json['success'] ?? false,
      data: ComplaintData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }

  @override
  List<Object?> get props => [success, data, message];
}

class ComplaintData extends Equatable {
  final int servingId;
  final int accusedUserId;
  final String reason;
  final String description;
  final int complaintId;
  final String? attachmentUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ComplaintData({
    required this.servingId,
    required this.accusedUserId,
    required this.reason,
    required this.description,
    required this.complaintId,
    this.attachmentUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComplaintData.fromJson(Map<String, dynamic> json) {
    return ComplaintData(
      servingId: json['serving_id'] ?? 0,
      accusedUserId: json['accused_user_id'] ?? 0,
      reason: json['reason'] ?? '',
      description: json['description'] ?? '',
      complaintId: json['complaint_id'] ?? 0,
      attachmentUrl: json['attachment_url'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  List<Object?> get props => [
        servingId,
        accusedUserId,
        reason,
        description,
        complaintId,
        attachmentUrl,
        createdAt,
        updatedAt,
      ];
}