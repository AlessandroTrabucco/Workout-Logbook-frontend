import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import './session_screen.dart';
import './edit_exercises_screen.dart';
import '../widgets/exercise_list_tile.dart';
import '../providers/workouts.dart';
import 'login_screen.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({Key? key}) : super(key: key);
  static const route = '/exercises';

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  bool _isLoading = false;

  deleteExerciseHandler(workoutId, dayId, exerciseId) async {
    final navigator = Navigator.of(context);
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Workouts>(context, listen: false)
          .deleteExercise(workoutId, dayId, exerciseId);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (e.toString() == 'Logout') {
        const storage = FlutterSecureStorage();
        await storage.delete(key: 'jwt');
        navigator.pushNamedAndRemoveUntil(
            LoginScreen.route, (Route<dynamic> route) => false);
        return Future(() => null);
      }

      setState(() {
        _isLoading = false;
      });

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(child: CupertinoActivityIndicator()),
      );
    }

    final workoutId = ((ModalRoute.of(context)!.settings.arguments)
        as Map<String, dynamic>)['workoutId'] as String;

    final dayId = ((ModalRoute.of(context)!.settings.arguments)
        as Map<String, dynamic>)['dayId'] as String;

    final day = Provider.of<Workouts>(context).findDayById(workoutId, dayId);

    final exercises = day.exercises;
    final exIndex = day.exerciseIndex;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          day.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                try {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<Workouts>(context, listen: false)
                      .deleteDay(workoutId, dayId);
                  navigator.pop();
                } catch (e) {
                  if (e.toString() == 'Logout') {
                    const storage = FlutterSecureStorage();
                    await storage.delete(key: 'jwt');
                    navigator.pushNamedAndRemoveUntil(
                        LoginScreen.route, (Route<dynamic> route) => false);
                    return Future(() => null);
                  }

                  setState(() {
                    _isLoading = false;
                  });

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
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                    EditExercisesScreen.route,
                    arguments: {
                      'day': day,
                      'workoutId': workoutId,
                      'dayId': day.id,
                    },
                  ),
              icon: const Icon(
                Icons.edit,
              ))
        ],
      ),
      body: Column(
        children: [
          exercises.isEmpty
              ? const SizedBox(
                  height: 10,
                )
              : Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final navigator = Navigator.of(context);
                          if (exIndex == -1) {
                            try {
                              await Provider.of<Workouts>(context,
                                      listen: false)
                                  .updateExerciseIndex(workoutId, dayId);
                              navigator
                                  .pushNamed(SessionScreen.route, arguments: {
                                'workoutId': workoutId,
                                'dayId': dayId,
                              });
                            } catch (e) {
                              if (e.toString() == 'Logout') {
                                final navigator = Navigator.of(context);
                                const storage = FlutterSecureStorage();
                                await storage.delete(key: 'jwt');
                                navigator.pushNamedAndRemoveUntil(
                                    LoginScreen.route,
                                    (Route<dynamic> route) => false);
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
                          } else {
                            navigator
                                .pushNamed(SessionScreen.route, arguments: {
                              'workoutId': workoutId,
                              'dayId': dayId,
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black38, width: 0.2),
                              borderRadius: BorderRadius.circular(15)),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(
                              top: 15, left: 100, right: 100),
                          child: Text(
                            exIndex != -1 ? 'Resume Workout' : 'Start Workout',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return ExerciseListTile(
                      deleteExerciseHandler: (exerciseId) =>
                          deleteExerciseHandler(workoutId, dayId, exerciseId),
                      exercise: exercises[index],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
