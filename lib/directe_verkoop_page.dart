import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class DirecteVerkoopPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Directe Verkoop Page'),
//       ),
//       body: Center(
//         child: Text(
//           'Directe Verkoop',
//           style: TextStyle(fontSize: 24.0),
//         ),
//       ),
//     );
//   }
// }

class DirecteVerkoopPage extends StatelessWidget {
  const DirecteVerkoopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: CupertinoTabBarExample(),
    );
  }
}

class CupertinoTabBarExample extends StatelessWidget {
  const CupertinoTabBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar_alt_fill),
            label: 'Statistieken',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_bar),
            label: 'Bestellen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check),
            label: 'Bestelling',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Instellingen',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return Center(
              child: Text('Content of tab $index'),
            );
          },
        );
      },
    );
  }
}

