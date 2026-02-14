import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback? onDislike;
  final VoidCallback? onLike;

  const ActionButtons({Key? key, this.onDislike, this.onLike})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 32),
          _buildActionButton(
            icon: Icons.star_outline,
            size: 56,
            iconSize: 28,
            color: Colors.blue,
            isDark: isDark,
          ),
          const SizedBox(width: 32),
          GestureDetector(onTap: onLike, child: _buildLikeButton(isDark)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required double size,
    required double iconSize,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }

  Widget _buildLikeButton(bool isDark) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFf48c25),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFf48c25).withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.favorite, color: Colors.white, size: 32),
    );
  }
}
