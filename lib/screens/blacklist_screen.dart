import 'package:flutter/material.dart';
import 'package:foodmood/services/blacklist_service.dart';
import 'package:foodmood/services/food_service.dart';
import 'package:foodmood/widgets/blacklist_header.dart';
import 'package:foodmood/widgets/blacklist_search_bar.dart';
import 'package:foodmood/widgets/blacklist_item_card.dart';
import 'package:foodmood/widgets/blacklist_notification.dart';

class BlacklistScreen extends StatefulWidget {
  const BlacklistScreen({super.key});

  @override
  State<BlacklistScreen> createState() => _BlacklistScreenState();
}

class _BlacklistScreenState extends State<BlacklistScreen> {
  final BlacklistService _blacklistService = BlacklistService();
  final FoodService _foodService = FoodService();
  List<Map<String, dynamic>> _allBlacklisted = [];
  List<Map<String, dynamic>> _filteredBlacklisted = [];
  bool _isLoading = true;
  String _searchQuery = '';

  // Notification state
  bool _showNotification = false;
  String _notificationText = '';

  @override
  void initState() {
    super.initState();
    _loadBlacklist();
  }

  Future<void> _loadBlacklist() async {
    setState(() => _isLoading = true);
    final data = await _blacklistService.fetchBlacklistedFoods();
    if (mounted) {
      setState(() {
        _allBlacklisted = data;
        _filterList();
        _isLoading = false;
      });
    }
  }

  void _filterList() {
    if (_searchQuery.isEmpty) {
      _filteredBlacklisted = List.from(_allBlacklisted);
    } else {
      _filteredBlacklisted = _allBlacklisted.where((item) {
        final food = item['foods'] as Map<String, dynamic>;
        final name = food['name'].toString().toLowerCase();
        return name.contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  Future<void> _unblockFood(int foodId, String name) async {
    try {
      await _blacklistService.removeFromBlacklist(foodId);
      if (mounted) {
        setState(() {
          _notificationText = '$name unblocked';
          _showNotification = true;
          _allBlacklisted.removeWhere((item) => item['food_id'] == foodId);
          _filterList();
        });

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() => _showNotification = false);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to unblock item')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const BlacklistHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Search Bar
                        BlacklistSearchBar(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              _filterList();
                            });
                          },
                          isDarkMode: isDarkMode,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 24),
                        // Help Text
                        Text(
                          'These items will not appear in your swipe stack. Unblock them to bring them back into your recommendations.',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // List
                        Expanded(
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _filteredBlacklisted.isEmpty
                              ? Center(
                                  child: Text(
                                    _searchQuery.isEmpty
                                        ? 'No blocked items'
                                        : 'No matches found',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: _filteredBlacklisted.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 12),
                                  padding: const EdgeInsets.only(bottom: 100),
                                  itemBuilder: (context, index) {
                                    final item = _filteredBlacklisted[index];
                                    final food =
                                        item['foods'] as Map<String, dynamic>;
                                    final foodType =
                                        food['food_types']
                                            as Map<String, dynamic>?;
                                    final typeName =
                                        foodType?['name'] ?? 'General';
                                    final imageUrl = _foodService.getImageUrl(
                                      'foods/${food['image_url']}',
                                    );

                                    return BlacklistItemCard(
                                      food: food,
                                      typeName: typeName,
                                      imageUrl: imageUrl,
                                      onUnblock: () => _unblockFood(
                                        food['id'],
                                        food['name'],
                                      ),
                                      isDarkMode: isDarkMode,
                                      colorScheme: colorScheme,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Custom Notification
            BlacklistNotification(
              showNotification: _showNotification,
              notificationText: _notificationText,
            ),
          ],
        ),
      ),
    );
  }
}
