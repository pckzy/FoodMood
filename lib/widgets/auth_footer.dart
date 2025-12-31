import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  final String footerText;
  final String btnText;
  final VoidCallback onPressed;
  const AuthFooter({
    super.key,
    required this.footerText,
    required this.btnText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                footerText,
                style: TextStyle(fontSize: 14, color: Color(0xFF9C7349)),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  btnText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF48C25),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
