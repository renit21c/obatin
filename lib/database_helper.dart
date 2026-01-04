import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// NOTE: This application primarily uses SharedPreferences for data storage as defined in `shared_prefs_helper.dart`.
// The code in this file is a placeholder and is not currently integrated with the rest of the application.
// The 'User' model does not have an 'id' field anymore.
// To use a SQLite database, you would need to add the `sqflite` package to your `pubspec.yaml`
// and refactor the application's data persistence layer to use this DatabaseHelper.

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'obatin.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    // Create tables here. For example:
    await db.execute('''
      CREATE TABLE users (
        namaLansia TEXT PRIMARY KEY,
        password TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE obat (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userNamaLansia TEXT,
        namaObat TEXT NOT NULL,
        dosis TEXT NOT NULL,
        jadwal TEXT NOT NULL,
        FOREIGN KEY (userNamaLansia) REFERENCES users (namaLansia)
      )
    ''');
  }

  // Example method to insert a user.
  // Similar methods would be needed for other operations and tables.
  Future<int> saveUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }
}
