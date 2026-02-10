class MoodOption {
  final String name;
  final String imageUrl;

  MoodOption({
    required this.name,
    required this.imageUrl,
  });

  /// Create MoodOption from JSON
  factory MoodOption.fromJson(Map<String, dynamic> json) {
    return MoodOption(
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  /// Convert MoodOption to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image_url': imageUrl,
    };
  }

  /// Create a copy with modified fields
  MoodOption copyWith({
    String? name,
    String? imageUrl,
  }) {
    return MoodOption(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}