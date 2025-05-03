/*
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

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      name: map['name'] ?? '',
      calories: map['calories'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      timestamp:
          map['timestamp'] != null
              ? DateTime.parse(map['timestamp'])
              : DateTime.now(),
    );
  }

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
*/



//changed in 21.15
/*
// lib/models/meal_model.dart
class Meal {
  final String id;
  final String name;
  final String type;
  final int calories;
  final String imageUrl;
  final String timestamp;

  Meal({
    required this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.imageUrl,
    required this.timestamp,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Meal',
      type: json['type'] ?? 'Other',
      calories: json['calories'] ?? 0,
      // Provide a default image URL if none exists
      imageUrl:
          json['imageUrl'] != null && json['imageUrl'].toString().isNotEmpty
              ? json['imageUrl']
              : 'https://via.placeholder.com/150?text=Meal',
      timestamp: json['timestamp'] ?? DateTime.now().toString().split(' ')[0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'calories': calories,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }
}
*/
// lib/models/meal_model.dart
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
