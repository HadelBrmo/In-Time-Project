import 'package:equatable/equatable.dart';

/// عنصر بمعرض الأعمال (Work Gallery) — يطابق شكل استجابة الباك اند الحقيقي
class PortfolioItemEntity extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String? dateOfAchievement;
  final int userId;
  final String? userFullName;
  final List<String> files; // روابط الصور/الملفات المرفقة (ممكن تكون فاضية)
  final String createdAt;
  final String updatedAt;

  const PortfolioItemEntity({
    required this.id,
    required this.title,
    this.description,
    this.dateOfAchievement,
    required this.userId,
    this.userFullName,
    this.files = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dateOfAchievement,
        userId,
        userFullName,
        files,
        createdAt,
        updatedAt,
      ];
}
