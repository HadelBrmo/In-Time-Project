
import '../../domain/entities/chat_entity.dart';

class ChatUserModel extends ChatUserEntity {
  const ChatUserModel({
    required super.id,
    required super.fullName,
    super.profilePicture,
    super.role,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      profilePicture: json['profile_picture'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'profile_picture': profilePicture,
      'role': role,
    };
  }
}