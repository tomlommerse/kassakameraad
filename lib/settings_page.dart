import 'package:flutter/material.dart';
import 'bottom_navigation.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Center(
        child: Text(
          'Settings',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/logo');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/directe_verkoop');
          }
        },
      ),
    );
  }
}
