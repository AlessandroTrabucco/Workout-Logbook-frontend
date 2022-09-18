import './day.dart';

class Workout {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final List<Day> days;

  Workout({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.days,
  });
}
