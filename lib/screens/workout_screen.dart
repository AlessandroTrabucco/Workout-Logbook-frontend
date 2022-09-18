import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/days_grid.dart';
import '../widgets/workout_app_bar.dart';
import '../providers/workouts.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({Key? key}) : super(key: key);
  static const route = '/workout';

  @override
  Widget build(BuildContext context) {
    final workoutId = ModalRoute.of(context)!.settings.arguments as String;
    final workout =
        Provider.of<Workouts>(context, listen: false).findById(workoutId);

    return Scaffold(
      appBar: WorkoutAppBar(
        title: workout.title,
        appBar: AppBar(),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 33),
            child: Center(
              child: Text(
                'From ${DateFormat('dd-MM-yyyy').format(workout.startDate)} to ${DateFormat('dd-MM-yyyy').format(workout.endDate)}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            color: Colors.black26,
            height: 0.3,
            width: double.infinity,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: DaysGrid(
                workoutId: workoutId,
              ),
            ),
          )
        ],
      ),
    );
  }
}
