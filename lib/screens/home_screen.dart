import 'package:flutter/material.dart';
import 'package:foodmood/models/mood.dart';
import 'package:foodmood/models/weather.dart';
import 'package:foodmood/models/food_type.dart';
import 'package:foodmood/widgets/home_header.dart';
import 'package:foodmood/widgets/mood_chip.dart';
import 'package:foodmood/widgets/swipe_card_stack.dart';
import 'package:foodmood/widgets/action_buttons.dart';
import 'package:foodmood/models/food_item.dart';
import 'package:foodmood/services/food_service.dart';
import 'package:foodmood/services/match_service.dart';
import 'package:foodmood/services/blacklist_service.dart';
import 'package:foodmood/widgets/match_overlay.dart';
import 'package:foodmood/widgets/info_bottom_sheet.dart';
import 'package:foodmood/widgets/notification_bar.dart';

class HomeScreen extends StatefulWidget {
  final Mood mood;
  final Weather weather;
  final FoodType foodType;
  final VoidCallback? onReset;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMatchesTap;

  const HomeScreen({
    super.key,
    required this.mood,
    required this.weather,
    required this.foodType,
    this.onReset,
    this.onProfileTap,
    this.onMatchesTap,
  });

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
  final GlobalKey<SwipeCardStackState> _stackKey =
      GlobalKey<SwipeCardStackState>();
  DateTime? _lastClickTime;
  bool _showNotification = false;
  String _NotificationText = '';

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  bool _canClick() {
    final now = DateTime.now();
    if (_lastClickTime == null ||
        now.difference(_lastClickTime!) > const Duration(milliseconds: 500)) {
      _lastClickTime = now;
      return true;
    }
    return false;
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



  void _handleMatch(FoodItem foodItem) {
    if (foodItem.id != null) {
      _matchService.insertMatch(foodItem.id!, false);
      
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 0),
        pageBuilder: (context, _, _) {
          return MatchOverlay(
            foodItem: foodItem,
            onKeepSwiping: () {
              Navigator.of(context).pop();
            },
            onGoToMatches: () {
              Navigator.of(context).pop();
              widget.onMatchesTap?.call();
            },
          );
        },
      );
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

  void _showInfoPopup(FoodItem foodItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => InfoBottomSheet(
        foodItem: foodItem,
        onBlacklist: () {
          Navigator.pop(context);
          _handleBlacklist(foodItem);
        },
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                HomeHeader(
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
          NotificationBar(
            showNotification: _showNotification,
            text: _NotificationText,
          ),
        ],
      ),
    );
  }
}
