import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final bool isPasswordVisible;
  final bool isRegister;
  final VoidCallback? onTogglePassword;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.isRegister = false,
    this.isPasswordVisible = false,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14, // text-sm
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C140D),
            ),
          ),
        ),
        Container(
          height: 56, // h-14 (3.5rem = 56px)
          decoration: BoxDecoration(
            color: const Color(0xFFF4EDE7),
            borderRadius: BorderRadius.circular(12), // rounded-xl
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              // color: Color(0xFF1C140D),
              color: Color(0xFF9C7349),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF9C7349),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(icon, color: Color(0xFF9C7349), size: 24),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF9C7349),
                        size: 24,
                      ),
                      onPressed: onTogglePassword,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (isPassword && !isRegister)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF48C25),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
