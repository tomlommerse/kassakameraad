import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    final dbFile = path.join(dbPath, 'products.db');

    return await openDatabase(
      dbFile,
      version: 1,
      onCreate: (db, version) {
        _createProductTable(db);
        _createOrderTable(db);
      },
    );
  }

  static void _createProductTable(Database db) {
    db.execute(
      'CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, price REAL)',
    );
  }

  static void _createOrderTable(Database db) {
    db.execute(
      'CREATE TABLE orders(id INTEGER PRIMARY KEY AUTOINCREMENT, completedTime TEXT, totalPrice REAL)',
    );
  }

  static Future<void> insertProduct(String name, double price) async {
    final db = await DBHelper.database();

    await db.insert(
      'products',
      {'name': name, 'price': price},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await DBHelper.database();
    return db.query('products');
  }

  static Future<void> deleteProduct(String name) async {
    final db = await DBHelper.database();
    await db.delete(
      'products',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  static Future<void> addInitialProducts() async {
    await insertProduct('bier', 3.0);
    await insertProduct('wijn', 5.0);
    await insertProduct('cola', 2.5);
  }

  static Future<void> completeOrder(double totalPrice) async {
    final db = await DBHelper.database();
    final completedTime = DateTime.now().toIso8601String();

    await db.insert(
      'orders',
      {'completedTime': completedTime, 'totalPrice': totalPrice},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await DBHelper.database();
    return db.query('orders');
  }
}
