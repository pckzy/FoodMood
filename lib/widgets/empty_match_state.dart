import 'package:flutter/material.dart';

class EmptyMatchState extends StatelessWidget {
  const EmptyMatchState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            'No matches yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Swipe right on foods you like to create a match!',
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
