import 'package:flutter/material.dart';
import 'package:foodmood/screens/blacklist_screen.dart';
import 'package:foodmood/services/blacklist_service.dart';
import 'package:foodmood/widgets/setting_groupitem.dart';

class SettingPreference extends StatefulWidget {
  final bool isActive;
  const SettingPreference({super.key, this.isActive = false});

  @override
  State<SettingPreference> createState() => _SettingPreferenceState();
}

class _SettingPreferenceState extends State<SettingPreference> {
  final BlacklistService _blacklistService = BlacklistService();
  int _blacklistCount = 0;

  @override
  void initState() {
    super.initState();
    _loadBlacklistCount();
  }

  @override
  void didUpdateWidget(SettingPreference oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh count when screen becomes active
    if (widget.isActive && !oldWidget.isActive) {
      _loadBlacklistCount();
    }
  }

  Future<void> _loadBlacklistCount() async {
    final list = await _blacklistService.fetchBlacklistedFoods();
    print('Loaded blacklist count: ${list.length}');
    if (mounted) {
      setState(() {
        _blacklistCount = list.length;
      });
    }
  }

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
                SettingGroupItem(
                  icon: Icons.block,
                  title: 'Blacklist Management',
                  value: '$_blacklistCount Items',
                  position: SettingItemPosition.middle,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BlacklistScreen(),
                      ),
                    );
                    _loadBlacklistCount(); // Refresh count after returning
                  },
                ),
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
