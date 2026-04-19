import 'package:flutter/foundation.dart';
import 'package:task_board/repositories/task_repository.dart';
import '../models/task.dart';

enum TaskFilter { all, pending, completed }

class TaskProvider with ChangeNotifier {
  final TaskRepository _repository;

  List<Task> _tasks = [];
  TaskFilter _currentFilter = TaskFilter.all;
  String _searchQuery = '';
  bool _isLoading = false;

  TaskProvider(this._repository);

  // Getters
  List<Task> get tasks => _getFilteredTasks();
  List<Task> get allTasks => _tasks;
  bool get isLoading => _isLoading;
  TaskFilter get currentFilter => _currentFilter;

  int get totalTasks => _tasks.length;
  int get pendingTasks => _tasks.where((t) => !t.isCompleted).length;
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;

  // =========================
  // FILTRO (igual que tenías)
  // =========================
  List<Task> _getFilteredTasks() {
    var filtered = _tasks;

    switch (_currentFilter) {
      case TaskFilter.pending:
        filtered = filtered.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.completed:
        filtered = filtered.where((t) => t.isCompleted).toList();
        break;
      case TaskFilter.all:
        break;
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((t) =>
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    filtered.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  // =========================
  // 🔄 LOAD
  // =========================
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _repository.getAllTasks();
    } catch (e) {
      print('Error loading tasks: $e');
      _tasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask(Task task) async {
    try {
      await _repository.addTask(task);
      await loadTasks(); // recarga desde BD
      return true;
    } catch (e) {
      print('Error adding task: $e');
      return false;
    }
  }

  Future<bool> updateTask(Task task) async {
    try {
      final updated = task.copyWith(updatedAt: DateTime.now());

      await _repository.editTask(updated);
      await loadTasks();

      return true;
    } catch (e) {
      print('Error updating task: $e');
      return false;
    }
  }

  Future<bool> toggleTaskCompletion(String id) async {
    try {
      final task = _tasks.firstWhere((t) => t.id == id);

      final updated = task.copyWith(
        isCompleted: !task.isCompleted,
        updatedAt: DateTime.now(),
      );

      return await updateTask(updated);
    } catch (e) {
      print('Error toggling task: $e');
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      await _repository.removeTask(id);
      await loadTasks();
      return true;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}