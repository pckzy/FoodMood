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
    required int foodTypeId,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      List<int> matchedItem = [];

      // Fetch already matched food IDs for this user
      if (user != null) {
        final matchesResponse = await _supabase
            .from('matches')
            .select('food_id')
            .eq('user_id', user.id);

        if (matchesResponse.isNotEmpty) {
          matchedItem = (matchesResponse as List)
              .map((m) => m['food_id'] as int)
              .toList();
        }
      }

      var query = _supabase
          .from('foods')
          .select(
            '*, foods_moods!inner(mood_id), foods_weathers!inner(weather_id)',
          )
          .eq('type_id', foodTypeId)
          .eq('foods_moods.mood_id', moodId)
          .eq('foods_weathers.weather_id', weatherId);

      // Exclude matched foods if any exist
      if (matchedItem.isNotEmpty) {
        query = query.not('id', 'in', matchedItem);
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
