import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/calorie_model.dart';
import '../models/meal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalorieRepository {
  // Replace with your actual API base URL
  final String baseUrl = 'http://localhost:8080/api';

  // Get user ID from shared preferences
  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) {
      throw Exception('User ID not found. Please log in.');
    }

    return userId;
  }

  // Get today's calorie data for the user
  Future<CalorieData> getTodayCalorieData() async {
    try {
      final userId = await getUserId();

      // Verify userId is not empty
      if (userId.isEmpty) {
        throw Exception('User ID is empty');
      }

      print('Fetching calorie data for user: $userId');

      // Make the API call to get today's calorie data
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/daily-plan'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('API Response: ${response.body}');
        final Map<String, dynamic> data = json.decode(response.body);
        return CalorieData.fromJson(data);
      } else {
        print('Failed to load data: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load calorie data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching calorie data: $e');
      rethrow; // Rethrow so the UI can handle it
    }
  }

  // Add a meal to consumed plates
  Future<void> addToConsumedPlates(String recipeId, String mealType) async {
    try {
      final userId = await getUserId();

      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/consumed-plates'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'recipeId': recipeId, 'meal': mealType}),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        print('Failed to add meal: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to add meal to consumed plates');
      }
    } catch (e) {
      print('Error adding meal: $e');
      rethrow;
    }
  }

  // Remove a meal by ID
  Future<void> removeMeal(String mealId) async {
    try {
      final userId = await getUserId();

      final response = await http.delete(
        Uri.parse('$baseUrl/users/$userId/daily-plan/meals/$mealId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        print('Failed to remove meal: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to remove meal');
      }
    } catch (e) {
      print('Error removing meal: $e');
      rethrow;
    }
  }

  // Get consumed meals history
  Future<List<dynamic>> getConsumedMealsHistory() async {
    try {
      final userId = await getUserId();

      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/consumed-plates'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        print('Failed to load consumed meals: ${response.statusCode}');
        throw Exception('Failed to load consumed meals');
      }
    } catch (e) {
      print('Error fetching consumed meals: $e');
      rethrow;
    }
  }
}
