import 'package:flutter/material.dart';
import 'package:foodmood/auth/auth_service.dart';
import 'package:foodmood/widgets/custom_header.dart';
import 'package:foodmood/widgets/setting_appearance.dart';
import 'package:foodmood/widgets/setting_logout.dart';
import 'package:foodmood/widgets/setting_preference.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

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
                  CustomHeader(headerTxt: 'Settings'),

                  // Profile
                  _ProfileSection(),

                  // Appearance
                  SettingAppearance(),

                  // Preference
                  SettingPreference(),
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
                      color: const Color(0xFFF48C25),
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
                      color: Color(0xFFF48C25),
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
