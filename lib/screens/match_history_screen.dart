import 'package:flutter/material.dart';
import '../widgets/match_header.dart';
import '../widgets/filter_chips.dart';
import '../widgets/match_grid.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/manage_action_bar.dart';
import '../widgets/empty_match_state.dart';
import '../models/match_item.dart';
import '../services/match_service.dart';

class MatchHistoryScreen extends StatefulWidget {
  final bool isActive;
  const MatchHistoryScreen({super.key, this.isActive = false});

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
            .where((m) => m.foodType.toLowerCase().contains('snack'))
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
    final colorScheme = Theme.of(context).colorScheme;

    final displayMatches = _filteredMatches;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                        ? EmptyMatchState(filter: _selectedFilter.toLowerCase())
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
          // Animated ManageActionBar pinned above the bottom nav bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: 10,
            right: 10,
            bottom: _isManageMode ? 88 : -100, // Slides off-screen when not in manage mode
            child: ManageActionBar(
              selectedCount: _selectedIds.length,
              onDelete: _deleteSelected,
              onBlacklist: _blacklistSelected,
            ),
          )
        ],
      ),
    );
  }


}
