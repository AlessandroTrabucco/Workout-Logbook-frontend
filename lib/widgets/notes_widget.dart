import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exercise.dart';
import '../providers/workouts.dart';

class NotesWidget extends StatefulWidget {
  final Exercise exercise;
  final String workoutId;
  final int exerciseIndex;
  final int workoutCount;

  const NotesWidget({
    Key? key,
    required this.exercise,
    required this.workoutId,
    required this.exerciseIndex,
    required this.workoutCount,
  }) : super(key: key);

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  var noteIndex;
  var _exerciseIndex;
  var _isInit = true;
  var onChanged = false;
  var workoutCount;
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  var controller = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      workoutCount = widget.exercise.record.length;
      noteIndex = workoutCount;
      _exerciseIndex = widget.exerciseIndex;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseIndex != widget.exerciseIndex) {
      // print('cambio es');
      _isInit = true;
      didChangeDependencies();
      controller = TextEditingController();
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      // height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              if (mounted) {
                setState(() {
                  if (noteIndex > 0) noteIndex--;
                });
              }
            },
          ),
          Expanded(
            child: SizedBox(
              height: 120,
              width: 300,
              child: noteIndex == workoutCount
                  ? Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.topLeft,
                      child: TextFormField(
                        controller: controller,
                        textInputAction: TextInputAction.done,
                        onSaved: ((value) {
                          Provider.of<Workouts>(context, listen: false)
                              .updateRecord(value);
                        }),
                        onChanged: ((value) {
                          onChanged = true;
                          Provider.of<Workouts>(context, listen: false)
                              .updateRecord(value);
                        }),
                        maxLines: 4,
                        maxLength: 120,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: Text(
                        widget.exercise.record[noteIndex],
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ),
          noteIndex == workoutCount
              ? IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(null),
                  onPressed: () {},
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                  onPressed: () {
                    setState(() {
                      if (noteIndex <= workoutCount) noteIndex++;
                    });
                  },
                ),
        ],
      ),
    );
  }
}
