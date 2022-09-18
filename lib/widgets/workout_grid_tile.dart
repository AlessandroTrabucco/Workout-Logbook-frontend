import 'package:flutter/material.dart';

import '../screens/workout_screen.dart';

class WorkoutGridTile extends StatelessWidget {
  const WorkoutGridTile({
    Key? key,
    required this.deleteWorkoutHandler,
    required this.workoutTitle,
    required this.workoutId,
  }) : super(key: key);

  final String workoutTitle;
  final String workoutId;
  final deleteWorkoutHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                color: Colors.black38,
                width: 0.3,
              ),
            ),
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric()),
          alignment: Alignment.center,
        ),
        onPressed: () => Navigator.of(context).pushNamed(
          WorkoutScreen.route,
          arguments: workoutId,
        ),
        child: Column(
          children: [
            Container(
              height: 60,
              alignment: Alignment.topRight,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () async {
                  deleteWorkoutHandler(workoutId);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Icon(
                    size: 28,
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                workoutTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
