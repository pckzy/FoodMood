import 'package:flutter/material.dart';
import '../widgets/match_header.dart';
import '../widgets/filter_chips.dart';
import '../widgets/match_grid.dart';
import '../models/match_item.dart';
import '../services/match_service.dart';

class MatchHistoryScreen extends StatefulWidget {
  final bool isActive;
  const MatchHistoryScreen({Key? key, this.isActive = false}) : super(key: key);

  @override
  State<MatchHistoryScreen> createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends State<MatchHistoryScreen> {
  String _selectedFilter = 'All';
  bool _isLoading = true;
  List<MatchItem> _matches = [];

  final MatchService _matchService = MatchService();

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  @override
  void didUpdateWidget(MatchHistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // refresh data when screen is active
    if (widget.isActive && !oldWidget.isActive) {
      _loadMatches();
    }
  }

  Future<void> _loadMatches() async {
    debugPrint('Loading matches...');
    setState(() => _isLoading = true);
    final matches = await _matchService.fetchUserMatches();
    if (mounted) {
      setState(() {
        _matches = matches;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(MatchItem match) async {
    final newFavoriteStatus = !match.isFavorite;

    // Optimistically update UI
    setState(() {
      match.isFavorite = newFavoriteStatus;
    });

    try {
      await _matchService.updateMatchFavorite(match.foodId, newFavoriteStatus);
    } catch (e) {
      // Revert UI if update fails
      if (mounted) {
        setState(() {
          match.isFavorite = !newFavoriteStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update favorite')),
        );
      }
    }
  }

  void _onFilterChanged(String filter) {
    setState(() => _selectedFilter = filter);
  }

  List<MatchItem> get _filteredMatches {
    List<MatchItem> filtered = List.from(_matches);

    switch (_selectedFilter) {
      case 'Recent':
        filtered.sort((a, b) => b.matchedAt.compareTo(a.matchedAt));
        break;
      case 'Snacks':
        filtered = filtered
            .where((m) => m.foodType.replaceAll(RegExp(r'[^\x00-\x7F\u0E00-\u0E7F\s]'), '')
                    .trim().toLowerCase() == 'snack')
            .toList();
        filtered.sort((a, b) => b.matchedAt.compareTo(a.matchedAt));
        break;
      case 'Favorites':
        filtered = filtered.where((m) => m.isFavorite).toList();
        filtered.sort((a, b) => b.matchedAt.compareTo(a.matchedAt));
        break;
      default:
        filtered.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF221910)
        : const Color(0xFFf8f7f5);

    final displayMatches = _filteredMatches;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          MatchHeader(onManageTap: () {}),
          FilterChips(
            selectedFilter: _selectedFilter,
            onFilterChanged: _onFilterChanged,
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayMatches.isEmpty
                ? _buildEmptyState()
                : MatchGrid(
                    matches: displayMatches,
                    onFavoriteTap: _toggleFavorite,
                  ),
          ),
        ],
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2c2219) : const Color(0xFFf4ede7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant,
              size: 36,
              color: isDark
                  ? const Color(0xFFf48c25).withOpacity(0.5)
                  : const Color(0xFF9c7349),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No matches yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1c140d),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Swipe right on foods you like to create a match!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? Colors.white.withOpacity(0.5)
                  : Colors.black.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
