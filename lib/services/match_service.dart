import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodmood/models/match_item.dart';
import 'package:foodmood/services/food_service.dart';

class MatchService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FoodService _foodService = FoodService();

  /// ดึง matches ทั้งหมดของ user ที่ login อยู่
  /// join กับ foods เพื่อดึง name และ image_url
  Future<List<MatchItem>> fetchUserMatches() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await _supabase
          .from('matches')
          .select(
            'food_id, matched_at, isFavorite, foods(name, description, image_url, food_types(name))',
          )
          .eq('user_id', user.id)
          .order('matched_at', ascending: false);

      return response.map<MatchItem>((row) {
        final item = MatchItem.fromJson(row);
        // แปลง image_url เป็น public URL
        final publicUrl = _foodService.getImageUrl('foods/${item.imageUrl}');
        return MatchItem(
          foodId: item.foodId,
          name: item.name,
          description: item.description,
          imageUrl: publicUrl,
          foodType: item.foodType,
          matchedAt: item.matchedAt,
          isFavorite: item.isFavorite,
        );
      }).toList();
    } catch (e) {
      print('Error fetching matches: $e');
      return [];
    }
  }
  
  /// บันทึก match ลงตาราง matches
  Future<void> insertMatch(int foodId, bool? isFavorite) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('matches').insert({
        'user_id': user.id,
        'food_id': foodId,
        'isFavorite': isFavorite ?? false,
      });
    } catch (e) {
      print('Error inserting match: $e');
    }
  }

  /// update favorite in matches
  Future<void> updateMatchFavorite(int foodId, bool isFavorite) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase
          .from('matches')
          .update({'isFavorite': isFavorite})
          .eq('user_id', user.id)
          .eq('food_id', foodId);
    } catch (e) {
      print('Error updating match favorite: $e');
    }
  }
}
