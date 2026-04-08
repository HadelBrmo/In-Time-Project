class ComplaintEntity {
  final String id;
  final String title;
  final String description;
  final String status; // منجزة/قيد المعالجة/مرفوضة

  ComplaintEntity({required this.id, required this.title, required this.description, required this.status});
}