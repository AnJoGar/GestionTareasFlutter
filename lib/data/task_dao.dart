import 'package:sqflite/sqflite.dart';
import '../models/task.dart';
import 'db_helper.dart';

class TaskDao {
  final Database? database;

  TaskDao({this.database});

  Future<Database> get _db async {
    return database ?? await DBHelper.database;
  }

  Future<void> insertTask(Task task) async {
    final db = await _db;
    await db.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await _db;
    final maps = await db.query('tasks');
    return maps.map((e) => Task.fromJson(e)).toList();
  }

  Future<void> deleteTask(String id) async {
    final db = await _db;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTask(Task task) async {
    final db = await _db;
    await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}