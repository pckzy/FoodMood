import 'package:flutter/material.dart';

class BlacklistHeader extends StatelessWidget {
  const BlacklistHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(color: colorScheme.onSurfaceVariant, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: colorScheme.primary,
            ),
          ),
          Expanded(
            child: Text(
              'Blocked Foods',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
