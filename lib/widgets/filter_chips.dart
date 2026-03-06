import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filters = ['All', 'Recent', 'Snacks', 'Favorites'];

    return Container(
      color: colorScheme.surface.withValues(alpha: 0.95),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Row(
          children: filters.map((filter) {
            final isSelected = selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                label: filter,
                isSelected: isSelected,
                colorScheme: colorScheme,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: () => onFilterChanged(label),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? colorScheme.surface : colorScheme.primary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
