

import 'package:flutter_application/models/meal_model.dart';

class CalorieData {
  final String username;
  final String date;
  final int totalCalories;
  final int calorieGoal;
  final double caloriePercentage;
  final List<Meal> meals;

  CalorieData({
    required this.username,
    required this.date,
    required this.totalCalories,
    required this.calorieGoal,
    required this.caloriePercentage,
    required this.meals,
  });

  factory CalorieData.fromMap(Map<String, dynamic> map) {
    List<Meal> parsedMeals = [];

    // Safely parse the meals field
    if (map['meals'] != null) {
      // Check if it's already a list
      if (map['meals'] is List) {
        parsedMeals =
            List<Map<String, dynamic>>.from(
              map['meals'],
            ).map((mealMap) => Meal.fromMap(mealMap)).toList();
      }
      // If it's a map with numeric keys (which can happen with some JSON encodings)
      else if (map['meals'] is Map) {
        final mealsMap = map['meals'] as Map;
        // Convert the map values to a list
        parsedMeals =
            mealsMap.values
                .map((meal) => Meal.fromMap(meal as Map<String, dynamic>))
                .toList();
      }
    }

    return CalorieData(
      username: map['username'] ?? '',
      date: map['date'] ?? '',
      totalCalories: map['totalCalories'] ?? 0,
      calorieGoal: map['calorieGoal'] ?? 0,
      caloriePercentage: map['caloriePercentage']?.toDouble() ?? 0.0,
      meals: parsedMeals,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'date': date,
      'totalCalories': totalCalories,
      'calorieGoal': calorieGoal,
      'caloriePercentage': caloriePercentage,
      'meals': meals.map((meal) => meal.toMap()).toList(),
    };
  }
}
