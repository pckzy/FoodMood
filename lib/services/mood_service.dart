import 'package:foodmood/models/mood.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoodService {
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

  /// Fetch all moods from Supabase
  Future<List<Mood>> fetchMoods() async {
    try {
      final response = await _supabase.from('moods').select();

      if (response.isNotEmpty) {
        final List<Mood> moods = response.map((mood) {
          final moodOption = Mood.fromJson(mood);
          // Convert image_url to public URL
          final publicImageUrl = getImageUrl("moods/${moodOption.imageUrl}");
          return moodOption.copyWith(imageUrl: publicImageUrl);
        }).toList();
        return moods;
      }
      return [];
    } catch (e) {
      print('Error fetching moods: $e');
      rethrow;
    }
  }
}
