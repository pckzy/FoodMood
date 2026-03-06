import 'package:flutter/material.dart';

class MoodChip extends StatelessWidget {
  final String mood;
  final String cuisine;

  const MoodChip({super.key, required this.mood, required this.cuisine});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'MOOD',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          Container(
            width: 1,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          Text(
            mood,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          Container(
            width: 1,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          Text(
            cuisine,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
