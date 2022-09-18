import 'package:flutter/material.dart';

import '../providers/exercise.dart';

import './add_exercise_button.dart';
import './editable_exercise_list_tile.dart';

class EditableExercisesList extends StatefulWidget {
  const EditableExercisesList({
    Key? key,
    required this.exercises,
    required this.dayTitle,
    required this.addExerciseHandler,
  }) : super(key: key);
  final List<Exercise> exercises;
  final String dayTitle;
  final addExerciseHandler;

  @override
  State<EditableExercisesList> createState() => _EditableExercisesListState();
}

class _EditableExercisesListState extends State<EditableExercisesList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            child: ListView.builder(
                itemCount: widget.exercises.length + 1,
                itemBuilder: (context, index) {
                  return index == widget.exercises.length
                      ? AddExerciseButton(
                          addExerciseHandler: widget.addExerciseHandler,
                          dayTitle: widget.dayTitle,
                        )
                      : EditableExerciseListTile(
                          exercises: widget.exercises,
                          exerciseIndex: index,
                          exercise: widget.exercises[index],
                        );
                }),
          ),
        ),
      ],
    );
  }
}
