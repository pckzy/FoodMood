class MatchItem {
  final int foodId;
  final String name;
  final String description;
  final String imageUrl;
  final String foodType;
  final DateTime matchedAt;
  bool isFavorite;

  MatchItem({
    required this.foodId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.foodType,
    required this.matchedAt,
    required this.isFavorite,
  });

  /// สร้างจาก Supabase row ที่ join กับ foods แล้ว
  factory MatchItem.fromJson(Map<String, dynamic> json) {
    final food = json['foods'] as Map<String, dynamic>? ?? {};
    return MatchItem(
      foodId: json['food_id'] as int,
      name: food['name'] as String? ?? 'Unknown',
      description: food['description'] as String? ?? '',
      imageUrl: food['image_url'] as String? ?? '',
      foodType: food['food_types']?['name'] as String? ?? '',
      matchedAt: DateTime.parse(json['matched_at'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  /// แสดงเวลาที่ match แบบ human-readable
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(matchedAt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 14) return 'Last week';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
