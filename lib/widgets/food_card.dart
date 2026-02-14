import 'package:flutter/material.dart';
import 'package:foodmood/models/food_item.dart';

/// The visual representation of a Food Card (Stateless)
class FoodCardView extends StatelessWidget {
  final FoodItem foodItem;
  final double? width;
  final double? height;

  const FoodCardView({
    Key? key,
    required this.foodItem,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = width ?? screenWidth * 0.9;
    final cardHeight = height ?? cardWidth * 1.4;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              foodItem.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Info button
          Positioned(top: 16, right: 16, child: _buildInfoButton()),
          // Content
          Positioned(bottom: 0, left: 0, right: 0, child: _buildCardContent()),
        ],
      ),
    );
  }

  Widget _buildInfoButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
        ],
      ),
      child: const Icon(Icons.info_outline, color: Colors.white, size: 20),
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFf48c25),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFf48c25).withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            foodItem.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                foodItem.priceLevel,
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: foodItem.tags.map((tag) => _buildTag(tag)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        tag.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// The Interactive Food Card with Swipe Logic
class FoodCard extends StatefulWidget {
  final FoodItem foodItem;
  final Function(bool isLike) onSwipe;
  final double? width;
  final double? height;

  const FoodCard({
    Key? key,
    required this.foodItem,
    required this.onSwipe,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<FoodCard> createState() => FoodCardState();
}

class FoodCardState extends State<FoodCard>
    with SingleTickerProviderStateMixin {
  Offset position = Offset.zero;
  bool isDragging = false;
  late AnimationController _controller;

  void swipeLeft() => _animateCardOff(false);
  void swipeRight() => _animateCardOff(true);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      position += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isDragging = false;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final velocity = details.velocity.pixelsPerSecond.dx;

    // Determine if it's a swipe based on distance OR velocity
    final isFlick = velocity.abs() > 500; // Threshold for flick
    final isDistance =
        position.dx.abs() > screenWidth * 0.15; // Reduced threshold

    if (isDistance || isFlick) {
      // If velocity is high, use direction from velocity, otherwise use position
      final isLike = isFlick ? velocity > 0 : position.dx > 0;

      // Safety check: ensure direction matches position if using distance only
      // But for flick, we trust velocity.

      _animateCardOff(isLike);
    } else {
      _resetCard();
    }
  }

  void _animateCardOff(bool isLike) {
    final screenWidth = MediaQuery.of(context).size.width;
    final endX = isLike ? screenWidth : -screenWidth;

    final animation = Tween<Offset>(
      begin: position,
      // Increased distance to ensure it goes fully off-screen smoothly
      end: Offset(endX * 2, position.dy),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    void listener() {
      setState(() {
        position = animation.value;
      });
    }

    animation.addListener(listener);

    _controller.forward(from: 0).then((_) {
      // Logic for after animation is complete
      widget.onSwipe(isLike);

      // Stop listening to avoid reset value
      animation.removeListener(listener);

      setState(() {
        position = Offset.zero;
      });
      _controller.reset();
    });
  }

  void _resetCard() {
    final animation = Tween<Offset>(begin: position, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        // Smoother reset curve instead of elasticOut
        curve: Curves.easeOutBack,
      ),
    );

    void listener() {
      setState(() {
        position = animation.value;
      });
    }

    animation.addListener(listener);

    _controller.forward(from: 0).then((_) {
      // Ensure it is exactly zero at the end and stop listening
      animation.removeListener(listener);

      setState(() {
        position = Offset.zero;
      });
      _controller.reset();
    });
  }

  Widget _buildSwipeIndicator(IconData icon, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 48),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final angle = position.dx / screenWidth * 0.4;
    final likeOpacity = (position.dx / (screenWidth * 0.4)).clamp(0.0, 1.0);
    final dislikeOpacity = (-position.dx / (screenWidth * 0.4)).clamp(0.0, 1.0);

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: position,
        child: Transform.rotate(
          angle: angle,
          child: Stack(
            children: [
              FoodCardView(
                foodItem: widget.foodItem,
                width: widget.width,
                height: widget.height,
              ),
              // Like/Dislike indicators
              if (position.dx > 0)
                Positioned(
                  top: 32,
                  left: 32,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Opacity(
                      opacity: likeOpacity,
                      child: _buildSwipeIndicator(Icons.favorite, Colors.green),
                    ),
                  ),
                ),
              if (position.dx < 0)
                Positioned(
                  top: 32,
                  right: 32,
                  child: Transform.rotate(
                    angle: 0.2,
                    child: Opacity(
                      opacity: dislikeOpacity,
                      child: _buildSwipeIndicator(Icons.close, Colors.red),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
