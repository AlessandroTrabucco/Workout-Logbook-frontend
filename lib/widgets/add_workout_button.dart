import 'package:flutter/material.dart';

import '../screens/add_workout_screen.dart';

class AddWorkoutButton extends StatelessWidget {
  const AddWorkoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: Colors.black38,
              width: 0.3,
            ),
          ),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.all(30.0)),
        alignment: Alignment.center,
      ),
      onPressed: () => Navigator.of(context).pushNamed(AddWorkoutScreen.route),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
