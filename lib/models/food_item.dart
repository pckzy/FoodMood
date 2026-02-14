class FoodItem {
  final String name;
  final String imageUrl;
  final String priceLevel;
  final List<String> tags;
  final int? typeId;
  final int? weatherId;

  FoodItem({
    required this.name,
    required this.imageUrl,
    required this.priceLevel,
    required this.tags,
    this.typeId,
    this.weatherId,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    // Convert price to priceLevel
    final price = json['price'];
    String priceLevel = '\฿';
    if (price != null) {
      if (price is num) {
        if (price > 300) {
          priceLevel = '\฿\฿\฿';
        } else if (price > 100) {
          priceLevel = '\฿\฿';
        }
      } else if (price is String) {
        // If price comes as string like '150'
        final p = int.tryParse(price);
        if (p != null) {
          if (p > 300)
            priceLevel = '\฿\฿\฿';
          else if (p > 100)
            priceLevel = '\฿\฿';
        }
      }
    }

    // Convert description to tags
    List<String> tags = [];
    if (json['description'] != null) {
      tags.add(json['description'].toString());
    }

    return FoodItem(
      name: json['name'] as String? ?? 'Unknown',
      imageUrl: json['image_url'] as String? ?? '',
      priceLevel: priceLevel, // Logic to determine price level
      tags: tags,
      typeId: json['type_id'] as int?,
      weatherId: json['weather_id'] as int?,
    );
  }
  FoodItem copyWith({
    String? name,
    String? imageUrl,
    String? priceLevel,
    List<String>? tags,
    int? typeId,
    int? weatherId,
  }) {
    return FoodItem(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      priceLevel: priceLevel ?? this.priceLevel,
      tags: tags ?? this.tags,
      typeId: typeId ?? this.typeId,
      weatherId: weatherId ?? this.weatherId,
    );
  }
}
