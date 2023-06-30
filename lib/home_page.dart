import 'package:flutter/material.dart';

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
            color: Color(0xFF2D3945), // Set the background color to red
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
