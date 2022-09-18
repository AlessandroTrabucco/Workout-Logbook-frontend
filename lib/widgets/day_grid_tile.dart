import 'package:flutter/material.dart';

import '../screens/exercises_screen.dart';
import '../providers/day.dart';

class DayGridTile extends StatelessWidget {
  final Day day;
  final workoutId;
  final dynamic dayId;
  final notClickable;

  const DayGridTile({
    Key? key,
    required this.day,
    this.workoutId,
    this.dayId,
    this.notClickable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: notClickable != null && !notClickable
          ? (() {})
          : () {
              Navigator.of(context).pushNamed(
                ExercisesScreen.route,
                arguments: {
                  'day': day,
                  'workoutId': workoutId,
                  'dayId': dayId,
                },
              );
            },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(171, 180, 211, 246),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromARGB(171, 38, 139, 255),
            width: 0.1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(
            day.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
