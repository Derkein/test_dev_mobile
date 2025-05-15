import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mundo_wap_tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE task_responses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      task_id INTEGER NOT NULL,
      field_label TEXT NOT NULL,
      field_value TEXT NOT NULL,
      created_at TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE completed_tasks (
      task_id INTEGER PRIMARY KEY,
      completed_at TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE form_state (
      task_id INTEGER NOT NULL,
      field_id INTEGER NOT NULL,
      field_value TEXT NOT NULL,
      PRIMARY KEY (task_id, field_id)
    )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}