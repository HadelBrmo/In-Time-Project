import '../../../../core/constants/enums.dart';
import '../../domain/entity/received_request_entity.dart';

class ReceivedRequestGroupModel extends ReceivedRequestGroupEntity {
  const ReceivedRequestGroupModel({
    required super.servingId,
    required super.servingTitle,
    required super.requests,
  });

  factory ReceivedRequestGroupModel.fromJson(Map<String, dynamic> json) {
    return ReceivedRequestGroupModel(
      servingId: json['serving_id'] is int ? json['serving_id'] : int.tryParse(json['serving_id']?.toString() ?? '') ?? 0,
      servingTitle: json['serving_title']?.toString() ?? '',
      requests: (json['requests'] as List? ?? [])
          .map((item) => ReceivedRequestItemModel.fromJson(item))
          .toList(),
    );
  }
}

class ReceivedRequestItemModel extends ReceivedRequestItemEntity {
  const ReceivedRequestItemModel({
    required super.id,
    required super.requesterId,
    required super.requesterFullName,
    required super.message,
    required super.status,
    required super.createdAt,
  });

  factory ReceivedRequestItemModel.fromJson(Map<String, dynamic> json) {
    return ReceivedRequestItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      requesterId: json['requester_id'] is int ? json['requester_id'] : int.tryParse(json['requester_id']?.toString() ?? '') ?? 0,
      requesterFullName: json['requester_full_name']?.toString() ?? json['requester_name']?.toString() ?? 'مستخدم غير معروف',
      message: json['message']?.toString() ?? '',
      status: RequestStatus.fromString(json['status']?.toString()),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
