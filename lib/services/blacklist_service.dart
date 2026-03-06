import 'package:supabase_flutter/supabase_flutter.dart';

class BlacklistService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// เพิ่มอาหารลงใน blacklist ของ user ที่ login อยู่
  Future<void> addToBlacklist(int foodId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('blacklist').insert({
        'user_id': user.id,
        'food_id': foodId,
      });
    } catch (e) {
      print('Error adding to blacklist: $e');
      rethrow;
    }
  }

  /// ดึงข้อมูลอาหารทั้งหมดที่ติด blacklist พร้อมประเภทอาหาร
  Future<List<Map<String, dynamic>>> fetchBlacklistedFoods() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _supabase
          .from('blacklist')
          .select('food_id, foods(*, food_types(name))')
          .eq('user_id', user.id);

      print("Load blacklist...");

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching blacklisted foods: $e');
      return [];
    }
  }

  /// ลบอาหารออกจาก blacklist (Unblock)
  Future<void> removeFromBlacklist(int foodId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase
          .from('blacklist')
          .delete()
          .eq('user_id', user.id)
          .eq('food_id', foodId);
    } catch (e) {
      print('Error removing from blacklist: $e');
      rethrow;
    }
  }
}
