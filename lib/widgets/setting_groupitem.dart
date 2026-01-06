import 'package:flutter/material.dart';

enum SettingItemPosition { single, first, middle, last }

class SettingGroupItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  final SettingItemPosition position;
  final Color? containerColor;
  final Color? titleColor;
  final Color? valueColor;

  const SettingGroupItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    this.position = SettingItemPosition.middle,
    this.containerColor,
    this.titleColor,
    this.valueColor,
  });

  BorderRadius get _borderRadius {
    switch (position) {
      case SettingItemPosition.single:
        return BorderRadius.circular(12);
      case SettingItemPosition.first:
        return const BorderRadius.vertical(top: Radius.circular(12));
      case SettingItemPosition.last:
        return const BorderRadius.vertical(bottom: Radius.circular(12));
      case SettingItemPosition.middle:
        return BorderRadius.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      type: MaterialType.transparency,
      borderRadius: _borderRadius,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          color: containerColor ?? cs.tertiaryContainer,
          borderRadius: _borderRadius,
        ),
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: _borderRadius,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon background
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: cs.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(icon, size: 18, color: cs.secondary),
                ),
                const SizedBox(width: 16),

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? cs.primary,
                    ),
                  ),
                ),

                // Value
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: valueColor ?? cs.onTertiaryFixed,
                  ),
                ),
                const SizedBox(width: 8),

                // Arrow
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: valueColor ?? cs.onTertiaryFixed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
