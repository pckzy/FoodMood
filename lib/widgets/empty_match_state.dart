import 'package:flutter/material.dart';

class EmptyMatchState extends StatelessWidget {
  final String? filter;

  const EmptyMatchState({super.key, this.filter});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String title;
    String subtitle;

    if (filter == 'snacks') {
      title = 'No matching snacks yet';
      subtitle = 'Swipe right on snacks you like to create a match!';
    } else if (filter == 'favorites') {
      title = 'No favorites yet';
      subtitle = 'Add foods to your favorites to see them here!';
    } else {
      title = 'No matches yet';
      subtitle = 'Swipe right on foods you like to create a match!';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant,
              size: 36,
              color: isDark
                  ? colorScheme.secondary.withValues(alpha: 0.5)
                  : colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
