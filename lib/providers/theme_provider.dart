import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  // สร้าง Key สำหรับอ้างอิงใน Storage
  static const String _themeKey = 'theme_index';

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  // ฟังก์ชันโหลดค่าจากเครื่อง
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final int? themeIndex = prefs.getInt(_themeKey);
    
    if (themeIndex != null) {
      _themeMode = (themeIndex == 0) ? ThemeMode.light : ThemeMode.dark;
      notifyListeners();
    }
  }

  // ฟังก์ชันตั้งค่าและบันทึกลงเครื่อง
  Future<void> setTheme(int index) async {
    if (index == 0) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, index);
  }
}