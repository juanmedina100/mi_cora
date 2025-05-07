import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mi_cora.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transacciones (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          monto REAL NOT NULL,
          fecha TEXT NOT NULL,
          descripcion TEXT,
          tipo TEXT NOT NULL,
          categoria TEXT
        );
        ''');
      },
    );
  }
}






