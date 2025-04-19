//import 'package:flutter/material.dart';
import '../services/calorie_api_service.dart';
import '../models/calorie_model.dart';

class CalorieRepository {
  final CalorieApiService _apiService = CalorieApiService();

  // Get today's calorie data
  Future<CalorieData> getTodayCalorieData({String? userId}) async {
    try {
      // If userId is provided, fetch from API
      if (userId != null) {
        return await _apiService.getTodayCalorieData(userId);
      }

      // Otherwise, use mock data (during development or when testing offline)
      return _getMockCalorieData();
    } catch (e) {
      //print('Error fetching calorie data: $e');
      // Fallback to mock data if API fails
      return _getMockCalorieData();
    }
  }

  // Add a meal
  Future<void> addMeal({required String userId, required Meal meal}) async {
    try {
      await _apiService.addMeal(userId, meal);
    } catch (e) {
      //print('Error adding meal: $e');
      rethrow;
    }
  }

  // Add recipe as meal
  Future<void> addRecipeAsMeal({
    required String userId,
    required String recipeId,
    required String mealType,
  }) async {
    try {
      await _apiService.addRecipeAsMeal(userId, recipeId, mealType);
    } catch (e) {
      //print('Error adding recipe as meal: $e');
      rethrow;
    }
  }

  // Update calorie goal
  Future<void> updateCalorieGoal({
    required String userId,
    required int newGoal,
  }) async {
    try {
      await _apiService.updateCalorieGoal(userId, newGoal);
    } catch (e) {
      //print('Error updating calorie goal: $e');
      rethrow;
    }
  }

  // Mock data for development and testing
  CalorieData _getMockCalorieData() {
    return CalorieData(
      username: 'HiAys',
      date: 'Today,4 Aug',
      totalCalories: 1500,
      calorieGoal: 2000,
      macros: MacroNutrients(
        carbohydrates: 190,
        protein: 80,
        fat: 40,
        carbohydratesTarget: 300,
        proteinTarget: 80,
        fatTarget: 60,
      ),
      meals: [
        Meal(
          type: 'Breakfast',
          calories: 230,
          imageUrl: 'assets/images/breakfast.png',
        ),
        Meal(type: 'Lunch', calories: 230, imageUrl: 'assets/images/lunch.png'),
        Meal(
          type: 'Breakfast', // Mislabeled in UI
          calories: 230,
          imageUrl: 'assets/images/dinner.png',
        ),
      ],
    );
  }
}
