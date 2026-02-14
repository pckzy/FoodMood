import 'package:flutter/material.dart';
import 'package:foodmood/models/mood_option.dart';

class MoodCard extends StatelessWidget {
  final MoodOption mood;
  final bool isSelected;
  final Color primaryColor;
  final Color cardColor;
  final Color textColor;
  final VoidCallback onTap;

  const MoodCard({
    Key? key,
    required this.mood,
    required this.isSelected,
    required this.primaryColor,
    required this.cardColor,
    required this.textColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  // Background image from Supabase storage
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      color: cardColor,
                      child: mood.imageUrl.isNotEmpty
                          ? Image.network(
                              mood.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: primaryColor.withOpacity(0.5),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: cardColor,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: textColor.withOpacity(0.5),
                                    size: 50,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: textColor.withOpacity(0.5),
                                size: 50,
                              ),
                            ),
                    ),
                  ),
                  // Overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ),
                  // Check icon
                  if (isSelected)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mood.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? primaryColor : textColor,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}