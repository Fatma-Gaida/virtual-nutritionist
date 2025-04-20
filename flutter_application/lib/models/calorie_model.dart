import 'meal_model.dart';

class CalorieData {
  final String username;
  final String date;
  final int totalCalories;
  final int calorieGoal;
  final double caloriePercentage;
  final List<Meal> meals;
  // Removed macros as you mentioned they're not being used for now

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
      meals: mealsList,
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
