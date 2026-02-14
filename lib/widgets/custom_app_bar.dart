import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback? onTuneTap;
  final VoidCallback? onProfileTap;

  const CustomAppBar({Key? key, this.onTuneTap, this.onProfileTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(icon: Icons.person_outline, isDark: isDark, onTap: onProfileTap,
          ),
          Row(
            children: [
              Icon(Icons.rice_bowl, color: const Color(0xFFf48c25), size: 24),
              const SizedBox(width: 8),
              Text(
                'FoodMood',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          _buildIconButton(icon: Icons.tune, isDark: isDark, onTap: onTuneTap),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
