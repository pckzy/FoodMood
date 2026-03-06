import 'package:flutter/material.dart';
import 'package:foodmood/models/food_item.dart';

class MatchOverlay extends StatefulWidget {
  final FoodItem foodItem;
  final VoidCallback onKeepSwiping;
  final VoidCallback onGoToMatches;

  const MatchOverlay({
    super.key,
    required this.foodItem,
    required this.onKeepSwiping,
    required this.onGoToMatches,
  });

  @override
  State<MatchOverlay> createState() => _MatchOverlayState();
}

class _MatchOverlayState extends State<MatchOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = screenHeight * 0.22;

    return Material(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "It's a Match!" Text
              FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      Text(
                        "It's a Match!",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: colorScheme.secondary,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "You and the ${widget.foodItem.name} liked each other!",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Food Image
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.secondary.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(widget.foodItem.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.06),

              // Keep Swiping Button
              FadeTransition(
                opacity: _opacityAnimation,
                child: SizedBox(
                  width: 240,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: widget.onKeepSwiping,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Keep Swiping',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Go to Matches Text
              FadeTransition(
                opacity: _opacityAnimation,
                child: TextButton(
                  onPressed: widget.onGoToMatches,
                  child: const Text(
                    'Go to Matches',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
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
