import 'package:flutter/material.dart';
import '../models/match_item.dart';

class MatchCard extends StatefulWidget {
  final MatchItem match;
  final VoidCallback onFavoriteTap;
  final bool isManageMode;
  final bool isSelected;
  final VoidCallback? onSelectionChanged;

  const MatchCard({
    super.key,
    required this.match,
    required this.onFavoriteTap,
    this.isManageMode = false,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  Color _getBadgeColor(String type) {
    switch (type
        .replaceAll(RegExp(r'[^\x00-\x7F\u0E00-\u0E7F\s]'), '')
        .trim()
        .toLowerCase()) {
      case 'snack':
        return const Color(0xFFF4B400).withValues(alpha: 0.8);
      case 'drink':
        return const Color(0xFF4285F4).withValues(alpha: 0.8);
      case 'fruit':
        return const Color(0xFF34A853).withValues(alpha: 0.8);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.isManageMode ? widget.onSelectionChanged : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? colorScheme.secondary.withValues(alpha: 0.12)
              : colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: widget.isSelected
              ? Border.all(color: colorScheme.secondary, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(colorScheme),
            _buildTextSection(colorScheme),
            _buildInfoSection(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Image
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.match.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Food type badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getBadgeColor(widget.match.foodType),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.match.foodType,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Top-right: Checkbox (manage mode) or Favorite button (normal)
              Positioned(
                top: 8,
                right: 8,
                child: widget.isManageMode
                    ? _buildCheckbox(colorScheme)
                    : _buildFavoriteButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: widget.onFavoriteTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.match.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.match.isFavorite ? Colors.red : Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildCheckbox(ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: widget.isSelected
            ? colorScheme.secondary
            : Colors.black.withValues(alpha: 0.4),
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.isSelected ? colorScheme.secondary : Colors.white,
          width: 2,
        ),
      ),
      child: widget.isSelected
          ? const Icon(Icons.check, color: Colors.white, size: 16)
          : null,
    );
  }

  Widget _buildTextSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.match.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.match.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: colorScheme.secondary.withValues(alpha: 0.8),
            size: 12,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Matched ${widget.match.timeAgo}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
