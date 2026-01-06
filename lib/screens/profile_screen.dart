import 'package:flutter/material.dart';
import 'package:foodmood/auth/auth_service.dart';
import 'package:foodmood/theme/theme_provider.dart';
import 'package:foodmood/widgets/test_btn.dart';
import 'package:provider/provider.dart';

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
    final currentEmail = authService.getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Center(child: Text(currentEmail.toString())),
          MyButton(
            color: Colors.blue[200],
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            }
          ),
        ],
      ),
    );
  }
}
