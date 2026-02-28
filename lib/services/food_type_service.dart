import 'package:foodmood/models/food_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodTypeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch all food type options from Supabase
  Future<List<FoodType>> fetchFoodTypes() async {
    try {
      final response = await _supabase
          .from('food_types')
          .select()
          .order('id', ascending: true);

      if (response.isNotEmpty) {
        final List<FoodType> foodTypes = response.map((f) {
          return FoodType.fromJson(f);
        }).toList();
        return foodTypes;
      }
      return [];
    } catch (e) {
      print('Error fetching food types: $e');
      rethrow;
    }
  }
}
