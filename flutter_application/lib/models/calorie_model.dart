import 'meal_model.dart';
/*
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
/*
  // Factory constructor to create a CalorieData from a map (for JSON parsing)
  factory CalorieData.fromMap(Map<String, dynamic> map) {
    List<Meal> mealsList = [];
    if (map['meals'] != null) {
      mealsList =
          (map['meals'] as List).map((item) => Meal.fromMap(item)).toList();
    }

    return CalorieData(
      username: map['username'] ?? '',
      date: map['date'] ?? '',
      totalCalories: map['totalCalories'] ?? 0,
      calorieGoal: map['calorieGoal'] ?? 2000,
      caloriePercentage:
          (map['totalCalories'] ?? 0) / (map['calorieGoal'] ?? 2000),
      //meals: mealsList,
      meals: (map['meals'] as List).map((m) => Meal.fromMap(m)).toList(),
    );
  }
*/
  factory CalorieData.fromMap(Map<String, dynamic> map) {
    List<Meal> mealsList = [];
    if (map['meals'] != null) {
      mealsList =
          (map['meals'] as List).map((item) => Meal.fromMap(item)).toList();
    }

    return CalorieData(
      username: map['username'] ?? '',
      date: map['date'] ?? '',
      totalCalories: map['totalCalories'] ?? 0,
      calorieGoal: map['calorieGoal'] ?? 2000,
      caloriePercentage:
          (map['totalCalories'] ?? 0) / (map['calorieGoal'] ?? 2000),
      meals: mealsList, // Use the parsed list instead of parsing again
    );
  }
  // Convert to map for sending to API
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
*/


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
