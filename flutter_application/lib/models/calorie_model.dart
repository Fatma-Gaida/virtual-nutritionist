import 'meal_model.dart';
import 'package:intl/intl.dart';

class CalorieData {
  final String username;
  final DateTime date;
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

  // Factory constructor to create a CalorieData from a map (for JSON parsing)
  factory CalorieData.fromMap(Map<String, dynamic> map) {
    List<Meal> mealsList = [];
    if (map['meals'] != null) {
      // The issue might be here - check if map['meals'] is actually a List
      if (map['meals'] is List) {
        mealsList =
            (map['meals'] as List).map((item) => Meal.fromMap(item)).toList();
      } else {
        print(
          'Warning: Expected meals to be a List but got ${map['meals'].runtimeType}',
        );
        // Handle the case where meals is not a list
      }
    }

    // Parse the date properly
    DateTime parsedDate;
    try {
      if (map['date'] != null) {
        if (map['date'] is String) {
          parsedDate = DateTime.parse(map['date']);
        } else if (map['date'] is DateTime) {
          parsedDate = map['date'];
        } else {
          parsedDate = DateTime.now();
        }
      } else {
        parsedDate = DateTime.now();
      }
    } catch (e) {
      parsedDate = DateTime.now();
    }

    return CalorieData(
      username: map['username'] ?? '',
      date: parsedDate,
      totalCalories: map['totalCalories'] ?? 0,
      calorieGoal: map['calorieGoal'] ?? 2000,
      caloriePercentage:
          (map['totalCalories'] ?? 0) / (map['calorieGoal'] ?? 2000),
      meals: mealsList,
    );
  }

  // Convert to map for sending to API
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'date': date.toIso8601String(),
      'totalCalories': totalCalories,
      'calorieGoal': calorieGoal,
      'caloriePercentage': caloriePercentage,
      'meals': meals.map((meal) => meal.toMap()).toList(),
    };
  }
}
