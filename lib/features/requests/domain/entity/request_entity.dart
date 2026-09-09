// features/requests/domain/entities/request_entity.dart
import 'package:equatable/equatable.dart';

import '../../../../core/constants/enums.dart';
import '../../../servings/domain/entity/service_entity.dart';

class RequestEntity extends Equatable {
  final int id;
  final int servingId;
  final int requesterId;
  final String message;
  final RequestStatus status;
  final String createdAt;
  final ServiceEntity serving;

  const RequestEntity({
    required this.id,
    required this.servingId,
    required this.requesterId,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.serving,
  });

  @override
  List<Object?> get props => [id, servingId, requesterId, message, status, createdAt, serving];
}
