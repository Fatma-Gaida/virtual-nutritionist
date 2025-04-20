// ignore: unused_import
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/meal_model.dart';
import '../models/calorie_model.dart';
import 'api_service.dart';

class CalorieApiService {
  final ApiService _apiService = ApiService();

  // Get today's calorie data for user
  Future<CalorieData> getTodayCalorieData(String userId) async {
    try {
      final response = await _apiService.get('/calories/today/$userId');
      return _convertToCalorieData(response.data);
    } catch (e) {
      debugPrint('Failed to load calorie data: $e');
      throw Exception('Failed to load calorie data');
    }
  }

  // Add a meal
  Future<void> addMeal(String userId, Meal meal) async {
    // Convert meal to JSON format that matches backend
    final mealJson = {
      'id': meal.id,
      'type': meal.type,
      'name': meal.name,
      'calories': meal.calories,
      'imageUrl': meal.imageUrl,
      'timestamp': meal.timestamp.toIso8601String(),
    };

    try {
      await _apiService.post('/calories/meals/$userId', mealJson);
    } catch (e) {
      debugPrint('Failed to add meal: $e');
      throw Exception('Failed to add meal');
    }
  }

  // Add recipe as meal
  Future<void> addRecipeAsMeal(
    String userId,
    String recipeId,
    String mealType,
  ) async {
    try {
      await _apiService.post('/calories/meals/$userId/recipe/$recipeId', {
        'mealType': mealType,
      });
    } catch (e) {
      debugPrint('Failed to add recipe as meal: $e');
      throw Exception('Failed to add recipe as meal');
    }
  }

  // Update calorie goal
  Future<void> updateCalorieGoal(String userId, int newGoal) async {
    try {
      await _apiService.post('/calories/$userId/goal', {'goal': newGoal});
    } catch (e) {
      debugPrint('Failed to update calorie goal: $e');
      throw Exception('Failed to update calorie goal');
    }
  }

  // Helper method to convert backend response to CalorieData model
  CalorieData _convertToCalorieData(Map<String, dynamic> json) {
    List<Meal> meals = [];
    if (json['meals'] != null) {
      for (var mealJson in json['meals']) {
        meals.add(
          Meal(
            id: mealJson['id'] ?? '',
            type: mealJson['type'] ?? '',
            name: mealJson['name'] ?? '',
            calories: mealJson['calories'] ?? 0,
            imageUrl: mealJson['imageUrl'] ?? '',
            timestamp:
                mealJson['timestamp'] != null
                    ? DateTime.parse(mealJson['timestamp'])
                    : DateTime.now(),
          ),
        );
      }
    }

    return CalorieData(
      username: json['username'] ?? 'User',
      date: json['date'] ?? _formatToday(),
      totalCalories: json['totalCalories'] ?? 0,
      calorieGoal: json['calorieGoal'] ?? 2000,
      caloriePercentage: json['caloriePercentage'] ?? 0.0,
      meals: meals,
    );
  }

  String _formatToday() {
    final now = DateTime.now();
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return 'Today, ${now.day} ${months[now.month]}';
  }
}
