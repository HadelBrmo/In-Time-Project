import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final int? parentId;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.parentId,
  });

  @override
  List<Object?> get props => [id, name, parentId];
}
