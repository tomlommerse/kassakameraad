import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'helpers/db_helper.dart';

class DirecteVerkoopPage extends StatefulWidget {
  @override
  _DirecteVerkoopPageState createState() => _DirecteVerkoopPageState();
}

class _DirecteVerkoopPageState extends State<DirecteVerkoopPage> {
  static const Color primaryColor = Color(0xFF2D3945);
  static const Color cancelButtonColor = Color(0xFFff0000);

  static const TextStyle headingTextStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  static const TextStyle productTextStyle = TextStyle(fontSize: 16.0);

  // Map<String, double> products = {
  //   'Bier': 2.5,
  //   'Droge witte wijn': 3.0,
  //   'zoete witte wijn': 1.75,
  //   'rode wijn': 2.0,
  //   'baco': 3.5,
  //   'cola': 2.0,
  // };

  var db = mainDB();
  

  Map<String, int> selectedProducts = {};

  void selectProduct(String product) {
    setState(() {
      selectedProducts[product] = (selectedProducts[product] ?? 0) + 1;
    });
  }

  void removeProduct(String product) {
    setState(() {
      if (selectedProducts[product]! > 1) {
        selectedProducts[product] = selectedProducts[product]! - 1;
      } else {
        selectedProducts.remove(product);
      }
    });
  }

  double calculateTotalPrice() {
    return selectedProducts.entries.fold(
      0.0,
      (total, entry) => total + (products[entry.key]! * entry.value),
    );
  }

  void pay() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Confirmation'),
          content: Text('Total Price: €${calculateTotalPrice().toStringAsFixed(2)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: cancelButtonColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedProducts.clear();
                });
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
              ),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Directe Verkoop Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Products',
              style: headingTextStyle,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3.0,
              padding: EdgeInsets.all(16.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: products.keys.map((product) {
                return ElevatedButton(
                  onPressed: () {
                    selectProduct(product);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                  ),
                  child: Text(
                    product,
                    style: productTextStyle,
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Ordered Products',
              style: headingTextStyle,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: selectedProducts.length,
              itemBuilder: (context, index) {
                final product = selectedProducts.keys.elementAt(index);
                final quantity = selectedProducts[product];
                final price = products[product]!;

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product),
                      Text('Price: €${price.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          removeProduct(product);
                        },
                      ),
                      Text('Qty: $quantity'),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Price: €${calculateTotalPrice().toStringAsFixed(2)}'),
                ElevatedButton(
                  onPressed: () {
                    pay();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                  ),
                  child: Text('Pay'),
                ),
              ],
            ),
          ),
        ],
      ),
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

