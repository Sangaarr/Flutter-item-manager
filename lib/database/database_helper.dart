import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item.dart';

class DatabaseHelper {
  //Singleton Pattern: ensures only one instance of the database is used through the app
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  //Private constructor for singleton implementation
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  //Initializes de database and defines its location
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'items_database.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //Creates database tables on first launch
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // CRUD methods
  Future<int> insertItem(Item item) async {
    final db = await database;
    return await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Item>> getItems() async {
    final db = await database;
    final maps = await db.query('items', orderBy: 'createdAt DESC');
    return maps.map((map) => Item.fromMap(map)).toList();
  }

  Future<int> updateItem(Item item) async {
    final db = await database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
