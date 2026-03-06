import 'package:flutter/material.dart';

class BlacklistNotification extends StatelessWidget {
  final bool showNotification;
  final String notificationText;

  const BlacklistNotification({
    super.key,
    required this.showNotification,
    required this.notificationText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      bottom: showNotification ? 84 : -100,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
            const SizedBox(width: 12),
            Text(
              notificationText,
              style: TextStyle(
                color: colorScheme.surface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
