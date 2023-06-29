import 'package:flutter/material.dart';

class LogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logo Page'),
      ),
      body: Center(
        child: Text(
          'Logo',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
