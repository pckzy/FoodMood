import 'package:flutter/material.dart';
import 'package:foodmood/screens/profile_screen.dart';
import 'package:foodmood/screens/setting_screen.dart';
import 'package:foodmood/screens/matches_screen.dart';
import 'package:foodmood/widgets/bottom_navigation.dart';


final GlobalKey<NavigatorState> settingsNavigatorKey = GlobalKey<NavigatorState>();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ใช้ PopScope เพื่อให้เวลากดปุ่ม Back บนมือถือ แล้วมันไม่ปิดแอปทันที 
      // แต่ให้มันถอยออกจากหน้าย่อยใน Settings ก่อน
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (settingsNavigatorKey.currentState!.canPop()) {
            settingsNavigatorKey.currentState!.pop();
          }
        },
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                const ProfileScreen(),
                const MatchesScreen(),
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