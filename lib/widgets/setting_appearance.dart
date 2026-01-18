import 'package:flutter/material.dart';
import 'package:foodmood/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingAppearance extends StatefulWidget {
  const SettingAppearance({super.key});

  @override
  State<SettingAppearance> createState() => _SettingAppearanceState();
}

class _SettingAppearanceState extends State<SettingAppearance> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final themeProvider = Provider.of<ThemeProvider>(context);

    int selectedIndex;
    if (themeProvider.themeMode == ThemeMode.light) {
      selectedIndex = 0;
    } else if (themeProvider.themeMode == ThemeMode.dark) {
      selectedIndex = 1;
    } else {
      selectedIndex = 2;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            'APPEARANCE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimary,
              // color: Color(0xFF64748B),
              letterSpacing: 1.2,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: colorScheme.onTertiaryContainer),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF48C25).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.dark_mode,
                        size: 18,
                        color: Color(0xFFF48C25),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'App Theme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryFixed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      _buildThemeButton(
                        label: 'Light',
                        index: 0,
                        currentSelection: selectedIndex,
                        onTap: () => themeProvider.setTheme(0),
                        colorScheme: colorScheme,
                      ),
                      _buildThemeButton(
                        label: 'Dark',
                        index: 1,
                        currentSelection: selectedIndex,
                        onTap: () => themeProvider.setTheme(1),
                        colorScheme: colorScheme,
                      ),
                      _buildThemeButton(
                        label: 'System',
                        index: 2,
                        currentSelection: selectedIndex,
                        onTap: () => themeProvider.setTheme(2),
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeButton({
    required String label,
    required int index,
    required int currentSelection,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    final isSelected = currentSelection == index;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? const Color(0xFFF48C25)
                  : colorScheme.onTertiaryFixed,
            ),
          ),
        ),
      ),
    );
  }
}
