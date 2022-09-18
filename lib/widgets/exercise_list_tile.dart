import 'package:flutter/material.dart';

import '../providers/exercise.dart';

class ExerciseListTile extends StatelessWidget {
  const ExerciseListTile({
    Key? key,
    required this.exercise,
    required this.deleteExerciseHandler,
  }) : super(key: key);

  final Exercise exercise;
  final deleteExerciseHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 0.2, color: Colors.black38),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.only(left: 30, top: 15),
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                exercise.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(right: 7, left: 5),
                child: deleteExerciseHandler == null
                    ? Container()
                    : IconButton(
                        onPressed: () async {
                          deleteExerciseHandler(exercise.id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )))
          ],
        ),
        Container(
          padding: const EdgeInsets.only(top: 15),
          width: double.infinity,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 120),
                  child: const Text('REPS: ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      )),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      exercise.reps,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ]),
        ),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 15),
                child: Column(children: [
                  const Text(
                    'Serie',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.grey),
                  ),
                  Text('${exercise.sets}'),
                ]),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(children: [
                const Text(
                  'Recupero',
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.grey),
                ),
                Text('${exercise.rest}'),
              ]),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20, top: 5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Note: ',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.grey)),
                SizedBox(width: 280, child: Text(exercise.note))
              ]),
        )
      ]),
    );
  }
}
