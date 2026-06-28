// lib/features/my_servings/presentation/bloc/my_servings_event.dart
abstract class MyServingsEvent {}

class FetchMyServingsEvent extends MyServingsEvent {}

class UpdateMyServingEvent extends MyServingsEvent {
  final int id;
  final String title;
  final String description;
  final double costAmount;
  final String meetingType;

  UpdateMyServingEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.costAmount,
    required this.meetingType,
  });
}