import 'package:flutter/material.dart';

class ManageActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onDelete;
  final VoidCallback onBlacklist;

  const ManageActionBar({
    super.key,
    required this.selectedCount,
    required this.onDelete,
    required this.onBlacklist,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasSelection = selectedCount > 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Selection count badge
          Expanded(
            child: Text(
              hasSelection
                  ? '$selectedCount selected'
                  : 'Select items to manage',
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.surface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Delete button
          _buildActionChip(
            label: 'Delete',
            icon: Icons.delete_outline,
            color: Colors.red,
            enabled: hasSelection,
            onTap: onDelete,
            colorScheme: colorScheme,
          ),
          const SizedBox(width: 10),
          // Blacklist button
          _buildActionChip(
            label: 'Blacklist',
            icon: Icons.block,
            color: Colors.deepOrange,
            enabled: hasSelection,
            onTap: onBlacklist,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required String label,
    required IconData icon,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: enabled
              ? color.withValues(alpha: 0.12)
              : colorScheme.surface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: enabled ? color.withValues(alpha: 0.4) : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: enabled
                  ? color
                  : colorScheme.surface.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: enabled
                    ? color
                    : colorScheme.surface.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
