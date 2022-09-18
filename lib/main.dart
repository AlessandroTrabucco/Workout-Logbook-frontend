import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_app_fixed/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './screens/overview_screen.dart';
import './screens/workouts_screen.dart';
import './screens/workout_screen.dart';
import './screens/exercises_screen.dart';
import './screens/session_screen.dart';
import './screens/timer_screen.dart';
import './screens/edit_exercises_screen.dart';
import './screens/add_day_screen.dart';
import './screens/add_exercise_screen.dart';
import './screens/add_workout_screen.dart';
import './providers/workouts.dart';
import './providers/user.dart';
import './screens/main_screen.dart';
import './screens/logout_screen.dart';
import './jwt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedPage = 0;
  final _pageOptions = [
    const OverviewScreen(),
    const WorkoutsScreen(),
    const LogoutScreen(),
  ];
  final storage = const FlutterSecureStorage();

  void _onItemTapped(int selectedPage) {
    setState(() {
      _selectedPage = selectedPage;
    });
  }

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: 'jwt');
    if (jwt == null) return '';
    try {
      await Workouts.isValidToken(jwt);
      return jwt;
    } catch (err) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ListenableProvider<Workouts>(create: (_) => Workouts()),
          ListenableProvider<User>(create: (_) => User()),
        ],
        child: MaterialApp(
          title: 'GymApp',
          theme: ThemeData(
            fontFamily: 'Montserrat',
          ),
          home: FutureBuilder(
            future: jwtOrEmpty,
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
              if (snapshot.data != '') {
                final parts = (snapshot.data as String).split('.');

                var payload = json.decode(decodeBase64(parts[1]));
                final name = payload['name'];
                final imageUrl = payload['imageUrl'];
                Provider.of<User>(context).setName(name);
                Provider.of<User>(context).setImageUrl(imageUrl);
                return MainScreen(
                  onItemTapped: (_selectedPage) => _onItemTapped(_selectedPage),
                  selectedPage: _selectedPage,
                  pageOptions: _pageOptions,
                );
              } else {
                return const LoginScreen();
              }
            }),
          ),
          routes: {
            MainScreen.route: (ctx) => MainScreen(
                  onItemTapped: (_selectedPage) => _onItemTapped(_selectedPage),
                  selectedPage: _selectedPage,
                  pageOptions: _pageOptions,
                ),
            LoginScreen.route: (ctx) => const LoginScreen(),
            WorkoutScreen.route: (ctx) => const WorkoutScreen(),
            ExercisesScreen.route: (ctx) => const ExercisesScreen(),
            SessionScreen.route: (ctx) => const SessionScreen(),
            TimerScreen.route: (ctx) => const TimerScreen(),
            EditExercisesScreen.route: (ctx) => const EditExercisesScreen(),
            AddDayScreen.route: (ctx) => const AddDayScreen(),
            AddExerciseScreen.route: (ctx) => const AddExerciseScreen(),
            AddWorkoutScreen.route: (ctx) => const AddWorkoutScreen(),
          },
        ));
  }
}
