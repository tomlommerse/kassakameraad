import 'package:flutter/material.dart';

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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5D7791),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/logo');
              },
              child: Text('Logo'),
            ),
          ],
        ),
        actions: [
          Container(
            color: Colors.red, // Set the background color to red
            child: Row(
              children: [
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/directe_verkoop');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      child: Text('Directe Verkoop'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        children: List.generate(21, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/number_page',
                arguments: {'number': index + 1},
              );
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              color: Color(0xFFD9D9D9),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

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
