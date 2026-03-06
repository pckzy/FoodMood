class FoodItem {
  final int? id;
  final String name;
  final String imageUrl;
  final int price;
  final String description;
  final int? typeId;
  final int? weatherId;
  final bool halal;
  final bool isVegetable;
  final int spicyLevel;

  FoodItem({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    this.typeId,
    this.weatherId,
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
      typeId: json['type_id'] as int?,
      weatherId: json['weather_id'] as int?,
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
    int? typeId,
    int? weatherId,
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
      typeId: typeId ?? this.typeId,
      weatherId: weatherId ?? this.weatherId,
      halal: halal ?? this.halal,
      isVegetable: isVegetable ?? this.isVegetable,
      spicyLevel: spicyLevel ?? this.spicyLevel,
    );
  }
}
