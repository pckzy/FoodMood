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

  Future<List<FoodItem>> fetchFoods() async {
    try {
      final response = await _supabase
          .from('Foods')
          .select();

      if (response.isNotEmpty) {
        final List<FoodItem> foods = response.map((food) {
          final foodItem = FoodItem.fromJson(food);
          // Convert image_url to public URL
          final publicImageUrl = getImageUrl(foodItem.imageUrl);
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
