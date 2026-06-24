import 'package:equatable/equatable.dart';

class ReceivedRequestGroupEntity extends Equatable {
  final int servingId;
  final String servingTitle;
  final List<ReceivedRequestItemEntity> requests;

  const ReceivedRequestGroupEntity({
    required this.servingId,
    required this.servingTitle,
    required this.requests,
  });

  @override
  List<Object?> get props => [servingId, servingTitle, requests];
}

class ReceivedRequestItemEntity extends Equatable {
  final int id;
  final int requesterId;
  final String requesterFullName;
  final String message;
  final String status;
  final String createdAt;

  const ReceivedRequestItemEntity({
    required this.id,
    required this.requesterId,
    required this.requesterFullName,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, requesterId, requesterFullName, message, status, createdAt];
}