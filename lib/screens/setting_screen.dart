import 'package:flutter/material.dart';
import 'package:foodmood/auth/auth_service.dart';
import 'package:foodmood/widgets/setting_appearance.dart';
import 'package:foodmood/widgets/setting_logout.dart';
import 'package:foodmood/widgets/setting_preference.dart';

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
                  _ProfileSection(),

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

class _ProfileSection extends StatefulWidget {
  const _ProfileSection();

  @override
  State<_ProfileSection> createState() => __ProfileSectionState();
}

class __ProfileSectionState extends State<_ProfileSection> {
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentEmail = authService.getCurrentUserEmail();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: colorScheme.onTertiaryContainer),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAUExr3mJmckbpE7c1PRz3gcYnvkehptExYmx42gi7Vzpdp3agD7XQvBUGa-ko7MH6372BMIpxYTPPS-RLjZ6x8MJ8v8eVapy_zj6_RAb1W2UlSWrlY4JGpuVusjlZ0WXz9qF3gwYeGw4Zzf_w7F9b4U8eK5Q1SpgqQzJTbPRignQAnLX3EIRI9y8RiTH0VcvIVwreFx1Eo1Zaaml2MEjgBGtizua-DPl858NFumR_xx3YEWvLV23KsfITYDLv5fG12yilZmdmTdrw',
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account info',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '$currentEmail',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit_square,
                color: colorScheme.onTertiaryFixed,
                // color: Color(0xFF94A3B8),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
