import 'package:flutter/material.dart';

import '../providers/exercise.dart';

class AddExerciseScreen extends StatefulWidget {
  static const route = '/add-exercise';
  const AddExerciseScreen({Key? key}) : super(key: key);

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _form = GlobalKey<FormState>();
  var _newExercise = Exercise(
    title: '',
    reps: '',
    sets: 0,
    rest: 0,
    note: '',
    weights: [],
    record: [],
  );

  bool _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) return false;
    _form.currentState!.save();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Create Exercise',
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _form,
        child: SafeArea(
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(30),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
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
                        ),
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
                    const Text(
                      'Reps',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
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
                    const Text(
                      'Sets',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
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
                    const Text(
                      'Rest',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
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
                    const Text(
                      'Note',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
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
                  onPressed: () {
                    if (_saveForm()) Navigator.pop(context, _newExercise);
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
                  child: const Text('Add Exercise'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
