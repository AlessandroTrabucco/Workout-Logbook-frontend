import 'package:flutter/material.dart';

import '../widgets/overview_header.dart';
import '../widgets/overview_main.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Column(
            children: [
              OverviewHeader(
                key: key,
              ),
              const SizedBox(
                height: 18,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 40, top: 20),
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Text(
                    'Statistiche settimanali',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              OverviewMain(
                key: key,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
