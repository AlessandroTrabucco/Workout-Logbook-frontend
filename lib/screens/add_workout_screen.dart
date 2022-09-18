import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gym_app_fixed/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../providers/workout.dart';
import '../widgets/day_grid_tile.dart';
import '../providers/workouts.dart';
import '../widgets/add_day_button.dart';
import './add_day_screen.dart';
import '../providers/day.dart';

class AddWorkoutScreen extends StatefulWidget {
  static const route = '/add-workout';
  const AddWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  var _startDate = DateTime.now();
  var _endDate = DateTime.now();
  List<Day> days = [];
  final _form = GlobalKey<FormState>();
  var _newWorkout = Workout(
    id: '',
    title: '',
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    days: [],
  );
  bool _isLoading = false;

  void _saveForm() async {
    final navigator = Navigator.of(context);
    final isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Workouts>(context, listen: false).addWorkout(
        _newWorkout,
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

  void _showDatePicker({ctx, startDate, endDate}) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Container(
        height: 500,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 400,
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (val) {
                      setState(() {
                        if (startDate) {
                          _startDate = val;
                          _newWorkout = Workout(
                            id: _newWorkout.id,
                            title: _newWorkout.title,
                            startDate: _startDate,
                            endDate: _newWorkout.endDate,
                            days: _newWorkout.days,
                          );
                        } else if (endDate) {
                          _endDate = val;
                          _newWorkout = Workout(
                            id: _newWorkout.id,
                            title: _newWorkout.title,
                            startDate: _newWorkout.startDate,
                            endDate: _endDate,
                            days: _newWorkout.days,
                          );
                        }
                      });
                    }),
              ),
            ),
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      ),
    );
  }

  void addDayHandler() async {
    var day = await Navigator.pushNamed(context, AddDayScreen.route);
    if (day != null) {
      setState(() {
        days.add(day as Day);
      });
    }

    _newWorkout = Workout(
      id: _newWorkout.id,
      title: _newWorkout.title,
      startDate: _newWorkout.startDate,
      endDate: _newWorkout.endDate,
      days: days,
    );
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
            onSaved: (newValue) {
              _newWorkout = Workout(
                id: _newWorkout.id,
                title: newValue ?? '',
                startDate: _newWorkout.startDate,
                endDate: _newWorkout.endDate,
                days: _newWorkout.days,
              );
            },
            textInputAction: TextInputAction.newline,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please provide a title.';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              hintText: 'Workout name',
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
                  // Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 30, top: 30, right: 30, bottom: 20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Start Date',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              _showDatePicker(
                                ctx: context,
                                startDate: true,
                                endDate: false,
                              );
                            },
                            child: Text(
                              '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'End Date',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              _showDatePicker(
                                ctx: context,
                                startDate: false,
                                endDate: true,
                              );
                            },
                            child: Text(
                              '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 30, bottom: 20),
                      child: const Text(
                        'Days',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30, bottom: 15, top: 0),
                        child: GridView.builder(
                            itemCount: days.length + 1,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 145,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 20),
                            itemBuilder: (BuildContext ctx, index) {
                              return index == days.length
                                  ? AddDayButton(
                                      addDayHandler: addDayHandler,
                                    )
                                  : DayGridTile(
                                      notClickable: false,
                                      day: Day(
                                        workoutCount: days[index].workoutCount,
                                        exercises: days[index].exercises,
                                        title: days[index].title,
                                        exerciseIndex:
                                            days[index].exerciseIndex,
                                      ),
                                    );
                            }),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
