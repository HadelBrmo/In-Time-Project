class ExchangeRequestEntity {
  final String id;
  final String requesterId;
  final String serviceId;
  final String status; // pending, accepted, rejected

  ExchangeRequestEntity({required this.id, required this.requesterId, required this.serviceId, required this.status});
}