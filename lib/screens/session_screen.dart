import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gym_app_fixed/models/http_exception.dart';
import 'package:gym_app_fixed/providers/exercise.dart';
import 'package:provider/provider.dart';

import '../widgets/weights_widget.dart';
import '../widgets/notes_widget.dart';
import './timer_screen.dart';
import '../widgets/session_header.dart';
import '../providers/workouts.dart';
import 'login_screen.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({Key? key}) : super(key: key);
  static const route = '/session';

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  bool _isLoading = false;
  void nextExercise({workoutId, dayId, exerciseId}) async {
    final provider = Provider.of<Workouts>(context, listen: false);
    final navigator = Navigator.of(context);
    try {
      setState(() {
        _isLoading = true;
      });
      _saveForm();
      final updatedExerciseIndex =
          await provider.updateExerciseSession(workoutId, dayId, exerciseId);
      setState(() {
        _isLoading = false;
      });
      if (updatedExerciseIndex == -1) {
        navigator.pop();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (e.toString() == 'Logout') {
        final navigator = Navigator.of(context);
        const storage = FlutterSecureStorage();
        await storage.delete(key: 'jwt');
        navigator.pushNamedAndRemoveUntil(
            LoginScreen.route, (Route<dynamic> route) => false);
        return Future(() => null);
      }

      return await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(e.runtimeType == HttpException
              ? e.toString()
              : 'Something went wrong'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }

  _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
  }

  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final workoutId = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['workoutId'] as String;
    final dayId = ((ModalRoute.of(context)!.settings.arguments)
        as Map<String, dynamic>)['dayId'] as String;

    final day = Provider.of<Workouts>(context).findDayById(workoutId, dayId);
    final exercises = day.exercises;
    var exerciseIndex = day.exerciseIndex;

    if (exerciseIndex == -1) {
      exerciseIndex = 0;
    }

    return Scaffold(
      body: Form(
        key: _form,
        child: _isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : SafeArea(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        SessionHeader(
                          exercisesLength: exercises.length,
                          exerciseIndex: exerciseIndex,
                          nextExercise: () => nextExercise(
                            workoutId: workoutId,
                            dayId: dayId,
                            exerciseId: exercises[exerciseIndex].id,
                          ),
                        ),
                        Text(
                          exercises[exerciseIndex].title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 30, right: 50, left: 50),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                    child: Text('REPS: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: 18)),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 140,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        exercises[exerciseIndex].reps,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                    child: Text('SERIE: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: 18)),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 30,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        exercises[exerciseIndex]
                                            .sets
                                            .toString(),
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2, left: 50),
                          child: Row(
                            children: [
                              const Text('RECUPERO: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                      fontSize: 18)),
                              Text(
                                exercises[exerciseIndex].rest.toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20, left: 50),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  'NOTE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(4),
                                margin: const EdgeInsets.only(
                                    right: 50, top: 10, bottom: 15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 60,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    exercises[exerciseIndex].note,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 0, right: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 50),
                                child: const Text(
                                  'PESI',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              WeightsWidget(
                                workoutCount: day.workoutCount,
                                exercise: Exercise(
                                  title: exercises[exerciseIndex].title,
                                  reps: exercises[exerciseIndex].reps,
                                  sets: exercises[exerciseIndex].sets,
                                  rest: exercises[exerciseIndex].sets,
                                  note: exercises[exerciseIndex].note,
                                  weights: [
                                    ...exercises[exerciseIndex].weights
                                  ],
                                  record: exercises[exerciseIndex].record,
                                ),
                                exerciseIndex: exerciseIndex,
                                workoutId: workoutId,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 50, right: 50),
                                child: const Text(
                                  'APPUNTI',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              NotesWidget(
                                workoutCount: day.workoutCount,
                                exercise: Exercise(
                                    title: exercises[exerciseIndex].title,
                                    reps: exercises[exerciseIndex].reps,
                                    sets: exercises[exerciseIndex].sets,
                                    rest: exercises[exerciseIndex].sets,
                                    note: exercises[exerciseIndex].note,
                                    weights: exercises[exerciseIndex].weights,
                                    record: [
                                      ...exercises[exerciseIndex].record
                                    ]),
                                exerciseIndex: exerciseIndex,
                                workoutId: workoutId,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 50, right: 50),
                                alignment: Alignment.center,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        TimerScreen.route,
                                        arguments:
                                            exercises[exerciseIndex].rest);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.black54),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(20)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0))),
                                  ),
                                  child: const Text(
                                    'Start Timer',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                margin:
                                    const EdgeInsets.only(top: 13, right: 15),
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            255, 255, 106, 95)),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(15)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Pause Workout',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
