class ChatEntity {
  final String id;
  final String senderName;
  final String lastMessage;
  final String profileUrl;
  final DateTime timestamp;
  final int unreadCount;
  final bool isArchived;

  ChatEntity({
    required this.id,
    required this.senderName,
    required this.lastMessage,
    required this.profileUrl,
    required this.timestamp,
    required this.unreadCount,
    this.isArchived = false,
  });

  ChatEntity copyWith({bool? isArchived}) {
    return ChatEntity(
      id: id,
      senderName: senderName,
      lastMessage: lastMessage,
      profileUrl: profileUrl,
      timestamp: timestamp,
      unreadCount: unreadCount,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}