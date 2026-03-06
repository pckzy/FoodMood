import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _showHalalIcon = true;
  bool _showVeganIcon = true;

  bool get showHalalIcon => _showHalalIcon;
  bool get showVeganIcon => _showVeganIcon;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _showHalalIcon = prefs.getBool('show_halal_icon') ?? true;
    _showVeganIcon = prefs.getBool('show_vegan_icon') ?? true;
    notifyListeners();
  }

  Future<void> toggleHalalIcon(bool value) async {
    _showHalalIcon = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_halal_icon', value);
    notifyListeners();
  }

  Future<void> toggleVeganIcon(bool value) async {
    _showVeganIcon = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_vegan_icon', value);
    notifyListeners();
  }
}
