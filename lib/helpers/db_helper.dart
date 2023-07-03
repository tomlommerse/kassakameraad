import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create your tables here
        await db.execute('CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT, price REAL, ean INTEGER NULLABLE, nix18 BOOLEAN)');

        await db.execute('CREATE TABLE single_order (id INTEGER PRIMARY KEY, date TEXT, products TEXT, total REAL)');

        await db.execute('CREATE TABLE client (id INTEGER PRIMARY KEY, date TEXT, products TEXT, total REAL)');
        await db.execute('CREATE TABLE history (id INTEGER PRIMARY KEY, table_nr INT, date TEXT, products TEXT, total REAL)');
      
        // DB Seeding
        await db.execute('INSERT INTO products (name, price, nix18) VALUES ("Bier", 1.50, 1)');
        await db.execute('INSERT INTO products (name, price, nix18) VALUES ("Fris", 1.00, 0)');
        await db.execute('INSERT INTO products (name, price, nix18) VALUES ("Sterk", 2.00, 1)');
        await db.execute('INSERT INTO products (name, price, nix18) VALUES ("Mix", 2.00, 1)');
      },
    );
  }
}
