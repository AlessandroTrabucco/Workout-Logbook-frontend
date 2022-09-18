import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './workout.dart';
import '../models/http_exception.dart';
import '../models/token_expired_exception.dart';
import './day.dart';

isTokenExpired(response) {
  if (response.statusCode == 401 &&
      json.decode(response.body)['message'] == 'Not authenticated') {
    throw TokenExpiredException('Logout');
  }
}

class Workouts extends ChangeNotifier {
  List<Workout> _workouts = [];

  String record = '';

  List<double> weights = [];

  List<Workout> get workouts => [..._workouts];

  List<Day> days(workoutId) => findById(workoutId).days;

  Day day(workoutId, dayIndex) {
    return findById(workoutId).days[dayIndex];
  }

  Workout findById(workoutId) {
    return _workouts.firstWhere((workout) => workout.id == workoutId);
  }

  Day findDayById(workoutId, dayId) {
    return findById(workoutId).days.firstWhere((day) => day.id == dayId);
  }

  deleteExercise(String workoutId, String dayId, String exerciseId) async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    final workoutIndex =
        _workouts.indexWhere((workout) => workout.id == workoutId);

    final url = Uri.http(
      'localhost:3000',
      '/workout/exercise/$workoutId',
      {
        'day': dayId,
        'exercise': exerciseId,
      },
    );

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
    );

    isTokenExpired(response);

    if (response.statusCode != 200) {
      throw HttpException(json.decode(response.body)['message']);
    }

    final workout = json.decode(response.body)['workout'];

    var daysJson = workout['days'] as List;
    List<Day> days = daysJson.map((day) => Day.fromJson(day)).toList();

    _workouts[workoutIndex] = Workout(
      id: workout['_id'],
      title: workout['title'],
      startDate: DateTime.parse(workout['startDate']),
      endDate: DateTime.parse(workout['endDate']),
      days: days,
    );

    notifyListeners();
  }

  deleteDay(String workoutId, String dayId) async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    final workoutIndex =
        _workouts.indexWhere((workout) => workout.id == workoutId);

    final url = Uri.http(
      'localhost:3000',
      '/workout/day/$workoutId',
      {
        'day': dayId,
      },
    );

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
    );

    isTokenExpired(response);

    if (response.statusCode != 200) {
      throw HttpException(json.decode(response.body)['message']);
    }

    final workout = json.decode(response.body)['workout'];

    var daysJson = workout['days'] as List;
    List<Day> days = daysJson.map((day) => Day.fromJson(day)).toList();

    _workouts[workoutIndex] = Workout(
      id: workout['_id'],
      title: workout['title'],
      startDate: DateTime.parse(workout['startDate']),
      endDate: DateTime.parse(workout['endDate']),
      days: days,
    );

    notifyListeners();
  }

  deleteWorkout(String workoutId) async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    final workoutIndex =
        _workouts.indexWhere((workout) => workout.id == workoutId);

    final url = Uri.http(
      'localhost:3000',
      '/workout/$workoutId',
    );

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
    );

    isTokenExpired(response);

    if (response.statusCode != 200) {
      throw HttpException(json.decode(response.body)['message']);
    }

    _workouts.removeAt(workoutIndex);

    notifyListeners();
  }

  addWorkout(Workout workout) async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    final url = Uri.http(
      'localhost:3000',
      '/workout',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: json.encode(
          {
            'title': workout.title,
            'startDate': DateTime(
              workout.startDate.year,
              workout.startDate.month,
              workout.startDate.day,
            ).toIso8601String(),
            'endDate': DateTime(
              workout.endDate.year,
              workout.endDate.month,
              workout.endDate.day,
            ).toIso8601String(),
            'days': workout.days.map((day) => day.toJson()).toList(),
          },
        ),
      );

      isTokenExpired(response);

      if (response.statusCode != 201) {
        throw HttpException(json.decode(response.body)['message']);
      }

      final createdWorkout = json.decode(response.body)['workout'];

      final newWorkout = Workout(
        id: createdWorkout['_id'],
        title: createdWorkout['title'],
        startDate: DateTime.parse(createdWorkout['startDate']),
        endDate: DateTime.parse(createdWorkout['endDate']),
        days: ((createdWorkout['days']) as List)
            .map((day) => Day.fromJson(day))
            .toList(),
      );

      _workouts.add(newWorkout);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  static isValidToken(String jwt) async {
    final url = Uri.http(
      'localhost:3000',
      '/workouts',
    );

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $jwt',
      });
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  fetchAndSetWorkouts() async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    final url = Uri.http(
      'localhost:3000',
      '/workouts',
    );

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $jwt',
      });

      isTokenExpired(response);
      if (response.statusCode != 200) {
        throw HttpException(json.decode(response.body)['message']);
      }
      var extractedData = json.decode(response.body)['workouts'];

      final List<Workout> loadedWorkouts = [];

      if (extractedData != null) {
        extractedData = extractedData as List<dynamic>;
        for (var workout in extractedData) {
          var daysJson = workout['days'] as List;
          List<Day> days = daysJson.map((day) => Day.fromJson(day)).toList();
          loadedWorkouts.add(
            Workout(
              id: workout['_id'],
              title: workout['title'],
              startDate: DateTime.parse(workout['startDate']),
              endDate: DateTime.parse(workout['endDate']),
              days: days,
            ),
          );
        }
      }

      _workouts = loadedWorkouts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  addDay(Day day, workoutId) async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    final workoutIndex =
        _workouts.indexWhere((workout) => workout.id == workoutId);

    final url = Uri.http(
      'localhost:3000',
      '/workout/$workoutId',
    );

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: json.encode({
        'day': day.toJson(),
      }),
    );

    isTokenExpired(response);

    if (response.statusCode != 200) {
      throw HttpException(json.decode(response.body)['message']);
    }

    final workout = json.decode(response.body)['workout'];

    var daysJson = workout['days'] as List;
    List<Day> days = daysJson.map((day) => Day.fromJson(day)).toList();

    _workouts[workoutIndex] = Workout(
      id: workout['_id'],
      title: workout['title'],
      startDate: DateTime.parse(workout['startDate']),
      endDate: DateTime.parse(workout['endDate']),
      days: days,
    );

    notifyListeners();
  }

  updateDay(workoutId, dayId, dayTitle, exercises) async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    final workoutIndex =
        _workouts.indexWhere((workout) => workout.id == workoutId);

    final url =
        Uri.http('localhost:3000', '/workout/$workoutId', {'day': dayId});

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: json.encode({
        'title': dayTitle,
        'exercises': exercises.map((ex) => ex.toJson()).toList(),
      }),
    );

    isTokenExpired(response);
    if (response.statusCode != 200) {
      throw HttpException(json.decode(response.body)['message']);
    }

    final workout = json.decode(response.body)['workout'];

    var daysJson = workout['days'] as List;
    List<Day> days = daysJson.map((day) => Day.fromJson(day)).toList();

    _workouts[workoutIndex] = Workout(
      id: workout['_id'],
      title: workout['title'],
      startDate: DateTime.parse(workout['startDate']),
      endDate: DateTime.parse(workout['endDate']),
      days: days,
    );

    notifyListeners();
  }

  updateRecord(record) {
    this.record = record;
  }

  updateWeights(int idx, double weight) {
    weights[idx] = weight;
  }

  updateExerciseSession(workoutId, dayId, exerciseId) async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    final workoutIndex =
        _workouts.indexWhere((workout) => workout.id == workoutId);
    final url =
        Uri.http('localhost:3000', '/workout/exerciseSession/$workoutId', {
      'day': dayId,
      'exercise': exerciseId,
    });

    final response = await http.patch(url,
        body: json.encode(
          {
            'record': record,
            'weights': weights,
          },
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        });
    weights = [];

    isTokenExpired(response);
    if (response.statusCode != 200) {
      throw HttpException(json.decode(response.body)['message']);
    }

    final workout = json.decode(response.body)['workout'];

    var daysJson = workout['days'] as List;
    List<Day> days = daysJson.map((day) => Day.fromJson(day)).toList();

    _workouts[workoutIndex] = Workout(
      id: workout['_id'],
      title: workout['title'],
      startDate: DateTime.parse(workout['startDate']),
      endDate: DateTime.parse(workout['endDate']),
      days: days,
    );

    notifyListeners();

    return _workouts[workoutIndex]
        .days
        .firstWhere((element) => element.id == dayId)
        .exerciseIndex;
  }

  updateExerciseIndex(workoutId, dayId) async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    final workoutIndex =
        _workouts.indexWhere((workout) => workout.id == workoutId);
    final url =
        Uri.http('localhost:3000', '/workout/exerciseIndex/$workoutId', {
      'day': dayId,
    });

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );

    isTokenExpired(response);
    if (response.statusCode != 200) {
      throw HttpException(json.decode(response.body)['message']);
    }

    final workout = json.decode(response.body)['workout'];

    var daysJson = workout['days'] as List;
    List<Day> days = daysJson.map((day) => Day.fromJson(day)).toList();

    _workouts[workoutIndex] = Workout(
      id: workout['_id'],
      title: workout['title'],
      startDate: DateTime.parse(workout['startDate']),
      endDate: DateTime.parse(workout['endDate']),
      days: days,
    );

    notifyListeners();

    return _workouts[workoutIndex]
        .days
        .firstWhere((element) => element.id == dayId)
        .exerciseIndex;
  }
}
