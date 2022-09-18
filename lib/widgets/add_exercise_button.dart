import 'package:flutter/material.dart';

class AddExerciseButton extends StatelessWidget {
  const AddExerciseButton({
    required this.addExerciseHandler,
    required this.dayTitle,
    Key? key,
  }) : super(key: key);

  final addExerciseHandler;
  final dayTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        addExerciseHandler(dayTitle);
      }),
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 200,
        decoration: BoxDecoration(
            border: Border.all(width: 0.2, color: Colors.black38),
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.only(left: 30, top: 15),
        width: double.infinity,
        child: const Icon(Icons.add, size: 37),
      ),
    );
  }
}
