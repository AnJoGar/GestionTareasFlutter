import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

static Future<Database> _initDB() async {
  final path = join(await getDatabasesPath(), 'tasks.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE tasks(
          id TEXT PRIMARY KEY,
          title TEXT,
          description TEXT,
          isCompleted INTEGER,
          createdAt TEXT,    
          updatedAt TEXT     
        )
      ''');
    },
  );
}
}