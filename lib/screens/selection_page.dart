import 'package:flutter/material.dart';
import 'package:foodmood/models/mood.dart';
import 'package:foodmood/models/weather.dart';
import 'package:foodmood/models/food_type.dart';
import 'package:foodmood/widgets/mood_selection_section.dart';
import 'package:foodmood/widgets/weather_selection_section.dart';
import 'package:foodmood/widgets/food_type_selection_section.dart';

class FoodMoodSelectionPage extends StatefulWidget {
  final Function(Mood mood, Weather weather, FoodType foodType) onSubmit;
  final VoidCallback? onProfileTap;

  const FoodMoodSelectionPage({
    super.key,
    required this.onSubmit,
    this.onProfileTap,
  });

  @override
  State<FoodMoodSelectionPage> createState() => _FoodMoodSelectionPageState();
}

class _FoodMoodSelectionPageState extends State<FoodMoodSelectionPage> {
  String? selectedMood;
  String? selectedWeather;
  String? selectedFoodType;

  List<Mood> _moodsList = [];
  List<Weather> _weatherList = [];
  List<FoodType> _foodTypeList = [];

  void _showErrorDialog(String itemName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actionsPadding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 8),
            Text('Missing $itemName'),
          ],
        ),
        content: Text('Please select your $itemName before submitting.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf48c25),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (selectedMood == null) {
      _showErrorDialog('mood');
      return;
    } else if (selectedWeather == null) {
      _showErrorDialog('weather');
      return;
    } else if (selectedFoodType == null) {
      _showErrorDialog('food type');
      return;
    }

    final mood = _moodsList.firstWhere((m) => m.name == selectedMood);
    final weather = _weatherList.firstWhere((w) => w.name == selectedWeather);

    FoodType foodType;

    if (selectedFoodType == 'All') {
      foodType = FoodType(id: -1, name: 'All');
    } else {
      foodType = _foodTypeList.firstWhere((f) => f.name == selectedFoodType);
    }

    widget.onSubmit(mood, weather, foodType);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFFf48c25);
    final backgroundColor = isDark
        ? const Color(0xFF221910)
        : const Color(0xFFf8f7f5);
    final cardColor = isDark
        ? const Color(0xFF3a2e22)
        : const Color(0xFFf4ede7);
    final textColor = isDark ? Colors.white : const Color(0xFF1c140d);
    final subtextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.9),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Set your FoodMood',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onProfileTap,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: cardColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.account_circle_outlined,
                              color: textColor,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Mood selection
                MoodSelectionSection(
                  selectedMood: selectedMood,
                  onMoodSelected: (mood) => setState(() => selectedMood = mood),
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtextColor: subtextColor!,
                  onMoodsLoaded: (moods) {
                    if (_moodsList.isEmpty && moods.isNotEmpty) {
                      setState(() => _moodsList = moods);
                    }
                  },
                ),

                const SizedBox(height: 24),

                // Weather selection
                WeatherSelectionSection(
                  selectedWeather: selectedWeather,
                  onWeatherSelected: (weather) =>
                      setState(() => selectedWeather = weather),
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onWeatherLoaded: (weathers) {
                    if (_weatherList.isEmpty && weathers.isNotEmpty) {
                      setState(() => _weatherList = weathers);
                    }
                  },
                ),

                const SizedBox(height: 24),

                // Food Type selection
                FoodTypeSelectionSection(
                  selectedFoodType: selectedFoodType,
                  onFoodTypeSelected: (foodType) =>
                      setState(() => selectedFoodType = foodType),
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onFoodTypesLoaded: (foodTypes) {
                    if (_foodTypeList.isEmpty && foodTypes.isNotEmpty) {
                      setState(() => _foodTypeList = foodTypes);
                    }
                  },
                ),

                const SizedBox(height: 200), // Space for bottom navigation
              ],
            ),
          ),

          // Bottom fixed section
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show me the food button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: primaryColor.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Show me the food',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('🍔', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
