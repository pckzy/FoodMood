import 'package:flutter/material.dart';
import 'package:foodmood/models/food_type.dart';
import 'package:foodmood/services/food_type_service.dart';
import 'package:foodmood/widgets/food_type_button.dart';

class FoodTypeSelectionSection extends StatefulWidget {
  final String? selectedFoodType;
  final Function(String) onFoodTypeSelected;
  final Color primaryColor;
  final Color cardColor;
  final Color textColor;
  final Color subtextColor;
  final Function(List<FoodType>) onFoodTypesLoaded;

  const FoodTypeSelectionSection({
    Key? key,
    required this.selectedFoodType,
    required this.onFoodTypeSelected,
    required this.primaryColor,
    required this.cardColor,
    required this.textColor,
    required this.subtextColor,
    required this.onFoodTypesLoaded,
  }) : super(key: key);

  @override
  State<FoodTypeSelectionSection> createState() =>
      _FoodTypeSelectionSectionState();
}

class _FoodTypeSelectionSectionState extends State<FoodTypeSelectionSection> {
  final FoodTypeService _foodTypeService = FoodTypeService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Food type',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select your preferred category',
                style: TextStyle(
                  fontSize: 14,
                  color: widget.subtextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        FutureBuilder<List<FoodType>>(
          future: _foodTypeService.fetchFoodTypes(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Error loading food types',
                  style: TextStyle(color: widget.textColor),
                ),
              );
            }

            final foodTypes = snapshot.data ?? [];
            if (foodTypes.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  widget.onFoodTypesLoaded(foodTypes);
                }
              });
            }

            if (foodTypes.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'No food types available',
                  style: TextStyle(color: widget.subtextColor),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: foodTypes.map((foodType) {
                  return FoodTypeButton(
                    foodType.name,
                    widget.primaryColor,
                    widget.cardColor,
                    widget.textColor,
                    isSelected: widget.selectedFoodType == foodType.name,
                    onTap: () {
                      widget.onFoodTypeSelected(foodType.name);
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
