import 'package:flutter/material.dart';
import 'package:foodmood/widgets/custom_app_bar.dart';
import 'package:foodmood/widgets/mood_chip.dart';
import 'package:foodmood/widgets/swipe_card_stack.dart';
import 'package:foodmood/widgets/action_buttons.dart';
import 'package:foodmood/models/food_item.dart';

import 'package:foodmood/services/food_service.dart';

class HomeScreen extends StatefulWidget {
  final String mood;
  final String weather;
  final String foodType;
  final VoidCallback? onReset;
  final VoidCallback? onProfileTap;

  const HomeScreen({
    Key? key,
    required this.mood,
    required this.weather,
    required this.foodType,
    this.onReset,
    this.onProfileTap,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FoodService _foodService = FoodService();
  List<FoodItem> _foodItems = [];
  bool _isLoading = true;
  bool _isStackFinished = false;
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
    // fetch all foods
    final foods = await _foodService.fetchFoods();
    if (mounted) {
      setState(() {
        _foodItems = foods;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            CustomAppBar(
              onTuneTap: widget.onReset,
              onProfileTap: widget.onProfileTap,
            ),
            const SizedBox(height: 8),
            MoodChip(
              mood: '${widget.weather} & ${widget.mood}',
              cuisine: widget.foodType,
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SwipeCardStack(
                      key: _stackKey,
                      foodItems: _foodItems,
                      onReset: widget.onReset,
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
                onLike: () {
                  if (_canClick()) _stackKey.currentState?.swipeRight();
                },
              ),
            const SizedBox(height: 90), // Add padding for bottom nav
          ],
        ),
      ),
    );
  }
}
