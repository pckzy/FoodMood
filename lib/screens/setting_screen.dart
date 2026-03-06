import 'package:flutter/material.dart';
import 'package:foodmood/widgets/setting_appearance.dart';
import 'package:foodmood/widgets/setting_logout.dart';
import 'package:foodmood/widgets/setting_preference.dart';
import 'package:foodmood/widgets/setting_profile.dart';

class SettingScreen extends StatefulWidget {
  final bool isActive;
  const SettingScreen({super.key, this.isActive = false});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                    child: Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  // Profile
                  const SettingProfile(),

                  // Appearance
                  SettingAppearance(),

                  // Preference
                  SettingPreference(isActive: widget.isActive),
                ],
              ),
            ),

            // Logout
            SettingLogout(),

            // _LogoutSection(),
            Padding(padding: EdgeInsets.only(bottom: 80)),

            // Bottom Navbar
          ],
        ),
      ),
    );
  }
}
