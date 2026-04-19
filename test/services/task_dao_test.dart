import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
// ESTE ES EL IMPORT QUE FALTA:
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; 
import 'package:task_board/models/task.dart';
import 'package:task_board/data/task_dao.dart';
void main() {
  late Database db;
  late TaskDao taskDao;

  // 2. Inicializa la factoría de base de datos para pruebas en PC
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Usamos inMemoryDatabasePath para que las pruebas sean rápidas y limpias
    db = await openDatabase(
      inMemoryDatabasePath,
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

    taskDao = TaskDao(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TaskDao Tests', () {
    test('insertTask guarda tarea', () async {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Desc',
        isCompleted: false,
      );

      await taskDao.insertTask(task);
      final tasks = await taskDao.getTasks();

      expect(tasks.length, 1);
      expect(tasks.first.id, '1');
      expect(tasks.first.title, 'Test Task');
    });

    test('deleteTask elimina tarea', () async {
      final task = Task(
        id: '1',
        title: 'To Delete',
        description: 'Desc',
      );

      await taskDao.insertTask(task);
      await taskDao.deleteTask('1');

      final tasks = await taskDao.getTasks();
      expect(tasks.isEmpty, true);
    });

    test('updateTask actualiza tarea', () async {
      final task = Task(
        id: '1',
        title: 'Old Title',
        description: 'Desc',
      );

      await taskDao.insertTask(task);

      final updatedTask = task.copyWith(title: 'Updated Title');
      await taskDao.updateTask(updatedTask);

      final tasks = await taskDao.getTasks();
      expect(tasks.first.title, 'Updated Title');
    });
  });
}