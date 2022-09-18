import 'package:flutter/material.dart';

import '../widgets/bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  final List<Widget> pageOptions;
  final int selectedPage;
  final Function onItemTapped;
  static const route = '/main';
  const MainScreen({
    Key? key,
    required this.pageOptions,
    required this.selectedPage,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var isOnItemTapped;
  var init = true;

  @override
  void didChangeDependencies() {
    if (init) {
      isOnItemTapped = ModalRoute.of(context)!.settings.arguments;
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      body: isOnItemTapped == true
          ? widget.pageOptions[0]
          : widget.pageOptions[widget.selectedPage],
      bottomNavigationBar: BottomNavBar(
        onItemTapped: widget.onItemTapped,
        selectedPage: isOnItemTapped == true ? 0 : widget.selectedPage,
      ),
    );

    isOnItemTapped = false;

    return scaffold;
  }
}
