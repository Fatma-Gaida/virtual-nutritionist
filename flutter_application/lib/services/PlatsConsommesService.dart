import 'package:http/http.dart' as http;
import 'dart:convert';

class PlatsConsommesService {
  final String baseUrl;

  PlatsConsommesService({required this.baseUrl});

  /// Add a meal to the consumed plates collection
  Future<bool> addConsumedPlate({
    required String userId,
    required String recipeId,
    required String mealType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/consumed-plates'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'recipeId': recipeId, 'meal': mealType}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding consumed plate: $e');
      return false;
    }
  }

  /// Get all consumed plates for a user on a specific date
  Future<List<ConsumedPlate>> getConsumedPlates({
    required String userId,
    String? date, // Format: YYYY-MM-DD, if null will use today
  }) async {
    try {
      String endpoint = '$baseUrl/users/$userId/consumed-plates';
      if (date != null) {
        endpoint += '?date=$date';
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => ConsumedPlate.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load consumed plates');
      }
    } catch (e) {
      print('Error getting consumed plates: $e');
      return [];
    }
  }

  /// Get total calories consumed by a user on a specific date
  Future<int> getTotalCaloriesConsumed({
    required String userId,
    String? date, // Format: YYYY-MM-DD, if null will use today
  }) async {
    try {
      String endpoint = '$baseUrl/users/$userId/consumed-plates/calories';
      if (date != null) {
        endpoint += '?date=$date';
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['totalCalories'] ?? 0;
      } else {
        throw Exception('Failed to load total calories');
      }
    } catch (e) {
      print('Error getting total consumed calories: $e');
      return 0;
    }
  }

  /// Delete a consumed plate
  Future<bool> deleteConsumedPlate({
    required String userId,
    required String consumedPlateId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$userId/consumed-plates/$consumedPlateId'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting consumed plate: $e');
      return false;
    }
  }
}

class ConsumedPlate {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int preparationTime;
  final int calories;
  final String mealType;
  final List<String> ingredients;
  final String userId;
  final DateTime dateConsommation;
  final String meal;

  ConsumedPlate({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.preparationTime,
    required this.calories,
    required this.mealType,
    required this.ingredients,
    required this.userId,
    required this.dateConsommation,
    required this.meal,
  });

  factory ConsumedPlate.fromJson(Map<String, dynamic> json) {
    return ConsumedPlate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      preparationTime: json['preparationTime'] ?? 0,
      calories: json['calories'] ?? 0,
      mealType: json['mealType'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      userId: json['userId'] ?? '',
      dateConsommation:
          json['dateConsommation'] != null
              ? DateTime.parse(json['dateConsommation'])
              : DateTime.now(),
      meal: json['meal'] ?? '',
    );
  }
}
