import 'package:flutter/material.dart';
import 'bottom_navigation.dart';

class LogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logo Page'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Center(
        child: Text(
          'Logo',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/directe_verkoop');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/settings_page');
          }
        },
      ),
    );
  }
}
