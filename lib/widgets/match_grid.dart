import 'package:flutter/material.dart';
import '../models/match_item.dart';
import 'match_card.dart';

class MatchGrid extends StatelessWidget {
  final List<MatchItem> matches;
  final Function(MatchItem) onFavoriteTap;

  const MatchGrid({
    super.key,
    required this.matches,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
              return MatchCard(
                match: matches[index],
                onFavoriteTap: () => onFavoriteTap(matches[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
