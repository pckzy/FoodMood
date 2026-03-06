import 'package:flutter/material.dart';

class BlacklistItemCard extends StatelessWidget {
  final Map<String, dynamic> food;
  final String typeName;
  final String imageUrl;
  final VoidCallback onUnblock;
  final bool isDarkMode;
  final ColorScheme colorScheme;

  const BlacklistItemCard({
    super.key,
    required this.food,
    required this.typeName,
    required this.imageUrl,
    required this.onUnblock,
    required this.isDarkMode,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? colorScheme.tertiaryContainer : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Food Image
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, e, s) => Container(
                width: 50,
                height: 50,
                color: isDarkMode ? Colors.white10 : Colors.grey[200],
                child: const Icon(Icons.restaurant),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['name'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$typeName • ${(food['description'] ?? '').split(',').first}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Unblock button
          TextButton(
            onPressed: onUnblock,
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.secondary.withValues(alpha: 0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Unblock',
              style: TextStyle(
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
