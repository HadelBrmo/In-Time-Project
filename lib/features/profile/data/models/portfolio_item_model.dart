import '../../domain/entities/portfolio_item_entity.dart';

class PortfolioItemModel extends PortfolioItemEntity {
  const PortfolioItemModel({
    required super.id,
    required super.title,
    super.description,
    super.dateOfAchievement,
    required super.userId,
    super.userFullName,
    super.files,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PortfolioItemModel.fromJson(Map<String, dynamic> json) {
    return PortfolioItemModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      dateOfAchievement: json['date_of_achievement'] as String?,
      userId: json['user_id'] as int? ?? 0,
      userFullName: json['user_full_name'] as String?,
      files: (json['files'] as List<dynamic>? ?? [])
          .map((f) {
            if (f is Map<String, dynamic>) {
              return f['file_url'] as String? ?? '';
            }
            return f.toString();
          })
          .where((url) => url.isNotEmpty)
          .toList(),
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}
