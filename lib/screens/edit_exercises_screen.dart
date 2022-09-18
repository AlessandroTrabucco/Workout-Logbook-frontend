import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../providers/day.dart';
import '../widgets/editable_exercises_list.dart';
import '../providers/exercise.dart';
import './add_exercise_screen.dart';
import '../providers/workouts.dart';
import 'login_screen.dart';

class EditExercisesScreen extends StatefulWidget {
  static const route = '/edit-exercises';
  const EditExercisesScreen({Key? key}) : super(key: key);

  @override
  State<EditExercisesScreen> createState() => _EditExercisesScreenState();
}

class _EditExercisesScreenState extends State<EditExercisesScreen> {
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;
  var workoutId;
  var dayId;
  var dayTitle;
  List<Exercise> exercises = [];
  var day;

  void _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    final navigator = Navigator.of(context);
    try {
      await Provider.of<Workouts>(context, listen: false).updateDay(
        workoutId,
        dayId,
        dayTitle,
        exercises,
      );
    } catch (e) {
      if (e.toString() == 'Logout') {
        final navigator = Navigator.of(context);
        const storage = FlutterSecureStorage();
        await storage.delete(key: 'jwt');
        navigator.pushNamedAndRemoveUntil(
            LoginScreen.route, (Route<dynamic> route) => false);
        return Future(() => null);
      }
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(e.toString()),
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

    setState(() {
      _isLoading = false;
    });
    navigator.pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      day = ((ModalRoute.of(context)!.settings.arguments)
          as Map<String, dynamic>)['day'] as Day;
      workoutId = ((ModalRoute.of(context)!.settings.arguments)
          as Map<String, dynamic>)['workoutId'] as String;

      dayId = ((ModalRoute.of(context)!.settings.arguments)
          as Map<String, dynamic>)['dayId'] as String;
      exercises = [...day.exercises];
      dayTitle = day.title;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void addExerciseHandler(dayTitle) async {
    var exercise = await Navigator.pushNamed(
      context,
      AddExerciseScreen.route,
    );

    if (exercise != null) {
      setState(() {
        exercises.add(exercise as Exercise);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: TextFormField(
            initialValue: day.title,
            onSaved: (newValue) {
              dayTitle = newValue;
            },
            textInputAction: TextInputAction.newline,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please provide a title.';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
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
                  _saveForm();
                  // Navigator.pop(context, _newDay);
                },
              ),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : EditableExercisesList(
                exercises: exercises,
                dayTitle: day.title,
                addExerciseHandler: addExerciseHandler,
              ),
      ),
    );
  }
}
