import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

import 'package:uuid/uuid.dart';
var uuid = Uuid();

void mainDB() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'database.db'),

    // When the database is first created, create a table to store products.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
        db.execute(
            'CREATE TABLE products (id STRING PRIMARY KEY, name TEXT, price REAL, ean INTEGER NULLABLE, nix18 BOOLEAN)');
        db.execute(
            'CREATE TABLE orders (id STRING PRIMARY KEY, date TEXT, products TEXT, total REAL)');

        // Seed products
        Product bier = Product(
          name: 'Bier',
          price: 1.50,
          nix18: true,
        );
        Product drogeWitteWijn = Product(
          name: 'Droge witte wijn',
          price: 2.00,
          nix18: true,
        );
        Product straaljager = Product(
          name: 'Straaljager',
          price: 1.75,
          nix18: true,
        );
        Product cola = Product(
          name: 'Cola',
          price: 1.00,
          nix18: false,
        );

        insertProduct(bier);
        insertProduct(drogeWitteWijn);
        insertProduct(straaljager);
        insertProduct(cola);
      
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  Future<List<Product>> products() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the products.
    final List<Map<String, dynamic>> maps = await db.query('products');

    // Convert the List<Map<String, dynamic> into a List<Product>.
    return List.generate(maps.length, (i) {
      return Product(
        name: maps[i]['name'],
        price: maps[i]['price'],
        ean: maps[i]['ean'],
        nix18: maps[i]['nix18'],
      );
    });
  }
  
  // Define a function that inserts products into the database
  Future<void> insertProduct(Product product) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the product into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same product is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  Future<void> deleteProduct(String id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'products',
      // Use a `where` clause to delete a specific product.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
  );

  Future<List<Order>> orders() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the orders.
    final List<Map<String, dynamic>> maps = await db.query('orders');

    // Convert the List<Map<String, dynamic> into a List<Order>.
    return List.generate(maps.length, (i) {
      return Order(
        date: maps[i]['date'],
        products: maps[i]['products'],
        total: maps[i]['total'],
      );
    });
  }

  Future<void> placeOrder(Order order) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Order into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same order is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  
}
}

class Product {
  final String id;
  final String name;
  final double price;
  final int? ean;
  final bool nix18;

  Product({
    required this.name,
    required this.price,
    this.ean,
    required this.nix18,
  }):id = uuid.v1();  

  // Convert a Product into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'ean': ean,
      'nix18': nix18,
    };
  }

  // Implement toString to make it easier to see information about
  // each Product when using the print statement.
  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, ean: $ean, nix18: $nix18}';
  }
}

class Order {
  final String id;
  final String date;
  final List<Product> products;
  final double total;

  Order({
    required this.date,
    required this.products,
    required this.total,
  }):id = uuid.v1();  

  // Convert a Product into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'products': products,
      'total': total,
    };
  }

  // Implement toString to make it easier to see information about
  // each Product when using the print statement.
  @override
  String toString() {
    return 'Order{id: $id, date: $date, products: $products, total: $total}';
  }
}