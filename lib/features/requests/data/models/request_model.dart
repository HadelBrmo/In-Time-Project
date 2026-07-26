import '../../../home/data/models/service_item_model.dart';
import '../../domain/entity/request_entity.dart';
import '../../domain/entity/request_status.dart';
import '../../../servings/domain/entity/service_entity.dart';

class RequestModel extends RequestEntity {
  const RequestModel({
    required super.id,
    required super.servingId,
    required super.requesterId,
    required super.message,
    required super.status,
    required super.createdAt,
    required super.serving,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      servingId: json['serving_id'] is int ? json['serving_id'] : int.tryParse(json['serving_id']?.toString() ?? '') ?? 0,
      requesterId: json['requester_id'] is int ? json['requester_id'] : int.tryParse(json['requester_id']?.toString() ?? '') ?? 0,
      message: json['message'] ?? '',
      status: RequestStatus.fromString(json['status'] ?? 'pending'),
      createdAt: json['created_at'] ?? '',
      serving: ServiceModel.fromJson(json['serving'] ?? {}),
    );
  }
}
