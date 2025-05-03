

/*
import 'package:flutter_application/models/meal_model.dart';

class CalorieData {
  final String nom;
  final String date;
  final int totalCalories;
  final int calorieGoal;
  final double caloriePercentage;
  final List<Meal> meals;

  CalorieData({
    required this.nom,
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
      nom: map['nom'] ?? '',
      date: map['date'] ?? '',
      totalCalories: map['totalCalories'] ?? 0,
      calorieGoal: map['calorieGoal'] ?? 0,
      caloriePercentage: map['caloriePercentage']?.toDouble() ?? 0.0,
      meals: parsedMeals,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'date': date,
      'totalCalories': totalCalories,
      'calorieGoal': calorieGoal,
      'caloriePercentage': caloriePercentage,
      'meals': meals.map((meal) => meal.toMap()).toList(),
    };
  }
}
*/


//changed in 21:18
/*
// lib/models/calorie_model.dart
import 'package:flutter_application/models/meal_model.dart';

class CalorieData {
  final String nom;
  final String date;
  final int totalCalories;
  final int calorieGoal;
  final double caloriePercentage;
  final List<Meal> meals;

  CalorieData({
    required this.nom,
    required this.date,
    required this.totalCalories,
    required this.calorieGoal,
    required this.caloriePercentage,
    required this.meals,
  });

  factory CalorieData.fromJson(Map<String, dynamic> json) {
    // Parse the meals list from JSON
    List<Meal> mealsList = [];
    if (json['meals'] != null) {
      mealsList = List<Meal>.from(
        (json['meals'] as List).map((mealJson) => Meal.fromJson(mealJson)),
      );
    }

    return CalorieData(
      nom: json['nom'] ?? 'User',
      date: json['date'] ?? DateTime.now().toString().split(' ')[0],
      totalCalories: json['totalCalories'] ?? 0,
      calorieGoal: json['calorieGoal'] ?? 2000,
      caloriePercentage: json['caloriePercentage']?.toDouble() ?? 0.0,
      meals: mealsList,
    );
  }

  // Empty data constructor for loading state
  factory CalorieData.empty() {
    return CalorieData(
      nom: 'Loading...',
      date: DateTime.now().toString().split(' ')[0],
      totalCalories: 0,
      calorieGoal: 2000,
      caloriePercentage: 0.0,
      meals: [],
    );
  }
}
*/
// lib/models/calorie_model.dart
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
