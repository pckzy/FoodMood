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
import 'package:foodmood/services/blacklist_service.dart';
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
  final BlacklistService _blacklistService = BlacklistService();
  List<FoodItem> _foodItems = [];
  bool _isLoading = true;
  bool _isStackFinished = false;
  FoodItem? _matchedItem;

  void _showInfoPopup(FoodItem foodItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2c2219)
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              foodItem.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _handleBlacklist(foodItem);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.block),
                label: const Text(
                  'Add to Blacklist',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _handleBlacklist(FoodItem foodItem) async {
    if (foodItem.id != null) {
      try {
        await _blacklistService.addToBlacklist(foodItem.id!);
        if (mounted) {
          setState(() {
            _NotificationText = '🚫  ${foodItem.name} blacklisted';
            _showNotification = true;
          });
          _stackKey.currentState?.swipeLeft();

          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() => _showNotification = false);
            }
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add to blacklist')),
          );
        }
      }
    }
  }

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
      foodTypeId: widget.foodType.id == -1 ? null : widget.foodType.id,
    );
    if (mounted) {
      setState(() {
        _foodItems = foods;
        _isLoading = false;
      });
    }
  }

  bool _showNotification = false;
  String _NotificationText = '';

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
        _NotificationText = '⭐ Added ${foodItem.name} to favorites!';
        _showNotification = true;
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showNotification = false);
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
                          onInfo: _showInfoPopup,
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
            curve: Curves.easeInOut,
            top: _showNotification
                ? MediaQuery.of(context).padding.top + 10
                : -100,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFFf4ede7)
                    : const Color(0xFF3a2e22),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Text(
                _NotificationText,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF221910)
                      : const Color(0xFFf8f7f5),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
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
