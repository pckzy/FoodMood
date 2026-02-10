import 'package:flutter/material.dart';
import 'package:foodmood/models/mood_option.dart';
import 'package:foodmood/services/mood_service.dart';
import 'package:foodmood/widgets/mood_card.dart';
import 'package:foodmood/widgets/weather_button.dart';
import 'package:foodmood/widgets/auto_detect_button.dart';
import 'package:foodmood/widgets/food_type_button.dart';

// ไฟล์นี้สำหรับวางใน lib/screens/selection/foodmood_selection_page.dart

class FoodMoodSelectionPage extends StatefulWidget {
  const FoodMoodSelectionPage({Key? key}) : super(key: key);

  @override
  State<FoodMoodSelectionPage> createState() => _FoodMoodSelectionPageState();
}

class _FoodMoodSelectionPageState extends State<FoodMoodSelectionPage> {
  String selectedMood = 'Happy';
  String selectedWeather = 'Sunny';
  String selectedFoodType = 'Main Course';
  
  final MoodService _moodService = MoodService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFFf48c25);
    final backgroundColor = isDark ? const Color(0xFF221910) : const Color(0xFFf8f7f5);
    final cardColor = isDark ? const Color(0xFF3a2e22) : const Color(0xFFf4ede7);
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        Container(
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
                      ],
                    ),
                  ),
                ),

                // How are you feeling?
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How are you feeling?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select a vibe to start',
                        style: TextStyle(
                          fontSize: 14,
                          color: subtextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Mood selection horizontal scroll
                FutureBuilder<List<MoodOption>>(
                  future: _moodService.fetchMoods(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            'Error loading moods',
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      );
                    }

                    final moods = snapshot.data ?? [];
                    
                    if (moods.isEmpty) {
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            'No moods available',
                            style: TextStyle(color: subtextColor),
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemCount: moods.length,
                        itemBuilder: (context, index) {
                          final mood = moods[index];
                          final isSelected = selectedMood == mood.name;
                          return MoodCard(
                            mood: mood,
                            isSelected: isSelected,
                            primaryColor: primaryColor,
                            cardColor: cardColor,
                            textColor: textColor,
                            onTap: () {
                              setState(() {
                                selectedMood = mood.name;
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Weather outside?
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weather outside?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'We\'ll find the perfect comfort food',
                        style: TextStyle(
                          fontSize: 14,
                          color: subtextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Weather buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      WeatherButton(
                        'Sunny ☀️',
                        primaryColor,
                        cardColor,
                        textColor,
                        isSelected: selectedWeather == 'Sunny',
                        onTap: () => setState(() => selectedWeather = 'Sunny'),
                      ),
                      WeatherButton(
                        'Rainy 🌧️',
                        primaryColor,
                        cardColor,
                        textColor,
                        isSelected: selectedWeather == 'Rainy',
                        onTap: () => setState(() => selectedWeather = 'Rainy'),
                      ),
                      WeatherButton(
                        'Chilly ❄️',
                        primaryColor,
                        cardColor,
                        textColor,
                        isSelected: selectedWeather == 'Chilly',
                        onTap: () => setState(() => selectedWeather = 'Chilly'),
                      ),
                      WeatherButton(
                        'Hot 🔥',
                        primaryColor,
                        cardColor,
                        textColor,
                        isSelected: selectedWeather == 'Hot',
                        onTap: () => setState(() => selectedWeather = 'Hot'),
                      ),
                      AutoDetectButton(cardColor: cardColor, textColor: textColor),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Food type
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Food type',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select your preferred category',
                        style: TextStyle(
                          fontSize: 14,
                          color: subtextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Food type buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FoodTypeButton(
                        'Main Course 🥘',
                        primaryColor,
                        cardColor,
                        textColor,
                        isSelected: selectedFoodType == 'Main Course',
                        onTap: () => setState(() => selectedFoodType = 'Main Course'),
                      ),
                      FoodTypeButton(
                        'Snacks 🍿',
                        primaryColor,
                        cardColor,
                        textColor,
                        isSelected: selectedFoodType == 'Snacks',
                        onTap: () => setState(() => selectedFoodType = 'Snacks'),
                      ),
                      FoodTypeButton(
                        'Drinks 🥤',
                        primaryColor,
                        cardColor,
                        textColor,
                        isSelected: selectedFoodType == 'Drinks',
                        onTap: () => setState(() => selectedFoodType = 'Drinks'),
                      ),
                      FoodTypeButton(
                        'Fruits 🍎',
                        primaryColor,
                        cardColor,
                        textColor,
                        isSelected: selectedFoodType == 'Fruits',
                        onTap: () => setState(() => selectedFoodType = 'Fruits'),
                      ),
                    ],
                  ),
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
                        onPressed: () {
                          // TODO: Navigate to swipe page with selected values
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => SwipePage(
                          //       mood: selectedMood,
                          //       weather: selectedWeather,
                          //       foodType: selectedFoodType,
                          //     ),
                          //   ),
                          // );
                          
                          // For now, just print selected values
                          debugPrint('Selected Mood: $selectedMood');
                          debugPrint('Selected Weather: $selectedWeather');
                          debugPrint('Selected Food Type: $selectedFoodType');
                        },
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
                            Text(
                              '🍔',
                              style: TextStyle(fontSize: 24),
                            ),
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