import 'package:flutter/material.dart';
import 'bottom_navigation.dart';
import 'helpers/db_helper.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  List<Map<String, dynamic>> productList = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final products = await DBHelper.getProducts();
    setState(() {
      productList = products;
    });
  }

  void addProduct() async {
    final String name = _productNameController.text.trim();
    final double price = double.tryParse(_productPriceController.text.trim()) ?? 0.0;

    if (name.isNotEmpty && price > 0) {
      await DBHelper.insertProduct(name, price);
      _productNameController.clear();
      _productPriceController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added successfully.'),
        ),
      );
      fetchProducts(); // Update the product list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid product details.'),
        ),
      );
    }
  }

  void removeProduct(String productName) async {
    await DBHelper.deleteProduct(productName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product removed successfully.'),
      ),
    );
    fetchProducts(); // Update the product list
  }

  @override
  Widget build(BuildContext context) {
    // Detect the current orientation
    Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      return _buildPortraitLayout();
    } else {
      return _buildLandscapeLayout();
    }
  }

  Widget _buildPortraitLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2D3945),
        title: Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Add or Edit Product',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _productPriceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addProduct,
              child: Text('Add'),
            ),
            SizedBox(height: 24.0),
            Text(
              'Remove Product',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: productList.map((product) {
                  final String productName = product['name'];
                  final double productPrice = product['price'];

                  return ListTile(
                    title: Text(productName),
                    subtitle: Text('Price: €${productPrice.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeProduct(productName);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Navigator.pushNamed(context, '/logo');
          } else if (index == 1) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Navigator.pushNamed(context, '/directe_verkoop');
          }
        },
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2D3945),
        title: Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Add or Edit Product',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _productNameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                SizedBox(height: 15.0),
                TextField(
                  controller: _productPriceController,
                  decoration: InputDecoration(labelText: 'Product Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 15.0),
                ElevatedButton(
                  onPressed: addProduct,
                  child: Text('Add'),
                ),
                SizedBox(height: 3.0),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Remove Product',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: productList.map((product) {
                      final String productName = product['name'];
                      final double productPrice = product['price'];

                      return ListTile(
                        title: Text(productName),
                        subtitle: Text('Price: €${productPrice.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            removeProduct(productName);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Navigator.pushNamed(context, '/logo');
          } else if (index == 1) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Navigator.pushNamed(context, '/directe_verkoop');
          }
        },
      ),
    );
  }
}
