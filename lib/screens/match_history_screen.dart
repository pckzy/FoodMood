import 'package:flutter/material.dart';
import '../widgets/match_header.dart';
import '../widgets/filter_chips.dart';
import '../widgets/match_grid.dart';
import '../widgets/confirm_dialog.dart';
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

  // Manage mode state
  bool _isManageMode = false;
  final Set<int> _selectedIds = {};

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
      }
    }
  }

  void _onFilterChanged(String filter) {
    setState(() => _selectedFilter = filter);
  }

  void _toggleManageMode() {
    setState(() {
      _isManageMode = !_isManageMode;
      if (!_isManageMode) {
        // Cancel — clear selection
        _selectedIds.clear();
      }
    });
  }

  void _toggleSelection(MatchItem match) {
    setState(() {
      if (_selectedIds.contains(match.foodId)) {
        _selectedIds.remove(match.foodId);
      } else {
        _selectedIds.add(match.foodId);
      }
    });
  }

  Future<void> _deleteSelected() async {
    if (_selectedIds.isEmpty) return;

    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Remove from Matches',
      content: 'Remove ${_selectedIds.length} item(s) from your match history?',
      confirmLabel: 'Remove',
      confirmColor: Colors.red,
    );
    if (!confirmed) return;

    try {
      for (final foodId in _selectedIds) {
        await _matchService.deleteMatch(foodId);
      }
      if (mounted) {
        setState(() {
          _matches.removeWhere((m) => _selectedIds.contains(m.foodId));
          _selectedIds.clear();
          _isManageMode = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _blacklistSelected() async {
    if (_selectedIds.isEmpty) return;

    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Add to Blacklist',
      content:
          'Add ${_selectedIds.length} item(s) to blacklist? You won\'t see them in future recommendations.',
      confirmLabel: 'Blacklist',
      confirmColor: Colors.deepOrange,
    );
    if (!confirmed) return;

    try {
      for (final foodId in _selectedIds) {
        await _matchService.blacklistFood(foodId);
      }
      if (mounted) {
        setState(() {
          _matches.removeWhere((m) => _selectedIds.contains(m.foodId));
          _selectedIds.clear();
          _isManageMode = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }


  List<MatchItem> get _filteredMatches {
    List<MatchItem> filtered = List.from(_matches);

    switch (_selectedFilter) {
      case 'Recent':
        filtered.sort((a, b) => b.matchedAt.compareTo(a.matchedAt));
        break;
      case 'Snacks':
        filtered = filtered
            .where(
              (m) =>
                  m.foodType
                      .replaceAll(RegExp(r'[^\x00-\x7F\u0E00-\u0E7F\s]'), '')
                      .trim()
                      .toLowerCase() ==
                  'snack',
            )
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
      body: Stack(
        children: [
          Column(
            children: [
              MatchHeader(
                onManageTap: _toggleManageMode,
                isManageMode: _isManageMode,
              ),
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
                            isManageMode: _isManageMode,
                            selectedIds: _selectedIds,
                            onSelectionChanged: _toggleSelection,
                            bottomPadding: _isManageMode ? 160 : 80,
                          ),

              ),
            ],
          ),
          // Pinned above the bottom nav bar (nav bar is 80 px tall)
          if (_isManageMode)
            Positioned(
              left: 10,
              right: 10,
              bottom: 88,
              child: _buildActionBar(isDark),
            )
        ],
      ),
    );
  }

  Widget _buildActionBar(bool isDark) {
    final hasSelection = _selectedIds.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFFf8f7f5) : const Color(0xFF221910),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Selection count badge
          Expanded(
            child: Text(
              hasSelection
                  ? '${_selectedIds.length} selected'
                  : 'Select items to manage',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.black.withOpacity(0.45) : Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Delete button
          _buildActionChip(
            label: 'Delete',
            icon: Icons.delete_outline,
            color: Colors.red,
            enabled: hasSelection,
            onTap: _deleteSelected,
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          // Blacklist button
          _buildActionChip(
            label: 'Blacklist',
            icon: Icons.block,
            color: Colors.deepOrange,
            enabled: hasSelection,
            onTap: _blacklistSelected,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required String label,
    required IconData icon,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: enabled
              ? color.withOpacity(0.12)
              : (isDark
                    ? Colors.black.withOpacity(0.04)
                    : Colors.white.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: enabled ? color.withOpacity(0.4) : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: enabled
                  ? color
                  : (isDark
                        ? Colors.black.withOpacity(0.25)
                        : Colors.white.withOpacity(0.3)),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: enabled
                    ? color
                    : (isDark
                          ? Colors.black.withOpacity(0.25)
                          : Colors.white.withOpacity(0.3)),
              ),
            ),
          ],
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
