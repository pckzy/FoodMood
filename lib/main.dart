import 'package:flutter/material.dart';
import 'package:foodmood/screens/login_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodMood',
      theme: ThemeData(useMaterial3: true, fontFamily: 'PlusJakartaSans'),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
