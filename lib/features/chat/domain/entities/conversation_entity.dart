class ConversationEntity {
  final String id;
  final List<String> participants;
  final List<ChatMessageEntity> messages;

  ConversationEntity({required this.id, required this.participants, required this.messages});
}