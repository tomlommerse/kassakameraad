import 'package:flutter/material.dart';

class DirecteVerkoopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directe Verkoop Page'),
      ),
      body: Center(
        child: Text(
          'Directe Verkoop',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
