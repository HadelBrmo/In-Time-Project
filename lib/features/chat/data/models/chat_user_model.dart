
import '../../domain/entities/chat_entity.dart';

class ChatUserModel extends ChatUserEntity {
  const ChatUserModel({
    required super.id,
    required super.fullName,
    super.profilePicture,
    super.role,
    super.isVerified,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      profilePicture: json['profile_picture'] as String?,
      role: json['role'] as String?,
      isVerified: json['is_identity_verified'] is bool
          ? json['is_identity_verified']
          : (json['is_identity_verified'] == 1 || json['is_identity_verified'] == true),
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