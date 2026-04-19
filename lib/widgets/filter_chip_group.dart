import 'package:flutter/material.dart';
import '../providers/task_provider.dart';

/// Widget para mostrar los chips de filtro de tareas
class FilterChipGroup extends StatelessWidget {
  final TaskFilter currentFilter;
  final ValueChanged<TaskFilter> onFilterChanged;

  const FilterChipGroup({
    Key? key,
    required this.currentFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          _buildFilterChip(
            context,
            label: 'Todas',
            filter: TaskFilter.all,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            label: 'Pendientes',
            filter: TaskFilter.pending,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            label: 'Completadas',
            filter: TaskFilter.completed,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required TaskFilter filter,
  }) {
    final isSelected = currentFilter == filter;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onFilterChanged(filter);
        }
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }
}