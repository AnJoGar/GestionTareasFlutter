import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_item.dart';
import '../widgets/filter_chip_group.dart';
import 'task_form_screen.dart';
import 'task_detail_screen.dart';

/// Pantalla principal que muestra la lista de tareas
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        context.read<TaskProvider>().clearSearch();
      }
    });
  }

  Future<void> _navigateToTaskForm({String? taskId}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(taskId: taskId),
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(taskId == null ? 'Tarea creada' : 'Tarea actualizada'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _navigateToTaskDetail(String taskId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(taskId: taskId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    child: _isSearching
        ? Container(
            height: 45,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 41, 36, 36).withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Color.fromARGB(255, 15, 11, 11), fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Buscar tareas...',
                hintStyle: const TextStyle(color: Color.fromARGB(153, 29, 23, 23)),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Color.fromARGB(153, 32, 27, 27)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                // Botón para limpiar el texto rápidamente
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white60),
                      onPressed: () {
                        _searchController.clear();
                        context.read<TaskProvider>().setSearchQuery('');
                      },
                    ) 
                  : null,
              ),
              onChanged: (query) => context.read<TaskProvider>().setSearchQuery(query),
            ),
          )
        : const Text(
            'TaskBoard',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
          ),
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: AnimatedRotation(
        duration: const Duration(milliseconds: 300),
        turns: _isSearching ? 0.25 : 0,
        child: IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: _toggleSearch,
        ),
      ),
    ),
  ],
),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              // Estadísticas
              _buildStatsBar(taskProvider),
              
              // Filtros
              const SizedBox(height: 8),
              FilterChipGroup(
                currentFilter: taskProvider.currentFilter,
                onFilterChanged: (filter) {
                  taskProvider.setFilter(filter);
                },
              ),
              
              const SizedBox(height: 8),
              
              // Lista de tareas
              Expanded(
                child: taskProvider.tasks.isEmpty
                    ? _buildEmptyState()
                    : _buildTaskList(taskProvider),
              ),
            ],
          );
        },
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskForm(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Bordes menos redondeados
        ),
        elevation: 4,
        child: const Icon(Icons.add_task, size: 30), // Icono más específico
      ),
    );
  }

  Widget _buildStatsBar(TaskProvider taskProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total',
            taskProvider.totalTasks,
            Icons.list,
          ),
          _buildStatItem(
            'Pendientes',
            taskProvider.pendingTasks,
            Icons.pending_actions,
          ),
          _buildStatItem(
            'Completadas',
            taskProvider.completedTasks,
            Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay tareas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para agregar una tarea',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(TaskProvider taskProvider) {
    return AnimatedList(
      key: GlobalKey<AnimatedListState>(),
      initialItemCount: taskProvider.tasks.length,
      itemBuilder: (context, index, animation) {
        final task = taskProvider.tasks[index];
        
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: TaskListItem(
            task: task,
            onTap: () => _navigateToTaskDetail(task.id),
            onToggle: (value) async {
              final success = await taskProvider.toggleTaskCompletion(task.id);
              if (!success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al actualizar la tarea'),
                  ),
                );
              }
            },
            onDelete: () async {
              final success = await taskProvider.deleteTask(task.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Tarea eliminada' : 'Error al eliminar',
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}