import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key, 
    required this.currentIndex, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.9),
          border: Border(
            top: BorderSide(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2), width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 80,
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.home, label: 'Home', index: 0, iconColor: colorScheme.onTertiaryFixed),
                _buildNavItem(icon: Icons.favorite, label: 'Matches', index: 1, iconColor: colorScheme.onTertiaryFixed),
                _buildNavItem(icon: Icons.settings, label: 'Settings', index: 2, iconColor: colorScheme.onTertiaryFixed),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index, required Color iconColor}) {
    final isSelected = currentIndex == index; // เช็คจากค่าที่รับม
    return GestureDetector(
      onTap: () => onTap(index), // เรียกฟังก์ชันที่ตัวแม่ส่งมา
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? const Color(0xFFF48C25) : iconColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFFF48C25) : iconColor,
              // color: isSelected ? const Color(0xFFF48C25) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
