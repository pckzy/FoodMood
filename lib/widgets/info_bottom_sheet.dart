import 'package:flutter/material.dart';
import 'package:foodmood/models/food_item.dart';
import 'package:foodmood/widgets/action_buttons.dart';

class InfoBottomSheet extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback onBlacklist;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final VoidCallback? onFavorite;

  const InfoBottomSheet({
    super.key,
    required this.foodItem,
    required this.onBlacklist,
    this.onLike,
    this.onDislike,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: MediaQuery.of(context).size.height / 1.8,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (foodItem.type != null)
                        _buildBadge(
                          text: foodItem.type!.name,
                          icon: Icons.restaurant_menu,
                          color: Colors.orange,
                          backgroundColor: Colors.orange[100],
                        ),
                      for (final mood in foodItem.moods)
                        _buildBadge(
                          text: mood.name,
                          icon: Icons.favorite_border,
                          color: Colors.purple,
                          backgroundColor: Colors.purple[100]
                        ),
                      for (final weather in foodItem.weathers)
                        _buildBadge(
                          text: weather.name,
                          icon: Icons.wb_sunny_outlined,
                          color: Colors.blue,
                          backgroundColor: Colors.blue[100],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Food Name
                  Text(
                    foodItem.name,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // About this dish
                  Text(
                    'About this dish',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    foodItem.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Attributes Row
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      if (foodItem.spicyLevel > 0) ...[
                        _buildAttribute(
                          context,
                          icon: Icons.local_fire_department,
                          text: 'Spicy',
                          backgroundColor: Colors.red[50]!,
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (foodItem.halal) ...[
                        _buildAttribute(
                          context,
                          imagePath: 'assets/images/halal_logo.png',
                          text: 'Halal',
                          backgroundColor: Colors.green[50]!,
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (foodItem.isVegetable) ...[
                        _buildAttribute(
                          context,
                          imagePath: 'assets/images/vegan.png',
                          text: 'Vegan',
                          backgroundColor: Colors.green[50]!,
                        ),
                        const SizedBox(width: 12),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Action Buttons
                  ActionButtons(
                    onLike: onLike,
                    onDislike: onDislike,
                    onFavorite: onFavorite,
                  ),
                  const SizedBox(height: 16),
                  // Blacklist Button (now secondary)
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: onBlacklist,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      icon: const Icon(Icons.block, size: 20),
                      label: const Text(
                        'Add to Blacklist',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttribute(
    BuildContext context, {
    String? imagePath,
    IconData? icon,
    required String text,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: ClipOval(
              child: imagePath != null
                  ? Image.asset(imagePath, fit: BoxFit.cover)
                  : Icon(icon, size: 20, color: Colors.red),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    required IconData icon,
    required Color color,
    required Color? backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
