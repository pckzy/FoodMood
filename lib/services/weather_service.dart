import 'package:foodmood/models/weather.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WeatherService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch all weather options from Supabase
  Future<List<Weather>> fetchWeatherOptions() async {
    try {
      final response = await _supabase
          .from('weathers')
          .select()
          .order('id', ascending: true);

      if (response.isNotEmpty) {
        final List<Weather> weatherOptions = response.map((w) {
          return Weather.fromJson(w);
        }).toList();
        return weatherOptions;
      }
      return [];
    } catch (e) {
      print('Error fetching weather options: $e');
      rethrow;
    }
  }
}
