import 'package:flutter/material.dart';
import 'package:foodmood/auth/auth_service.dart';
import 'package:foodmood/screens/selection/selection_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authService = AuthService();

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return  const FoodMoodSelectionPage();
  }
}
