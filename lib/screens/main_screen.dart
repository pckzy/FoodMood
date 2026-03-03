import 'package:flutter/material.dart';
import 'package:foodmood/models/mood.dart';
import 'package:foodmood/models/weather.dart';
import 'package:foodmood/models/food_type.dart';
import 'package:foodmood/screens/selection_page.dart';
import 'package:foodmood/screens/setting_screen.dart';
import 'package:foodmood/screens/match_history_screen.dart';
import 'package:foodmood/widgets/bottom_navigation.dart';
import 'package:foodmood/screens/home_screen.dart';

final GlobalKey<NavigatorState> settingsNavigatorKey =
    GlobalKey<NavigatorState>();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Selection state
  bool _isSelectionComplete = false;
  Mood? _selectedMood;
  Weather? _selectedWeather;
  FoodType? _selectedFoodType;

  void _onFoodMoodSelected(Mood mood, Weather weather, FoodType foodType) {
    setState(() {
      _selectedMood = mood;
      _selectedWeather = weather;
      _selectedFoodType = foodType;
      _isSelectionComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ใช้ PopScope เพื่อให้เวลากดปุ่ม Back บนมือถือ แล้วมันไม่ปิดแอปทันที
      // แต่ให้มันถอยออกจากหน้าย่อยใน Settings ก่อน
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          // Handle back button for Settings navigator
          if (_currentIndex == 2 &&
              settingsNavigatorKey.currentState!.canPop()) {
            settingsNavigatorKey.currentState!.pop();
            return;
          }

          // Handle back button for Home tab (go back to selection if on result)
          if (_currentIndex == 0 && _isSelectionComplete) {
            setState(() {
              _isSelectionComplete = false;
            });
            return;
          }
        },
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                // 1. Home Tab: Toggle between Selection and Result
                _isSelectionComplete
                    ? HomeScreen(
                        mood: _selectedMood!,
                        weather: _selectedWeather!,
                        foodType: _selectedFoodType!,
                        onReset: () {
                          setState(() => _isSelectionComplete = false);
                        },
                        onProfileTap: () {
                          setState(() => _currentIndex = 2);
                        },
                        onMatchesTap: () {
                          setState(() => _currentIndex = 1);
                        },
                      )
                    : FoodMoodSelectionPage(onSubmit: _onFoodMoodSelected),

                MatchHistoryScreen(isActive: _currentIndex == 1),
                // 2. แทนที่จะใส่ SettingScreen() ตรงๆ ให้ใส่ Navigator ครอบไว้
                Navigator(
                  key: settingsNavigatorKey,
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(
                      builder: (context) => const SettingScreen(),
                    );
                  },
                ),
              ],
            ),

            BottomNavigation(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
