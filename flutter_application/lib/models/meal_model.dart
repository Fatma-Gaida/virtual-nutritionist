class Meal {
  final String id;
  final String type;
  final String name;
  final int calories;
  final String imageUrl;
  final DateTime timestamp;

  Meal({
    required this.id,
    required this.type,
    required this.name,
    required this.calories,
    required this.imageUrl,
    required this.timestamp,
  });

  // Factory constructor to create a Meal from a map (for JSON parsing)
  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] ?? map['_id']?.toString() ?? '',
      type: map['type'] ?? '',
      name: map['name'] ?? '',
      calories: map['calories'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      timestamp:
          map['timestamp'] != null
              ? map['timestamp'] is String
                  ? DateTime.parse(map['timestamp'])
                  : DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
              : DateTime.now(),
    );
  }

  // Convert to map for sending to API
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'calories': calories,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
