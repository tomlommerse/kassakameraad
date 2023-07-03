import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavigation({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Color(0xFF2D3945),
      unselectedItemColor: Color(0xFFaaaaaa),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.stacked_bar_chart_outlined),
          label: 'Statistics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_drink),
          label: 'Direct sales',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
