class MealItem {
  final String id;
  final String type;
  final String name;
  final int calories;
  final String imageUrl;
  final String timestamp;

  MealItem({
    required this.id,
    required this.type,
    required this.name,
    required this.calories,
    required this.imageUrl,
    required this.timestamp,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      calories: json['calories'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'calories': calories,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }
}
