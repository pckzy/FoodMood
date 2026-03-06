import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onTuneTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({super.key, this.onTuneTap, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
            icon: Icons.person_outline,
            colorScheme: colorScheme,
            onTap: onProfileTap,
          ),
          Row(
            children: [
              Icon(Icons.rice_bowl, color: colorScheme.secondary, size: 24),
              const SizedBox(width: 8),
              Text(
                'FoodMood',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          _buildIconButton(
            icon: Icons.tune,
            colorScheme: colorScheme,
            onTap: onTuneTap,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required ColorScheme colorScheme,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: colorScheme.primary),
      ),
    );
  }
}
