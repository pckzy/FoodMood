class Weather {
  final int id;
  final String name;

  Weather({required this.id, required this.name});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(id: json['id'] as int, name: json['name'] as String);
  }

  Weather copyWith({int? id, String? name}) {
    return Weather(id: id ?? this.id, name: name ?? this.name);
  }
}
