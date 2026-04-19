import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

/// Pantalla de formulario para crear o editar tareas
class TaskFormScreen extends StatefulWidget {
  final String? taskId;

  const TaskFormScreen({Key? key, this.taskId}) : super(key: key);

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  Task? _existingTask;

  @override
  void initState() {
    super.initState();
    _loadTaskIfEditing();
  }

  void _loadTaskIfEditing() {
    if (widget.taskId != null) {
      final taskProvider = context.read<TaskProvider>();
      _existingTask = taskProvider.allTasks.firstWhere(
        (task) => task.id == widget.taskId,
      );
      _titleController.text = _existingTask!.title;
      _descriptionController.text = _existingTask!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final taskProvider = context.read<TaskProvider>();
    bool success;

    if (_existingTask != null) {
      // Editar tarea existente
      final updatedTask = _existingTask!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      success = await taskProvider.updateTask(updatedTask);
    } else {
      // Crear nueva tarea
      final newTask = Task(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      success = await taskProvider.addTask(newTask);
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al guardar la tarea'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _existingTask != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Tarea' : 'Nueva Tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título *',
                hintText: 'Ingresa el título de la tarea',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es obligatorio';
                }
                if (value.trim().length < 3) {
                  return 'El título debe tener al menos 3 caracteres';
                }
                return null;
              },
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ingresa una descripción (opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _saveTask,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white, // Color fijo para que resalte
                      ),
                    )
                  : const Icon(Icons.save_rounded, size: 24), // Icono más suave
              label: Text(
                (isEditing ? 'ACTUALIZAR TAREA' : 'GUARDAR TAREA')
                    .toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                // Colores
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.5),
                disabledForegroundColor: Colors.white70,

                // Forma y tamaño
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 24,
                ),
                minimumSize: const Size(
                  double.infinity,
                  56,
                ), // Botón de ancho completo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Bordes modernos
                ),

                // Sombra y elevación
                elevation: 4,
                shadowColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              icon: const Icon(Icons.cancel),
              label: const Text('Cancelar'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
