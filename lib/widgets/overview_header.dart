import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

class OverviewHeader extends StatefulWidget {
  const OverviewHeader({Key? key}) : super(key: key);

  @override
  State<OverviewHeader> createState() => _OverviewHeaderState();
}

class _OverviewHeaderState extends State<OverviewHeader> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ciao,',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
