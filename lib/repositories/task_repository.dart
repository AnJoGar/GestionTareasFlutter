import 'package:task_board/data/task_dao.dart';

import '../models/task.dart';

class TaskRepository {
  final TaskDao _dao = TaskDao();

  Future<List<Task>> getAllTasks() => _dao.getTasks();

  Future<void> addTask(Task task) => _dao.insertTask(task);

  Future<void> removeTask(String id) => _dao.deleteTask(id);

  Future<void> editTask(Task task) => _dao.updateTask(task);
}