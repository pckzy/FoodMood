import 'package:flutter/material.dart';
import 'package:foodmood/models/mood.dart';
import 'package:foodmood/services/mood_service.dart';
import 'package:foodmood/widgets/mood_card.dart';

class MoodSelectionSection extends StatefulWidget {
  final String? selectedMood;
  final Function(String) onMoodSelected;
  final Color primaryColor;
  final Color cardColor;
  final Color textColor;
  final Color subtextColor;
  final Function(List<Mood>) onMoodsLoaded;

  const MoodSelectionSection({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
    required this.primaryColor,
    required this.cardColor,
    required this.textColor,
    required this.subtextColor,
    required this.onMoodsLoaded,
  });

  @override
  State<MoodSelectionSection> createState() => _MoodSelectionSectionState();
}

class _MoodSelectionSectionState extends State<MoodSelectionSection> {
  final MoodService _moodService = MoodService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How are you feeling?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select a vibe to start',
                style: TextStyle(
                  fontSize: 14,
                  color: widget.subtextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        FutureBuilder<List<Mood>>(
          future: _moodService.fetchMoods(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'Error loading moods',
                    style: TextStyle(color: widget.textColor),
                  ),
                ),
              );
            }

            final moods = snapshot.data ?? [];
            if (moods.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  widget.onMoodsLoaded(moods);
                }
              });
            }

            if (moods.isEmpty) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'No moods available',
                    style: TextStyle(color: widget.subtextColor),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                itemCount: moods.length,
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  final isSelected = widget.selectedMood == mood.name;
                  return MoodCard(
                    mood: mood,
                    isSelected: isSelected,
                    primaryColor: widget.primaryColor,
                    cardColor: widget.cardColor,
                    textColor: widget.textColor,
                    onTap: () {
                      widget.onMoodSelected(mood.name);
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
