import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/calorie_model.dart';

class CalorieApiService {
  final String baseUrl = 'http://10.0.2.2:8080/api'; // Use your backend URL here
  // Note: 10.0.2.2 refers to localhost on your development machine when using Android emulator
  // For iOS simulator, use 'localhost' or '127.0.0.1'
  
  // Get today's calorie data for user
  Future<CalorieData> getTodayCalorieData(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/calories/today/$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      return _convertToCalorieData(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load calorie data: ${response.statusCode}');
    }
  }
  
  // Add a meal
  Future<void> addMeal(String userId, Meal meal) async {
    // Convert meal to JSON format that matches backend
    final mealJson = {
      'type': meal.type,
      'name': meal.type, // Assuming type is the name
      'calories': meal.calories,
      'imageUrl': meal.imageUrl,
      'consumedAt': DateTime.now().toIso8601String(),
    };
    
    final response = await http.post(
      Uri.parse('$baseUrl/calories/meals/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mealJson),
    );
    
    if (response.statusCode != 201) {
      throw Exception('Failed to add meal: ${response.statusCode}');
    }
  }
  
  // Add recipe as meal
  Future<void> addRecipeAsMeal(String userId, String recipeId, String mealType) async {
    final response = await http.post(
      Uri.parse('$baseUrl/calories/meals/$userId/recipe/$recipeId?mealType=$mealType'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode != 201) {
      throw Exception('Failed to add recipe as meal: ${response.statusCode}');
    }
  }
  
  // Update calorie goal
  Future<void> updateCalorieGoal(String userId, int newGoal) async {
    final response = await http.put(
      Uri.parse('$baseUrl/calories/$userId/goal?goal=$newGoal'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update calorie goal: ${response.statusCode}');
    }
  }
  
  // Helper method to convert backend response to CalorieData model
  CalorieData _convertToCalorieData(Map<String, dynamic> json) {
    List<Meal> meals = [];
    if (json['meals'] != null) {
      for (var mealJson in json['meals']) {
        meals.add(Meal(
          type: mealJson['type'],
          calories: mealJson['calories'],
          imageUrl: mealJson['imageUrl'] ?? '',
        ));
      }
    }
    
    Map<String, dynamic> macrosJson = json['macros'] ?? {};
    
    return CalorieData(
      username: json['userId'] ?? 'User',
      date: 'Today, ${DateTime.now().day} ${_getMonthName(DateTime.now().month)}',
      totalCalories: json['totalCalories'] ?? 0,
      calorieGoal: json['calorieGoal'] ?? 2000,
      macros: MacroNutrients(
        carbohydrates: macrosJson['carbohydrates'] ?? 0,
        protein: macrosJson['protein'] ?? 0,
        fat: macrosJson['fat'] ?? 0,
        carbohydratesTarget: macrosJson['carbohydratesTarget'] ?? 300,
        proteinTarget: macrosJson['proteinTarget'] ?? 80,
        fatTarget: macrosJson['fatTarget'] ?? 60,
      ),
      meals: meals,
    );
  }
  
  String _getMonthName(int month) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month];
  }
}