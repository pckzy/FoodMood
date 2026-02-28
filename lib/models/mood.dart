class Mood {
  final int id;
  final String name;
  final String imageUrl;

  Mood({required this.id, required this.name, required this.imageUrl});

  /// Create MoodOption from JSON
  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  /// Create a copy with modified fields
  Mood copyWith({int? id, String? name, String? imageUrl}) {
    return Mood(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
