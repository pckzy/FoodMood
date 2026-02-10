import 'package:flutter/material.dart';

class AutoDetectButton extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final VoidCallback? onTap;

  const AutoDetectButton({
    Key? key,
    required this.cardColor,
    required this.textColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap ?? () => debugPrint('Auto-detect weather clicked'),
      icon: Icon(
        Icons.my_location,
        size: 20,
        color: Colors.grey[600],
      ),
      label: Text(
        'Auto-detect',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: BorderSide(
          color: Colors.grey[400]!,
          width: 1,
          style: BorderStyle.solid,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
