import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback? onDislike;
  final VoidCallback? onLike;
  final VoidCallback? onFavorite;

  const ActionButtons({
    super.key,
    this.onDislike,
    this.onLike,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onDislike,
            child: _buildActionButton(
              icon: Icons.close,
              size: 64,
              iconSize: 32,
              color: Colors.red,
              colorScheme: colorScheme,
            ),
          ),
          const SizedBox(width: 32),
          GestureDetector(
            onTap: onFavorite,
            child: _buildActionButton(
              icon: Icons.star_outline,
              size: 56,
              iconSize: 28,
              color: Colors.blue,
              colorScheme: colorScheme,
            ),
          ),
          const SizedBox(width: 32),
          GestureDetector(onTap: onLike, child: _buildLikeButton(colorScheme)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required double size,
    required double iconSize,
    required Color color,
    required ColorScheme colorScheme,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.onSurfaceVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }

  Widget _buildLikeButton(ColorScheme colorScheme) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.secondary.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.favorite, color: Colors.white, size: 32),
    );
  }
}
