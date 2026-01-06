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
  final String? errorText;

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
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

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
              // color: Color(0xFF1C140D),
              color: colorScheme.primary,
            ),
          ),
        ),
        Container(
          height: 56, // h-14 (3.5rem = 56px)
          decoration: BoxDecoration(
            color: colorScheme.onSurfaceVariant,
            // color: const Color(0xFFF4EDE7),
            borderRadius: BorderRadius.circular(12), // rounded-xl
            border: hasError ? Border.all(color: Colors.red, width: 1.5) : null,
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              // color: Color(0xFF1C140D),
              // color: Color(0xFF9C7349),
              color: colorScheme.onPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                // color: Color(0xFF9C7349),
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(
                icon,
                // color: hasError ? Colors.red : const Color(0xFF9C7349),
                color: hasError ? Colors.red : colorScheme.onPrimary,
                size: 24,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: colorScheme.onPrimary,
                        // color: const Color(0xFF9C7349),
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
        // Error message แสดงใต้ TextField
        if (hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.secondary,
                    // color: Color(0xFFF48C25),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
