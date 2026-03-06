import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with Email and Password
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with Email and Password
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Change password
  Future<void> changePassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    // 1. Verify old password by signing in
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: oldPassword,
      );
    } catch (e) {
      throw 'Invalid old password';
    }

    // 2. Update user with new password
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  // Get user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
