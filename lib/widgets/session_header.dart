import 'package:flutter/material.dart';

class SessionHeader extends StatelessWidget {
  final nextExercise, exerciseIndex, exercisesLength;
  const SessionHeader({
    Key? key,
    required this.nextExercise,
    required this.exerciseIndex,
    required this.exercisesLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          child: Text(
            'Esercizio ${exerciseIndex + 1}',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            onPressed: (nextExercise),
            child: Text(
                exerciseIndex == exercisesLength - 1
                    ? 'End workout'
                    : 'Next Exercise',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
