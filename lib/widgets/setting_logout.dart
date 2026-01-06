import 'package:flutter/material.dart';
import 'package:foodmood/auth/auth_service.dart';

class SettingLogout extends StatelessWidget {
  SettingLogout({super.key});
  final authService = AuthService();

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: logout,
              // onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.tertiaryContainer,
                foregroundColor: Colors.red,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.1)),
                ),
                shadowColor: Colors.black.withValues(alpha: 0.05),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'FoodMood v1.0.2',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}