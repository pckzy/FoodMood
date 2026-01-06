import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String headerTxt;
  final VoidCallback? onPressed;

  const CustomHeader({super.key, required this.headerTxt, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      // padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(color: colorScheme.onSurfaceVariant, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPressed ?? () {},
            // onPressed: () {
            //   Navigator.pop(context);
            // },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: colorScheme.primary,
            ),
          ),
          Expanded(
            child: Text(
              headerTxt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
