import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodmood/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Supabase setup
  await dotenv.load(fileName: '.env');

  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;


  await Supabase.initialize(anonKey: supabaseAnonKey, url: supabaseUrl );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodMood',
      theme: ThemeData(useMaterial3: true, fontFamily: 'PlusJakartaSans'),
      home: AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
