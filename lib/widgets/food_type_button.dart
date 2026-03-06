import 'package:flutter/material.dart';

class FoodTypeButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Color primaryColor;
  final Color cardColor;
  final Color textColor;
  final VoidCallback? onTap;

  const FoodTypeButton(
    this.text,
    this.primaryColor,
    this.cardColor,
    this.textColor, {
    super.key,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? primaryColor : cardColor,
        foregroundColor: isSelected ? Colors.white : textColor,
        elevation: isSelected ? 4 : 0,
        shadowColor: isSelected ? primaryColor.withValues(alpha: 0.3) : null,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}
