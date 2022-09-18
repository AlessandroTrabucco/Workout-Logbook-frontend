import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final selectedPage;
  final onItemTapped;
  const BottomNavBar({
    Key? key,
    required this.selectedPage,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'workouts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      currentIndex: selectedPage,
      selectedItemColor: Colors.black,
      onTap: onItemTapped,
    );
  }
}
