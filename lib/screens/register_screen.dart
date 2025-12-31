import 'package:flutter/material.dart';
import 'package:foodmood/auth/auth_service.dart';
import 'package:foodmood/widgets/auth_footer.dart';
import 'package:foodmood/widgets/custom_textfield.dart';
import 'package:foodmood/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final bool _isRegister = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Get auth service
  final authService = AuthService();

  // Sign up button pressed
  void signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password don't match")));
      return;
    }

    // Attempt sign up
    try {
      await authService.signUpWithEmailPassword(email, password);

      // Pop this register page
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 0), // pt-2
                    child: _HeaderSection(),
                  ),

                  const SizedBox(height: 24),

                  // Headline
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800, // extrabold
                            color: Color(0xFF1C140D),
                            height: 1.2,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Discover food that matches your vibe.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF9C7349),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

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
                            hintText: 'Create a password',
                            icon: Icons.lock_outline,
                            controller: _passwordController,
                            isPassword: true,
                            isRegister: _isRegister,
                            isPasswordVisible: _isPasswordVisible,
                            onTogglePassword: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),

                          const SizedBox(height: 24),

                          // Confirm Password Input
                          CustomTextField(
                            label: 'Confirm Password',
                            hintText: 'Confirm your password',
                            icon: Icons.lock_outline,
                            controller: _confirmPasswordController,
                            isPassword: true,
                            isRegister: _isRegister,
                            isPasswordVisible: _isConfirmPasswordVisible,
                            onTogglePassword: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),

                          const SizedBox(height: 48),

                          // Login Button
                          PrimaryButton(
                            text: 'Sign Up',
                            onPressed: () {
                              signUp();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Footer
                  AuthFooter(
                    footerText: 'Already have an account?',
                    btnText: 'Log In',
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

// Header Widget
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: const Color(0xFFE8DBCE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9999),
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Color(0xFF1C140D),
              ),
            ),
          ),
        ),
        // Brand Name
        const Text(
          'FOODMOOD',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF48C25),
            letterSpacing: 2.4, // tracking-widest
          ),
        ),
        // Spacer
        const SizedBox(width: 40, height: 40),
      ],
    );
  }
}
