import 'package:flutter/material.dart';

import '../providers/exercise.dart';

class EditableExerciseListTile extends StatelessWidget {
  EditableExerciseListTile({
    Key? key,
    required this.exercise,
    required this.exercises,
    required this.exerciseIndex,
  }) : super(key: key);

  Exercise exercise;
  final List<Exercise> exercises;
  final int exerciseIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: Colors.black38),
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.only(left: 30, top: 15),
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextFormField(
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please provide a title.';
            }
            return null;
          },
          onChanged: (newValue) {
            exercise = Exercise(
              id: exercise.id,
              title: newValue,
              reps: exercise.reps,
              sets: exercise.sets,
              rest: exercise.rest,
              note: exercise.note,
              weights: exercise.weights,
              record: exercise.record,
            );
            exercises[exerciseIndex] = exercise;
          },
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          initialValue: exercise.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.only(top: 15),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Expanded(
              flex: 2,
              child: Container(),
            ),
            const Text('REPS: ',
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.grey)),
            Expanded(
              flex: 3,
              child: TextFormField(
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please provide the reps.';
                  }
                  return null;
                },
                onChanged: (newValue) {
                  exercise = Exercise(
                    id: exercise.id,
                    title: exercise.title,
                    reps: newValue,
                    sets: exercise.sets,
                    rest: exercise.rest,
                    note: exercise.note,
                    weights: exercise.weights,
                    record: exercise.record,
                  );
                  exercises[exerciseIndex] = exercise;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                initialValue: exercise.reps,
                textAlign: TextAlign.left,
              ),
            ),
          ]),
        ),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 15),
                child: Column(children: [
                  const Text(
                    'Serie',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.grey),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please provide the sets.';
                      }

                      try {
                        int.parse(value!);
                      } catch (err) {
                        return 'Sets has to be an integer number';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      int sets;
                      try {
                        sets = int.parse(newValue);
                      } catch (err) {
                        sets = 0;
                      }
                      exercise = Exercise(
                        id: exercise.id,
                        title: exercise.title,
                        reps: exercise.reps,
                        sets: sets,
                        rest: exercise.rest,
                        note: exercise.note,
                        weights: exercise.weights,
                        record: exercise.record,
                      );
                      exercises[exerciseIndex] = exercise;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                    initialValue: exercise.sets.toString(),
                  ),
                ]),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 15),
                child: Column(children: [
                  const Text(
                    'Recupero',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.grey),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please provide the rest time.';
                      }
                      try {
                        int.parse(value!);
                      } catch (err) {
                        return 'Rest has to be an integer number';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      int rest;
                      try {
                        rest = int.parse(newValue);
                      } catch (err) {
                        rest = 0;
                      }
                      exercise = Exercise(
                        id: exercise.id,
                        title: exercise.title,
                        reps: exercise.reps,
                        sets: exercise.sets,
                        rest: rest,
                        note: exercise.note,
                        weights: exercise.weights,
                        record: exercise.record,
                      );
                      exercises[exerciseIndex] = exercise;
                    },
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                    initialValue: exercise.rest.toString(),
                  ),
                ]),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20, top: 5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 15.5,
                  ),
                  child: const Text('Note: ',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.grey)),
                ),
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please provide the note.';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      exercise = Exercise(
                        id: exercise.id,
                        title: exercise.title,
                        reps: exercise.reps,
                        sets: exercise.sets,
                        rest: exercise.rest,
                        note: newValue,
                        weights: exercise.weights,
                        record: exercise.record,
                      );
                      exercises[exerciseIndex] = exercise;
                    },
                    textInputAction: TextInputAction.done,
                    maxLines: 10,
                    minLines: 1,
                    style: const TextStyle(fontSize: 15),
                    initialValue: exercise.note,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ]),
        )
      ]),
    );
  }
}
