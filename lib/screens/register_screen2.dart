import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448), // max-w-md
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0), // pt-2
                  child: _Header(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24), // pb-6 equivalent
                        _MainContent(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          isPasswordVisible: _isPasswordVisible,
                          isRegister: _isRegister,
                          isConfirmPasswordVisible: _isConfirmPasswordVisible,
                          onTogglePassword: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          onToggleConfirmPassword: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // _Footer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1C140D),
                            ),
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF48C25),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Header Widget
class _Header extends StatelessWidget {
  const _Header();

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

// Main Content Widget
class _MainContent extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordVisible;
  final bool isRegister;
  final bool isConfirmPasswordVisible;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  const _MainContent({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isRegister,
    required this.isConfirmPasswordVisible,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Headline Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800, // extrabold
                color: Color(0xFF1C140D),
                height: 1.2,
                letterSpacing: -0.5,
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
        const SizedBox(height: 32), // mb-8
        // Form Section
        CustomTextField(
          label: 'Email',
          hintText: 'email@foodmood.com',
          icon: Icons.mail_outline,
          controller: emailController,
        ),
        const SizedBox(height: 20), // gap-5

        CustomTextField(
          label: 'Password',
          hintText: 'Create a password',
          icon: Icons.lock_outline,
          controller: passwordController,
          isPassword: true,
          isRegister: true,
          isPasswordVisible: isPasswordVisible,
          onTogglePassword: onTogglePassword,
        ),
        const SizedBox(height: 20),

        CustomTextField(
          label: 'Confirm Password',
          hintText: 'Confirm your password',
          icon: Icons.lock_reset_outlined,
          controller: confirmPasswordController,
          isPassword: true,
          isRegister: true,
          isPasswordVisible: isConfirmPasswordVisible,
          onTogglePassword: onToggleConfirmPassword,
        ),
        const SizedBox(height: 48), // mt-4 + button spacing
        // const SizedBox(height: 36), // mt-4 + button spacing
        // Sign Up Button
        PrimaryButton(text: "Sign Up"),
        const SizedBox(height: 32), // my-8
        // Divider
        // const _Divider(),
        const SizedBox(height: 32),

        // Social Buttons
        // const _SocialButtons(),
      ],
    );
  }
}
