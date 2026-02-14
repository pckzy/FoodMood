import 'package:flutter/material.dart';

class MoodChip extends StatelessWidget {
  final String mood;
  final String cuisine;

  const MoodChip({
    Key? key,
    required this.mood,
    required this.cuisine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withOpacity(0.1) 
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark 
              ? Colors.white.withOpacity(0.05) 
              : const Color(0xFFFFE5CC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'MOOD',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: isDark ? Colors.grey[200] : Colors.grey[600],
            ),
          ),
          Container(
            width: 1,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: isDark ? Colors.grey[600] : Colors.grey[300],
          ),
          Text(
            mood,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Container(
            width: 1,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: isDark ? Colors.grey[600] : Colors.grey[300],
          ),
          Text(
            cuisine,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}