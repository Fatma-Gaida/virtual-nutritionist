import 'package:intl/intl.dart';
import 'meal_model.dart';

class CalorieData {
  final String nom;
  final String date;
  final int totalCalories;
  final int calorieGoal;
  final double caloriePercentage;
  final List<MealItem> meals;

  CalorieData({
    required this.nom,
    required this.date,
    required this.totalCalories,
    required this.calorieGoal,
    required this.caloriePercentage,
    required this.meals,
  });

  // Create an empty instance for error cases
  factory CalorieData.empty() {
    return CalorieData(
      nom: "Guest",
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      totalCalories: 0,
      calorieGoal: 2000,
      caloriePercentage: 0.0,
      meals: [],
    );
  }

  // Create from API response
  factory CalorieData.fromJson(Map<String, dynamic> json) {
    List<MealItem> mealsList = [];

    if (json['meals'] != null) {
      mealsList =
          (json['meals'] as List)
              .map((mealJson) => MealItem.fromJson(mealJson))
              .toList();
    }

    return CalorieData(
      nom: json['nom'] ?? 'User',
      date: json['date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      totalCalories: json['totalCalories'] ?? 0,
      calorieGoal: json['calorieGoal'] ?? 2000,
      caloriePercentage: json['caloriePercentage'] ?? 0.0,
      meals: mealsList,
    );
  }

  // Convert to Map for API requests
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'date': date,
      'totalCalories': totalCalories,
      'calorieGoal': calorieGoal,
      'caloriePercentage': caloriePercentage,
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }
}
