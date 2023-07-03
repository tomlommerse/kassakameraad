import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'bottom_navigation.dart';
import 'helpers/db_helper.dart';

class DirecteVerkoopPage extends StatefulWidget {
  @override
  _DirecteVerkoopPageState createState() => _DirecteVerkoopPageState();
}

class _DirecteVerkoopPageState extends State<DirecteVerkoopPage> {
  static const Color primaryColor = Color(0xFF2D3945);
  static const Color cancelButtonColor = Color(0xFFff0000);

  static const TextStyle headingTextStyle =
      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  static const TextStyle productTextStyle = TextStyle(fontSize: 16.0);

  Map<String, double> products = {};
  Map<String, int> selectedProducts = {};

  ShakeDetector? detector;

  @override
  void initState() {
    super.initState();
    fetchProducts();

    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        showDeletePopup();
      },
    );
    detector?.startListening();
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }

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
          content:
              Text('Total Price: €${calculateTotalPrice().toStringAsFixed(2)}'),
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
              onPressed: () async {
                final totalPrice = calculateTotalPrice();
                await DBHelper.completeOrder(totalPrice);

                setState(() {
                  selectedProducts.clear();
                });

                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(primaryColor),
              ),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void showDeletePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Clear all products?'),
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
                // Perform delete operation
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(primaryColor),
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchProducts() async {
    final productList = await DBHelper.getProducts();

    setState(() {
      products = Map.fromIterable(
        productList,
        key: (product) => product['name'],
        value: (product) => product['price'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Direct sales'),
        automaticallyImplyLeading: false,
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
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
                Text('Total €${calculateTotalPrice().toStringAsFixed(2)}'),
                ElevatedButton(
                  onPressed: () {
                    pay();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                  ),
                  child: Text('Pay'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/logo');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/settings_page');
          }
        },
      ),
    );
  }
}
