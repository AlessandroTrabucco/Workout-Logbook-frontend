import 'package:flutter/material.dart';
import 'package:gym_app_fixed/widgets/exercise_list_tile.dart';

import '../providers/day.dart';
import '../providers/exercise.dart';

class AddDayScreen extends StatefulWidget {
  static const route = '/add-day';
  const AddDayScreen({Key? key}) : super(key: key);

  @override
  State<AddDayScreen> createState() => _AddDayScreenState();
}

class _AddDayScreenState extends State<AddDayScreen> {
  final _dayForm = GlobalKey<FormState>();
  final _exerciseForm = GlobalKey<FormState>();
  var _newDay =
      Day(workoutCount: 0, title: '', exercises: [], exerciseIndex: -1);
  var _newExercise = Exercise(
    title: '',
    reps: '',
    sets: 0,
    rest: 0,
    note: '',
    weights: [],
    record: [],
  );
  List<Exercise> exercises = [];

  void _saveDayForm() async {
    final isValid = _dayForm.currentState!.validate();

    if (!isValid) return;
    _dayForm.currentState!.save();
    _newDay = Day(
      workoutCount: _newDay.workoutCount,
      title: _newDay.title,
      exercises: exercises,
      exerciseIndex: _newDay.exerciseIndex,
    );
    Navigator.pop(context, _newDay);
  }

  void _saveExerciseForm() async {
    final isValid = _exerciseForm.currentState!.validate();
    if (!isValid) return;
    _exerciseForm.currentState!.save();
    setState(() {
      exercises.add(_newExercise);
    });
    _exerciseForm.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _dayForm,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: TextFormField(
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please provide a title.';
              }
              return null;
            },
            onSaved: (newValue) => {
              _newDay = Day(
                workoutCount: _newDay.workoutCount,
                title: newValue ?? '',
                exercises: _newDay.exercises,
                exerciseIndex: _newDay.exerciseIndex,
              ),
            },
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              hintText: 'Day name',
              border: InputBorder.none,
            ),
            style: const TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10),
              child: OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _saveDayForm();
                },
              ),
            ),
          ],
        ),
        body: Form(
          key: _exerciseForm,
          child: SafeArea(
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(30),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Title'),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please provide a title.';
                          }
                          return null;
                        },
                        onSaved: (newValue) => {
                          _newExercise = Exercise(
                            title: newValue ?? '',
                            reps: _newExercise.reps,
                            sets: _newExercise.sets,
                            rest: _newExercise.rest,
                            note: _newExercise.note,
                            weights: _newExercise.weights,
                            record: _newExercise.record,
                          )
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            top: 2,
                            bottom: 2,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Reps'),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please provide the reps.';
                          }
                          return null;
                        },
                        onSaved: (newValue) => {
                          _newExercise = Exercise(
                            title: _newExercise.title,
                            reps: newValue ?? '',
                            sets: _newExercise.sets,
                            rest: _newExercise.rest,
                            note: _newExercise.note,
                            weights: _newExercise.weights,
                            record: _newExercise.record,
                          )
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            top: 2,
                            bottom: 2,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Sets'),
                      const SizedBox(
                        height: 10,
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
                        onSaved: (newValue) {
                          int sets;
                          try {
                            sets = int.parse(newValue!);
                          } catch (err) {
                            sets = 0;
                          }
                          _newExercise = Exercise(
                            title: _newExercise.title,
                            reps: _newExercise.reps,
                            sets: sets,
                            rest: _newExercise.rest,
                            note: _newExercise.note,
                            weights: _newExercise.weights,
                            record: _newExercise.record,
                          );
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            top: 2,
                            bottom: 2,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Rest'),
                      const SizedBox(
                        height: 10,
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
                        onSaved: (newValue) {
                          int rest;
                          try {
                            rest = int.parse(newValue!);
                          } catch (err) {
                            rest = 0;
                          }
                          _newExercise = Exercise(
                            title: _newExercise.title,
                            reps: _newExercise.reps,
                            sets: _newExercise.sets,
                            rest: rest,
                            note: _newExercise.note,
                            weights: _newExercise.weights,
                            record: _newExercise.record,
                          );
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            top: 2,
                            bottom: 2,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Note'),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please provide note.';
                          }
                          return null;
                        },
                        onSaved: (newValue) => {
                          _newExercise = Exercise(
                            title: _newExercise.title,
                            reps: _newExercise.reps,
                            sets: _newExercise.sets,
                            rest: _newExercise.rest,
                            note: newValue ?? '',
                            weights: _newExercise.weights,
                            record: _newExercise.record,
                          )
                        },
                        textInputAction: TextInputAction.done,
                        maxLength: 100,
                        maxLines: 3,
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            top: 20,
                            bottom: 2,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 120, right: 120),
                  child: OutlinedButton(
                    // ignore: avoid_returning_null_for_void
                    onPressed: () {
                      _saveExerciseForm();
                    },
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(15)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Add Exercise',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    ...exercises.map(
                      (exercise) => ExerciseListTile(
                          deleteExerciseHandler: null, exercise: exercise),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
