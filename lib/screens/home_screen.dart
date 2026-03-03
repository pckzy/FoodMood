import 'package:flutter/material.dart';
import 'package:foodmood/models/mood.dart';
import 'package:foodmood/models/weather.dart';
import 'package:foodmood/models/food_type.dart';
import 'package:foodmood/widgets/custom_app_bar.dart';
import 'package:foodmood/widgets/mood_chip.dart';
import 'package:foodmood/widgets/swipe_card_stack.dart';
import 'package:foodmood/widgets/action_buttons.dart';
import 'package:foodmood/models/food_item.dart';
import 'package:foodmood/services/food_service.dart';
import 'package:foodmood/services/match_service.dart';
import 'package:foodmood/widgets/match_overlay.dart';

class HomeScreen extends StatefulWidget {
  final Mood mood;
  final Weather weather;
  final FoodType foodType;
  final VoidCallback? onReset;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMatchesTap;

  const HomeScreen({
    Key? key,
    required this.mood,
    required this.weather,
    required this.foodType,
    this.onReset,
    this.onProfileTap,
    this.onMatchesTap,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FoodService _foodService = FoodService();
  final MatchService _matchService = MatchService();
  List<FoodItem> _foodItems = [];
  bool _isLoading = true;
  bool _isStackFinished = false;
  FoodItem? _matchedItem;
  final GlobalKey<SwipeCardStackState> _stackKey =
      GlobalKey<SwipeCardStackState>();
  DateTime? _lastClickTime;

  bool _canClick() {
    final now = DateTime.now();
    if (_lastClickTime == null ||
        now.difference(_lastClickTime!) > const Duration(milliseconds: 500)) {
      _lastClickTime = now;
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    // fetch foods filtered by user's mood, weather, and food type selection
    final foods = await _foodService.fetchFoods(
      moodId: widget.mood.id,
      weatherId: widget.weather.id,
      foodTypeId: widget.foodType.id,
    );
    if (mounted) {
      setState(() {
        _foodItems = foods;
        _isLoading = false;
      });
    }
  }

  bool _showFavoriteNotification = false;
  String _favoriteNotificationText = '';

  void _handleMatch(FoodItem foodItem) {
    if (foodItem.id != null) {
      _matchService.insertMatch(foodItem.id!, false);
      setState(() {
        _matchedItem = foodItem;
      });
    }
  }

  void _handleFavorite(FoodItem foodItem) {
    if (foodItem.id != null && _canClick()) {
      _matchService.insertMatch(foodItem.id!, true);
      _stackKey.currentState?.fadeOutCurrentCard(() {});

      setState(() {
        _favoriteNotificationText = 'Added ${foodItem.name} to favorites!';
        _showFavoriteNotification = true;
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showFavoriteNotification = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF221910)
        : const Color(0xFFf8f7f5);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                CustomAppBar(
                  onTuneTap: widget.onReset,
                  onProfileTap: widget.onProfileTap,
                ),
                const SizedBox(height: 8),
                MoodChip(
                  mood: '${widget.weather.name} & ${widget.mood.name}',
                  cuisine: widget.foodType.name,
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SwipeCardStack(
                          key: _stackKey,
                          foodItems: _foodItems,
                          onReset: widget.onReset,
                          onSwipeRight: _handleMatch,
                          onStackFinished: () {
                            setState(() {
                              _isStackFinished = true;
                            });
                          },
                        ),
                ),
                if (!_isStackFinished)
                  ActionButtons(
                    onDislike: () {
                      if (_canClick()) _stackKey.currentState?.swipeLeft();
                    },
                    onFavorite: () {
                      final items = _foodItems;
                      final index = _stackKey.currentState?.currentIndex ?? 0;
                      if (index < items.length) {
                        _handleFavorite(items[index]);
                      }
                    },
                    onLike: () {
                      if (_canClick()) _stackKey.currentState?.swipeRight();
                    },
                  ),
                const SizedBox(height: 90), // Add padding for bottom nav
              ],
            ),
          ),
          // Top Notification Bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            top: _showFavoriteNotification
                ? MediaQuery.of(context).padding.top + 10
                : -100,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1c140d),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.blue, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _favoriteNotificationText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Match Overlay layer
          if (_matchedItem != null)
            Positioned.fill(
              child: MatchOverlay(
                foodItem: _matchedItem!,
                onKeepSwiping: () {
                  setState(() {
                    _matchedItem = null;
                  });
                },
                onGoToMatches: () {
                  setState(() {
                    _matchedItem = null;
                  });
                  widget.onMatchesTap?.call();
                },
              ),
            ),
        ],
      ),
    );
  }
}
