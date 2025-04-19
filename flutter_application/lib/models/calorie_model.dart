class Meal {
  final String type;
  final int calories;
  final String imageUrl;

  Meal({required this.type, required this.calories, required this.imageUrl});
}

class MacroNutrients {
  final int carbohydrates;
  final int protein;
  final int fat;

  // Target values
  final int carbohydratesTarget;
  final int proteinTarget;
  final int fatTarget;

  MacroNutrients({
    required this.carbohydrates,
    required this.protein,
    required this.fat,
    required this.carbohydratesTarget,
    required this.proteinTarget,
    required this.fatTarget,
  });

  double get carbohydratesPercentage => carbohydrates / carbohydratesTarget;
  double get proteinPercentage => protein / proteinTarget;
  double get fatPercentage => fat / fatTarget;
}

class CalorieData {
  final String username;
  final String date;
  final int totalCalories;
  final int calorieGoal;
  final MacroNutrients macros;
  final List<Meal> meals;

  CalorieData({
    required this.username,
    required this.date,
    required this.totalCalories,
    required this.calorieGoal,
    required this.macros,
    required this.meals,
  });

  double get caloriePercentage => totalCalories / calorieGoal;
}
