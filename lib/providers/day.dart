import './exercise.dart';

class Day {
  final String title;
  final List<Exercise> exercises;
  int exerciseIndex;
  final int workoutCount;
  final dynamic id;

  Day({
    required this.title,
    required this.exercises,
    required this.exerciseIndex,
    required this.workoutCount,
    this.id,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    List<Exercise> exercises = [];
    if (json['exercises'] != null) {
      exercises = (json['exercises'] as List)
          .map((exercise) => Exercise.fromJson(exercise))
          .toList();
    }
    return Day(
      id: json['_id'],
      title: json['title'],
      exercises: exercises,
      exerciseIndex: json['exerciseIndex'],
      workoutCount: json['workoutCount'],
    );
  }

  toJson() {
    return {
      "title": title,
      "exercises": exercises.map((ex) => ex.toJson()).toList(),
      "exerciseIndex": exerciseIndex,
      "workoutCount": workoutCount,
    };
  }
}
