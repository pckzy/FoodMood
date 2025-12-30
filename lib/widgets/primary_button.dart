import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {

  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF48C25),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFFF48C25).withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18, // text-lg
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
