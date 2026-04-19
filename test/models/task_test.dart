import 'package:flutter_test/flutter_test.dart';
import 'package:task_board/models/task.dart';

void main() {
  group('Task Model Tests', () {
   test('toJson debe serializar correctamente la tarea', () {
      final task = Task(
        id: 'test-id',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: true,
      );

      final json = task.toJson();

      expect(json['id'], 'test-id');
      expect(json['title'], 'Test Task');
      expect(json['description'], 'Test Description');
      
      // CAMBIO AQUÍ: SQLite usa 1 para true y 0 para false. 
      // Si tu modelo hace 'isCompleted': isCompleted ? 1 : 0, el test debe ser:
      expect(json['isCompleted'], 1); 
      
      expect(json['createdAt'], isA<String>());
      expect(json['updatedAt'], isNull);
    });

    test('fromJson debe deserializar correctamente la tarea', () {
      final json = {
        'id': 'test-id',
        'title': 'Test Task',
        'description': 'Test Description',
        // CAMBIO AQUÍ: Asegúrate de que el JSON de prueba use el formato de la BD (1/0 o true/false)
        'isCompleted': 1, 
        'createdAt': '2024-01-01T10:00:00.000Z',
        'updatedAt': '2024-01-02T10:00:00.000Z',
      };

      final task = Task.fromJson(json);

      expect(task.id, 'test-id');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      
      // El modelo debe convertir el 1 de la BD a true en Dart
      expect(task.isCompleted, true); 
      
      expect(task.createdAt, DateTime.parse('2024-01-01T10:00:00.000Z'));
      expect(task.updatedAt, DateTime.parse('2024-01-02T10:00:00.000Z'));
    });
    test('fromJson debe manejar valores opcionales correctamente', () {
      final json = {
        'id': 'test-id',
        'title': 'Test Task',
        'createdAt': '2024-01-01T10:00:00.000Z',
      };

      final task = Task.fromJson(json);

      expect(task.id, 'test-id');
      expect(task.title, 'Test Task');
      expect(task.description, '');
      expect(task.isCompleted, false);
      expect(task.updatedAt, isNull);
    });

    test('Dos tareas con el mismo ID deben ser iguales', () {
      final task1 = Task(
        id: 'same-id',
        title: 'Task 1',
        description: 'Description 1',
      );

      final task2 = Task(
        id: 'same-id',
        title: 'Task 2',
        description: 'Description 2',
      );

      expect(task1, equals(task2));
      expect(task1.hashCode, equals(task2.hashCode));
    });

    test('Dos tareas con diferente ID no deben ser iguales', () {
      final task1 = Task(
        title: 'Task 1',
        description: 'Description',
      );

      final task2 = Task(
        title: 'Task 1',
        description: 'Description',
      );

      expect(task1, isNot(equals(task2)));
    });

    test('toString debe retornar representación correcta', () {
      final task = Task(
        id: 'test-id',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: true,
      );

      final stringRepresentation = task.toString();

      expect(stringRepresentation, contains('test-id'));
      expect(stringRepresentation, contains('Test Task'));
      expect(stringRepresentation, contains('true'));
    });
  });
}