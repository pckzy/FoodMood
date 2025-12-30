import 'package:flutter/material.dart';
import 'package:foodmood/widgets/primary_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Header
                  _HeaderSection(),

                  // Form Section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          // Email Input
                          CustomTextField(
                            label: 'Email',
                            hintText: 'email@foodmood.com',
                            icon: Icons.mail_outline,
                            controller: _emailController,
                          ),

                          const SizedBox(height: 24),

                          // Password Input
                          CustomTextField(
                            label: 'Password',
                            hintText: '••••••••',
                            icon: Icons.lock_outline,
                            controller: _passwordController,
                            isPassword: true,
                            isPasswordVisible: _isPasswordVisible,
                            onTogglePassword: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),

                          const SizedBox(height: 24),

                          // Login Button
                          PrimaryButton(text: 'Log In'),
                        ],
                      ),
                    ),
                  ),

                  // Footer
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'New to FoodMood?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9C7349),
                              ),
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Create an Account',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF48C25),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      child: Column(
        children: [
          // Logo Circle
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF48C25).withValues(alpha: 0.1),
              image: const DecorationImage(
                image: AssetImage('assets/images/foodmood-logo.png'),
                fit: BoxFit.cover,
                opacity: 0.9,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Title
          const Text(
            'FoodMood',
            style: TextStyle(
              fontSize: 30, // text-3xl (1.875rem = 30px)
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C140D),
              letterSpacing: 0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          const Text(
            'Find your flavor',
            style: TextStyle(
              fontSize: 16, // text-base
              fontWeight: FontWeight.w500,
              color: Color(0xFF9C7349),
            ),
          ),
        ],
      ),
    );
  }
}
