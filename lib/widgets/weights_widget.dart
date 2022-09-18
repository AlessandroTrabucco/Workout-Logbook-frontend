import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exercise.dart';
import '../providers/workouts.dart';

class WeightsWidget extends StatefulWidget {
  final Exercise exercise;
  final String workoutId;

  final int exerciseIndex;
  final int workoutCount;

  const WeightsWidget({
    Key? key,
    required this.exercise,
    required this.workoutId,
    required this.exerciseIndex,
    required this.workoutCount,
  }) : super(key: key);

  @override
  State<WeightsWidget> createState() => _WeightsWidgetState();
}

class _WeightsWidgetState extends State<WeightsWidget> {
  var weightIndex;
  var _exerciseIndex;
  var _isInit = true;
  var onChanged = false;
  var workoutCount;
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  var _controllerList;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      workoutCount = widget.exercise.weights.length;
      weightIndex = workoutCount;
      _exerciseIndex = widget.exerciseIndex;

      _controllerList = List.generate(
        widget.exercise.sets,
        (index) => TextEditingController(),
      );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_exerciseIndex != widget.exerciseIndex) {
      // print('cambio es');
      _isInit = true;
      didChangeDependencies();
      _controllerList.forEach(
        (controller) => controller.text = '',
      );
    }
    if (Provider.of<Workouts>(context, listen: false).weights.isEmpty) {
      Provider.of<Workouts>(context, listen: false).weights =
          List.generate(widget.exercise.sets, (index) => 0);
    }

    if (_controllerList.length != widget.exercise.sets ||
        Provider.of<Workouts>(context, listen: false).weights.length !=
            widget.exercise.sets) {
      _controllerList = List.generate(
        widget.exercise.sets,
        (index) => TextEditingController(),
      );
      Provider.of<Workouts>(context, listen: false).weights =
          List.generate(widget.exercise.sets, (index) => 0);
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
                  if (weightIndex > 0) weightIndex--;
                });
              }
            },
          ),
          Expanded(
            child: SizedBox(
              height: 65,
              child: ListView.builder(
                itemCount: weightIndex == workoutCount
                    ? widget.exercise.sets
                    : widget.exercise.weights[weightIndex].length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, idx) {
                  return weightIndex == workoutCount
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          width: 58,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 20),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            controller: _controllerList[idx],
                            onSaved: ((value) {
                              double weight;
                              try {
                                weight =
                                    double.parse(value!.replaceAll(',', '.'));
                              } catch (err) {
                                weight = 0;
                              }
                              Provider.of<Workouts>(context, listen: false)
                                  .updateWeights(idx, weight);
                            }),
                            onChanged: ((value) {
                              double weight;
                              try {
                                weight =
                                    double.parse(value.replaceAll(',', '.'));
                              } catch (err) {
                                weight = 0;
                              }
                              Provider.of<Workouts>(context, listen: false)
                                  .updateWeights(idx, weight);
                              onChanged = true;
                            }),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
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
                          width: 58,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 20),
                          child: Text(
                            widget.exercise.weights[weightIndex][idx]
                                .toString()
                                .replaceAll(regex, ''),
                            textAlign: TextAlign.center,
                          ),
                        );
                },
              ),
            ),
          ),
          weightIndex == workoutCount
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
                      if (weightIndex <= workoutCount) weightIndex++;
                    });
                  },
                ),
        ],
      ),
    );
  }
}
