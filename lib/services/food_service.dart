import 'package:foodmood/models/food_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String getImageUrl(String imagePath) {
    try {
      if (imagePath.startsWith('http')) {
        return imagePath;
      }
      final publicUrl = _supabase.storage
          .from('images')
          .getPublicUrl(imagePath);
      return publicUrl;
    } catch (e) {
      print('Error generating image URL: $e');
      return '';
    }
  }

  Future<List<FoodItem>> fetchFoods({
    required int moodId,
    required int weatherId,
    int? foodTypeId,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      List<int> excludedItems = [];

      if (user != null) {
        // Fetch already matched food IDs
        final matchesResponse = await _supabase
            .from('matches')
            .select('food_id')
            .eq('user_id', user.id);

        if (matchesResponse.isNotEmpty) {
          excludedItems.addAll(
            (matchesResponse as List).map((m) => m['food_id'] as int),
          );
        }

        // Fetch blacklisted food IDs
        final blacklistResponse = await _supabase
            .from('blacklist')
            .select('food_id')
            .eq('user_id', user.id);

        if (blacklistResponse.isNotEmpty) {
          excludedItems.addAll(
            (blacklistResponse as List).map((m) => m['food_id'] as int),
          );
        }
      }

      var query = _supabase
          .from('foods')
          .select(
            '*, foods_moods!inner(mood_id), foods_weathers!inner(weather_id)',
          )
          .eq('foods_moods.mood_id', moodId)
          .eq('foods_weathers.weather_id', weatherId);

      // Apply food type filter only if it's not null
      if (foodTypeId != null) {
        query = query.eq('type_id', foodTypeId);
      }

      // Exclude matched and blacklisted foods
      if (excludedItems.isNotEmpty) {
        query = query.not('id', 'in', excludedItems);
      }

      final response = await query;

      if (response.isNotEmpty) {
        final List<FoodItem> foods = response.map((food) {
          final foodItem = FoodItem.fromJson(food);
          // Convert image_url to public URL
          final publicImageUrl = getImageUrl("foods/${foodItem.imageUrl}");
          return foodItem.copyWith(imageUrl: publicImageUrl);
        }).toList();
        foods.shuffle();
        return foods;
      }
      return [];
    } catch (e) {
      print('Error fetching foods: $e');
      rethrow;
    }
  }
}
