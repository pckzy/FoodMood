import 'package:flutter/material.dart';
import 'package:foodmood/screens/blacklist_screen.dart';
import 'package:foodmood/widgets/setting_groupitem.dart';

class SettingPreference extends StatefulWidget {
  const SettingPreference({super.key});

  @override
  State<SettingPreference> createState() => _SettingPreferenceState();
}

class _SettingPreferenceState extends State<SettingPreference> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            'PREFERENCES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimary,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: colorScheme.onTertiaryContainer),
            ),
            child: Column(
              children: [
                SettingGroupItem(
                  icon: Icons.language,
                  title: 'Language',
                  value: 'English',
                  position: SettingItemPosition.first,
                  // onTap: () {},
                ),
                // Divider(height: 1, color: Color(0xFFF1F5F9)),
                SettingGroupItem(
                  icon: Icons.block,
                  title: 'Blacklist Management',
                  value: '2 Items',
                  position: SettingItemPosition.middle,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BlacklistScreen(),
                      ),
                    );
                  },
                ),
                // Divider(height: 1, color: Color(0xFFF1F5F9)),
                SettingGroupItem(
                  icon: Icons.restaurant_menu,
                  title: 'Dietary Restrictions',
                  value: 'Vegetarian',
                  position: SettingItemPosition.last,
                  // onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}