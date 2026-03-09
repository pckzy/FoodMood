import 'package:foodmood/models/food_type.dart';
import 'package:foodmood/models/mood.dart';
import 'package:foodmood/models/weather.dart';

class FoodItem {
  final int? id;
  final String name;
  final String imageUrl;
  final int price;
  final String description;
  final FoodType? type;
  final List<Weather> weathers;
  final List<Mood> moods;
  final bool halal;
  final bool isVegetable;
  final int spicyLevel;

  FoodItem({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    this.type,
    this.weathers = const [],
    this.moods = const [],
    this.halal = false,
    this.isVegetable = false,
    this.spicyLevel = 0,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as int?,
      name: json['name'] as String? ?? 'Unknown',
      imageUrl: json['image_url'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      type: json['food_types'] != null
          ? FoodType.fromJson(json['food_types'])
          : null,
      moods: json['foods_moods'] != null
          ? (json['foods_moods'] as List)
                .where((m) => m['moods'] != null)
                .map((m) => Mood.fromJson(m['moods']))
                .toList()
          : [],
      weathers: json['foods_weathers'] != null
          ? (json['foods_weathers'] as List)
                .where((w) => w['weathers'] != null)
                .map((w) => Weather.fromJson(w['weathers']))
                .toList()
          : [],
      halal: json['halal'] as bool? ?? false,
      isVegetable: json['is_vegan'] as bool? ?? false,
      spicyLevel: json['spicy_level'] as int? ?? 0,
    );
  }

  FoodItem copyWith({
    int? id,
    String? name,
    String? imageUrl,
    int? price,
    String? description,
    FoodType? type,
    List<Weather>? weathers,
    List<Mood>? moods,
    bool? halal,
    bool? isVegetable,
    int? spicyLevel,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      description: description ?? this.description,
      type: type ?? this.type,
      weathers: weathers ?? this.weathers,
      moods: moods ?? this.moods,
      halal: halal ?? this.halal,
      isVegetable: isVegetable ?? this.isVegetable,
      spicyLevel: spicyLevel ?? this.spicyLevel,
    );
  }
}
