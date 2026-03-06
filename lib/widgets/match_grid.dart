import 'package:flutter/material.dart';
import '../models/match_item.dart';
import 'match_card.dart';

class MatchGrid extends StatelessWidget {
  final List<MatchItem> matches;
  final Function(MatchItem) onFavoriteTap;
  final bool isManageMode;
  final Set<int> selectedIds;
  final Function(MatchItem) onSelectionChanged;
  final double bottomPadding;

  const MatchGrid({
    super.key,
    required this.matches,
    required this.onFavoriteTap,
    this.isManageMode = false,
    this.selectedIds = const {},
    required this.onSelectionChanged,
    this.bottomPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return MatchCard(
                match: match,
                onFavoriteTap: () => onFavoriteTap(match),
                isManageMode: isManageMode,
                isSelected: selectedIds.contains(match.foodId),
                onSelectionChanged: () => onSelectionChanged(match),
              );
            },
          ),
        ],
      ),
    );
  }
}
