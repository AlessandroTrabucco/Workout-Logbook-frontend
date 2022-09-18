import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workouts.dart';
import '../widgets/workout_grid_tile.dart';
import '../widgets/add_workout_button.dart';

class WorkoutsGrid extends StatelessWidget {
  const WorkoutsGrid({
    Key? key,
    required this.deleteWorkoutHandler,
  }) : super(key: key);

  final deleteWorkoutHandler;

  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<Workouts>(context).workouts;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 300 / 310,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemCount: workouts.length + 1,
      itemBuilder: (BuildContext ctx, index) {
        return index == workouts.length
            ? const AddWorkoutButton()
            : WorkoutGridTile(
                deleteWorkoutHandler: deleteWorkoutHandler,
                workoutTitle: workouts[index].title,
                workoutId: workouts[index].id,
              );
      },
    );
  }
}
