import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import './day_grid_tile.dart';
import '../providers/workouts.dart';
import './add_day_button.dart';
import '../providers/day.dart';
import '../screens/add_day_screen.dart';

class DaysGrid extends StatefulWidget {
  const DaysGrid({
    Key? key,
    required this.workoutId,
  }) : super(key: key);

  final String workoutId;

  @override
  State<DaysGrid> createState() => _DaysGridState();
}

class _DaysGridState extends State<DaysGrid> {
  void addDayHandler() async {
    final navigator = Navigator.of(context);
    final provider = Provider.of<Workouts>(context, listen: false);
    var day = await Navigator.pushNamed(context, AddDayScreen.route);

    if (day != null) {
      try {
        await provider.addDay(
          day as Day,
          widget.workoutId,
        );
      } catch (err) {
        if (err.toString() == 'Logout') {
          const storage = FlutterSecureStorage();
          await storage.delete(key: 'jwt');
          navigator.pushNamedAndRemoveUntil(
              LoginScreen.route, (Route<dynamic> route) => false);
          return Future(() => null);
        }
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: Text(err.toString()),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = Provider.of<Workouts>(context).days(widget.workoutId);
    return GridView.builder(
        itemCount: days.length + 1,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 160,
            childAspectRatio: 6 / 5.5,
            crossAxisSpacing: 15,
            mainAxisSpacing: 20),
        itemBuilder: (BuildContext ctx, index) {
          return index == days.length
              ? AddDayButton(
                  addDayHandler: addDayHandler,
                )
              : DayGridTile(
                  workoutId: widget.workoutId,
                  dayId: days[index].id,
                  day: days[index],
                );
        });
  }
}
