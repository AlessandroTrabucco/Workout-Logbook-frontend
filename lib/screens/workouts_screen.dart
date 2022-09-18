import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../providers/workouts.dart';
import '../widgets/workouts_grid.dart';
import 'login_screen.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  var _isInit = true;
  var _isLoading = false;

  deleteWorkoutHandler(workoutId) async {
    final navigator = Navigator.of(context);
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Workouts>(context, listen: false)
          .deleteWorkout(workoutId);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      if (err.toString() == 'Logout') {
        const storage = FlutterSecureStorage();
        await storage.delete(key: 'jwt');
        navigator.pushNamedAndRemoveUntil(
            LoginScreen.route, (Route<dynamic> route) => false);
        return Future(() => null);
      }
      setState(() {
        _isLoading = false;
      });
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(err.toString()),
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
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<Workouts>(context).fetchAndSetWorkouts();
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        if (e.toString() == 'Logout') {
          final navigator = Navigator.of(context);
          const storage = FlutterSecureStorage();
          await storage.delete(key: 'jwt');
          navigator.pushReplacementNamed(LoginScreen.route);
          return Future((() => null));
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
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: const Text(
                'I tuoi workout',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: _isLoading
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : WorkoutsGrid(
                        deleteWorkoutHandler: (workoutId) =>
                            deleteWorkoutHandler(workoutId)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
