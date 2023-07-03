import 'package:flutter/material.dart';
import 'directe_verkoop_page.dart';
import 'logo_page.dart';
import 'settings_page.dart';

void main() {
  runApp(KassaKameraad());
}

class KassaKameraad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KassaKameraad',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DirecteVerkoopPage(),
      routes: {
        '/logo': (context) => LogoPage(),
        '/directe_verkoop': (context) => DirecteVerkoopPage(),
        '/settings_page': (context) => SettingsPage(),
      },
    );
  }
}
