import 'package:flutter/material.dart';

class OverviewMain extends StatelessWidget {
  const OverviewMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              height: double.infinity,
              margin: const EdgeInsets.only(
                left: 40,
                right: 15,
              ),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(207, 236, 246, 1.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Align(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // Text('✅', style: TextStyle(fontSize: 27)),
                  Text(
                    '5 Workout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ),
          ),
          Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 40),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(237, 245, 225, 1.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // const Text('🏋️', style: TextStyle(fontSize: 27)),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('25',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text('total sets',
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(right: 40),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(242, 241, 241, 1.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // const Text('⏳', style: TextStyle(fontSize: 27)),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('7h',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text('total time',
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
