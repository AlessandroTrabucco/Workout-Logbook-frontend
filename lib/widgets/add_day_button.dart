import 'package:flutter/material.dart';

class AddDayButton extends StatelessWidget {
  const AddDayButton({
    Key? key,
    required this.addDayHandler,
  }) : super(key: key);
  final addDayHandler;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: addDayHandler,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(171, 180, 211, 246),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromARGB(171, 38, 139, 255),
            width: 0.1,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Text(
            '+',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
