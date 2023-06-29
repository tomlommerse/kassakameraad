import 'package:flutter/material.dart';
import 'home_page.dart';
import 'logo_page.dart';
import 'directe_verkoop_page.dart';
import 'number_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/logo': (context) => LogoPage(),
        '/directe_verkoop': (context) => DirecteVerkoopPage(),
        '/number_page': (context) => NumberPage(),
      },
    );
  }
}