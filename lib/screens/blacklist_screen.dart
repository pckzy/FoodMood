import 'package:flutter/material.dart';
import 'package:foodmood/services/blacklist_service.dart';
import 'package:foodmood/services/food_service.dart';

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
      backgroundColor: isDarkMode
          ? colorScheme.surface
          : const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  // padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.9),
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.onSurfaceVariant,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 24,
                          color: colorScheme.primary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Blocked Foods',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? colorScheme.tertiaryContainer
                                : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                                _filterList();
                              });
                            },
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search blocked items',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[600],
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Help Text
                        Text(
                          'These items will not appear in your swipe stack. Unblock them to bring them back into your recommendations.',
                          style: TextStyle(
                            color: isDarkMode
                                ? colorScheme.onPrimary
                                : const Color(0xFF8B735B),
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

                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isDarkMode
                                            ? colorScheme.tertiaryContainer
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          // Food Image
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                            child: Image.network(
                                              imageUrl,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, e, s) =>
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    color: isDarkMode
                                                        ? Colors.white10
                                                        : Colors.grey[200],
                                                    child: const Icon(
                                                      Icons.restaurant,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          // Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  food['name'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '$typeName • ${food['description'].split(',').first}',
                                                  style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 13,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Unblock button
                                          TextButton(
                                            onPressed: () => _unblockFood(
                                              food['id'],
                                              food['name'],
                                            ),
                                            style: TextButton.styleFrom(
                                              backgroundColor: isDarkMode
                                                  ? Colors.orange.withOpacity(
                                                      0.1,
                                                    )
                                                  : const Color(0xFFFFF5EB),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text(
                                              'Unblock',
                                              style: TextStyle(
                                                color: Color(0xFFFF9E44),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              bottom: _showNotification ? 84 : -100,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                    const SizedBox(width: 12),
                    Text(
                      _notificationText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
