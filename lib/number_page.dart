import 'package:flutter/material.dart';

class NumberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final number = args['number'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Number Page'),
      ),
      body: Center(
        child: Text(
          'Number: ${number.toString()}',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
