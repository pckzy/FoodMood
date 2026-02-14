import 'package:flutter/material.dart';
import '../models/food_item.dart';
import 'food_card.dart';

class SwipeCardStack extends StatefulWidget {
  final List<FoodItem> foodItems;
  final VoidCallback? onStackFinished;
  final VoidCallback? onReset;

  const SwipeCardStack({
    Key? key,
    required this.foodItems,
    this.onStackFinished,
    this.onReset,
  }) : super(key: key);

  @override
  State<SwipeCardStack> createState() => SwipeCardStackState();
}

class SwipeCardStackState extends State<SwipeCardStack> {
  int currentIndex = 0;
  final GlobalKey<FoodCardState> _cardKey = GlobalKey<FoodCardState>();

  void swipeLeft() => _cardKey.currentState?.swipeLeft();
  void swipeRight() => _cardKey.currentState?.swipeRight();

  void _onSwipe(bool isLike) {
    setState(() {
      currentIndex++;
      if (currentIndex >= widget.foodItems.length) {
        widget.onStackFinished?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= widget.foodItems.length) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions
        // Target aspect ratio ~1:1.4
        double cardHeight = constraints.maxHeight * 0.85;
        double cardWidth = cardHeight / 1.4;

        // Ensure it doesn't exceed screen width
        if (cardWidth > constraints.maxWidth * 0.9) {
          cardWidth = constraints.maxWidth * 0.9;
          cardHeight = cardWidth * 1.4;
        }

        // Ensure a minimum width
        if (cardWidth < 250) {
          cardWidth = 250;
          cardHeight = cardWidth * 1.4;
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            // Background cards
            if (currentIndex + 2 < widget.foodItems.length)
              _buildBackgroundCard(
                scale: 0.95,
                translateX: 4,
                translateY: 10,
                angle: -0.05,
                foodItem: widget.foodItems[currentIndex + 2],
                width: cardWidth,
                height: cardHeight,
              ),
            if (currentIndex + 1 < widget.foodItems.length)
              _buildBackgroundCard(
                scale: 0.95,
                translateX: 8,
                translateY: 16,
                angle: 0.05,
                foodItem: widget.foodItems[currentIndex + 1],
                width: cardWidth,
                height: cardHeight,
              ),
            // Front card
            FoodCard(
              key: _cardKey,
              foodItem: widget.foodItems[currentIndex],
              onSwipe: _onSwipe,
              width: cardWidth,
              height: cardHeight,
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackgroundCard({
    required double scale,
    required double translateX,
    required double translateY,
    required double angle,
    required FoodItem foodItem,
    required double width,
    required double height,
  }) {
    return Transform.scale(
      scale: scale,
      child: Transform.translate(
        offset: Offset(translateX, translateY),
        child: Transform.rotate(
          angle: angle,
          child: FoodCardView(foodItem: foodItem, width: width, height: height),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.no_food,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "That's all for now!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for more tasty recommendations.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: widget.onReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf48c25),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text(
              "Try different mood",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
