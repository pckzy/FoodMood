import 'package:flutter/material.dart';
import 'package:foodmood/models/mood_option.dart';

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

  final List<MoodOption> moods = [
    MoodOption(
      name: 'Happy',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuChRixdEovk1Vi6DWgD5YTr3LOQwmP6rklTGWSvLKjG0t6FrZYP-cdy91aFOuT3nOgRbZBEyO-JoCL9w4w7h0pLMMfDoWA0A_RNxY_oWUW7WDVj2Pb9ZqiBNfdm3u4cgFvpiySoS3CUpox-InwbpH-n9y-MLJeNkj7FpDGa1dUgHvOxqkK97Nb-PF0KSZCNGgIAJkIY_O3B7MHdPYvPsOYaUEJx3Hhy2eZjwaJBNs_TAjFcRu0bHck7ADunUF_607BJrA-j0OZm20g',
    ),
    MoodOption(
      name: 'Hangry',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCfYXsmCAkhSYGQeBOkvH-F_W2J4ecv9chtRXSD1Un9KT1IAqmFxgWGCOpRy6H44yM23f3vaQtQD0Ww-UfwUQZ-4iC9MB-wQtBOLOucIlYClyYC4Nn7re3Nj7aksm5CYUeb98iRk8zA2chq5Bo-VUEcPLNOZCtV62UA1A5FYf55OtH3ZneYQEVqhtJQuSqbV7wygnVL8Ur8uAkc-0WIhuPHupyKs4VI2CbqxBAL1pqxGSmuYAxh8o85xi3n6GLwA-Y_fiTHf1uwsbU',
    ),
    MoodOption(
      name: 'Cozy',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCMWz3EU3c_vOQ1ATn474whf0MANTYekcTETIL__BJyQ-eG7W5BBNNMT11Kb6HpRhRz6fFMnBtjtTYEOJsGaMUxnMqaMzyeHiRullSoipqSbcfnrYPMMSWS2TT_NcX6Ot-iXFu3SqoMJAqgAH61W4cPQE5c9z83xH7ZRfPwYpvMP5BOW2-8_e6SxG6WXJnAO3f35HX4HZteV_wHcBtfuLrYTadzTkPZxXpPa1H769eM0-cCUlzh72whJ6yRS43j8Kp78xWJZpHi4d0',
    ),
    MoodOption(
      name: 'Energetic',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDIJGruxJDRNAcgcpkxGL_hf-Dc9mmXXV-QW4nRIt5obTEN0l8l2ngpINAA_LsRd4IMHsMd345Mx65wekvakNEwmZSQ0ilzY0ITWtI-YoTMmVkhWXs69d78OfcuzKVM8L-xyVl0hUWh-iAKwPRJQsMamq6-176Uq0DNYBBzkq1sn1uyulf33cjosNngBK3guSMUrdTHksbqNj2hh8XNZ7XED6G6-v5xFtolos73o7KW7BdyqsaRSgWcgzKLy8MgB1lVt9wKC2WTCNQ',
    ),
    MoodOption(
      name: 'Stressed',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAuHhUrHk2FVnGVJujTwNdIJs8Om_g63yqjMCOWMGUUwFF86FINjFGI5vDHyF9rTuE4Zh_Y4wBHLHv_v-U_BW_IZ3GcA7EP0VsanX-fhrUUno85n4LDa-AvBcqmiaQzBOf5eeuxOk3GgBU_XRw4JlxpKQoMqgm7RqcSy8N0PWQEadeOyZlvFOD_Nq6uGGqFJ0RCBaKas_4wp_BzD8QP75_GYY1JkHLkpfBPkoUbYK6JtuqumCl4vUxLdgB1Siyc5pvCzAJdyHN3yHg',
    ),
  ];

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
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: moods.length,
                    itemBuilder: (context, index) {
                      final mood = moods[index];
                      final isSelected = selectedMood == mood.name;
                      return _buildMoodCard(
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
                      _buildWeatherButton('Sunny ☀️', primaryColor, cardColor, textColor),
                      _buildWeatherButton('Rainy 🌧️', primaryColor, cardColor, textColor),
                      _buildWeatherButton('Chilly ❄️', primaryColor, cardColor, textColor),
                      _buildWeatherButton('Hot 🔥', primaryColor, cardColor, textColor),
                      _buildAutoDetectButton(cardColor, textColor),
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
                      _buildFoodTypeButton('Main Course 🥘', primaryColor, cardColor, textColor),
                      _buildFoodTypeButton('Snacks 🍿', primaryColor, cardColor, textColor),
                      _buildFoodTypeButton('Drinks 🥤', primaryColor, cardColor, textColor),
                      _buildFoodTypeButton('Fruits 🍎', primaryColor, cardColor, textColor),
                    ],
                  ),
                ),

                const SizedBox(height: 200), // Space for bottom navigation
              ],
            ),
          ),

          // Bottom fixed section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor.withOpacity(0.0),
                    backgroundColor,
                    backgroundColor,
                  ],
                ),
              ),
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

  Widget _buildMoodCard({
    required MoodOption mood,
    required bool isSelected,
    required Color primaryColor,
    required Color cardColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  // Background image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        image: DecorationImage(
                          image: NetworkImage(mood.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ),
                  // Check icon
                  if (isSelected)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              mood.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? primaryColor : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherButton(String text, Color primaryColor, Color cardColor, Color textColor) {
    final isSelected = selectedWeather == text.split(' ')[0];
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedWeather = text.split(' ')[0];
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? primaryColor : cardColor,
        foregroundColor: isSelected ? Colors.white : textColor,
        elevation: isSelected ? 4 : 0,
        shadowColor: isSelected ? const Color(0xFFffd4a8) : null,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAutoDetectButton(Color cardColor, Color textColor) {
    return OutlinedButton.icon(
      onPressed: () {
        // TODO: Implement auto-detect location
        debugPrint('Auto-detect weather clicked');
      },
      icon: Icon(
        Icons.my_location,
        size: 20,
        color: Colors.grey[600],
      ),
      label: Text(
        'Auto-detect',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: BorderSide(
          color: Colors.grey[400]!,
          width: 1,
          style: BorderStyle.solid,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildFoodTypeButton(String text, Color primaryColor, Color cardColor, Color textColor) {
    final isSelected = selectedFoodType == text.split(' ')[0] + (text.contains('Course') ? ' Course' : '');
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedFoodType = text.split(' ')[0] + (text.contains('Course') ? ' Course' : '');
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? primaryColor : cardColor,
        foregroundColor: isSelected ? Colors.white : textColor,
        elevation: isSelected ? 4 : 0,
        shadowColor: isSelected ? const Color(0xFFffd4a8) : null,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}