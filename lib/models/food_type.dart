class FoodType {
  final int id;
  final String name;

  FoodType({required this.id, required this.name});

  factory FoodType.fromJson(Map<String, dynamic> json) {
    return FoodType(id: json['id'] as int, name: json['name'] as String);
  }

  FoodType copyWith({int? id, String? name}) {
    return FoodType(id: id ?? this.id, name: name ?? this.name);
  }
}
