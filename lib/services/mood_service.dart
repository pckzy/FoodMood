import 'package:foodmood/models/mood_option.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoodService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get public URL for image from Supabase storage
  String getImageUrl(String imagePath) {
    try {
      if (imagePath.startsWith('http')) {
        return imagePath;
      }

      // Generate public URL from Supabase storage
      final publicUrl = _supabase.storage
          .from('images')
          .getPublicUrl(imagePath);
      print('Generated public URL: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('Error generating image URL: $e');
      return '';
    }
  }

  /// Fetch all moods from Supabase
  Future<List<MoodOption>> fetchMoods() async {
    try {
      final response = await _supabase
          .from('Moods')
          .select();

      if (response is List && response.isNotEmpty) {
        final List<MoodOption> moods = response
            .map((mood) {
              print('Mood data: $mood');
              final moodOption = MoodOption.fromJson(mood as Map<String, dynamic>);
              // Convert image_url to public Supabase storage URL
              final publicImageUrl = getImageUrl(moodOption.imageUrl);
              return moodOption.copyWith(imageUrl: publicImageUrl);
            })
            .toList();
        print('Successfully fetched ${moods.length} moods');
        return moods;
      } else {
        print('Response is empty or not a list: $response');
        return [];
      }
    } catch (e) {
      print('Error fetching moods: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }
} 
