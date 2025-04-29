/*
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calorie_model.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';

class CalorieRepository {
  final ApiService _apiService = ApiService();
  final uuid = Uuid();

  // Get today's user's calorie data
  Future<CalorieData> getTodayCalorieData() async {
    try {
      /*
      // Get current user ID
      final userId = await _getCurrentUserId();

      // Log the user ID to verify it's correct
      print('Fetching calorie data for user: $userId');

      // Call the API through your service
      // Make sure this endpoint matches your backend controller
      final response = await _apiService.get('/users/$userId/daily-plan');

      // Parse the response
      if (response.statusCode == 200) {
        return CalorieData.fromMap(response.data);
      } else if (response.statusCode == 404) {
        // If not found, create new calorie data for today
        return await _createNewCalorieData(userId);
      } else {
        throw Exception('Failed to load calorie data: ${response.statusCode}');
      }
      */
        final userId = await _getCurrentUserId();
        final response = await _apiService.get('/users/$userId/daily-plan');

        if (response.statusCode == 200) {
          // Try parsing the direct response first
            try {
              return CalorieData.fromMap(response.data);
            } catch (e) {
              // If that fails, try parsing from the nested 'data' field
              if (response.data['data'] != null) {
                return CalorieData.fromMap(response.data['data']);
              } else {
                throw Exception('Unexpected response format');
              }
            }
        }else if (response.statusCode == 404) {
          return await _createNewCalorieData(userId);
        } else {
          throw Exception('Failed to load calorie data: ${response.statusCode}');
        }
    } catch (e) {
      print('Error getting calorie data: $e');

      // Check if the error is due to the user not being logged in
      if (e.toString().contains('User not logged in')) {
        print('User is not logged in, returning default data');
        // Return default data only if user is not logged in
        return CalorieData(
          username: 'Guest',
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          totalCalories: 0,
          calorieGoal: 2000,
          caloriePercentage: 0.0,
          meals: [],
        );
      }

      // Rethrow other errors to help with debugging
      throw Exception('Failed to load calorie data: $e');
    }
  }

  // Create new calorie data for today
  Future<CalorieData> _createNewCalorieData(String userId) async {
    try {
      // Get user profile to get calorie goal and username
      final response = await _apiService.get('/users/$userId');

      if (response.statusCode != 200) {
        throw Exception('Failed to get user data: ${response.statusCode}');
      }

      final userData = response.data;

      final username =
          userData['nom'] ??
          'User'; // Changed from 'name' to 'nom' to match User model
      final calorieGoal = userData['calorieGoal'] ?? 2000;
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Create empty calorie data
      final calorieData = CalorieData(
        username: username,
        date: today,
        totalCalories: 0,
        calorieGoal: calorieGoal,
        caloriePercentage: 0.0,
        meals: [],
      );

      // Save to backend
      await _apiService.post('/users/$userId/daily-plan', calorieData.toMap());

      return calorieData;
    } catch (e) {
      print('Error creating calorie data: $e');
      throw Exception('Failed to create new calorie data: $e');
    }
  }

  // Add a meal to today's calories
  Future<void> addMealToToday({
    required String type,
    required String name,
    required int calories,
    required String imageUrl,
  }) async {
    try {
      final userId = await _getCurrentUserId();

      // Create new meal
      final meal = Meal(
        id: uuid.v4(),
        type: type,
        name: name,
        calories: calories,
        imageUrl: imageUrl,
        timestamp: DateTime.now(),
      );

      // Send to backend API
      await _apiService.post('/users/$userId/daily-plan/meals', meal.toMap());
    } catch (e) {
      print('Error adding meal: $e');
      throw Exception('Failed to add meal: $e');
    }
  }

  // Get calorie data for a specific date
  Future<CalorieData> getCalorieDataForDate(DateTime date) async {
    try {
      final userId = await _getCurrentUserId();
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      final response = await _apiService.get(
        '/users/$userId/daily-plan?date=$dateStr',
      );

      if (response.statusCode == 200) {
        return CalorieData.fromMap(response.data);
      } else if (response.statusCode == 404) {
        // Create new data if not found
        return await _createNewCalorieData(userId);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting calorie data for date: $e');
      throw Exception('Failed to load calorie data: $e');
    }
  }

  // Remove a meal
  Future<void> removeMeal(String mealId) async {
    try {
      final userId = await _getCurrentUserId();

      await _apiService.delete('/users/$userId/daily-plan/meals/$mealId');
    } catch (e) {
      print('Error removing meal: $e');
      throw Exception('Failed to remove meal: $e');
    }
  }

  // Helper method to get current user ID
  Future<String> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) {
      throw Exception('User not logged in');
    }

    return userId;
  }


  Future<dynamic> getConsumedMealsForUser(String userId) async {
    return await _apiService.get('/users/$userId/plats-consommes');
  }

  Future<String> getCurrentUserId() async {
    return await _getCurrentUserId();
  }
}
*/
















//before last edit from claude 29/04/2025 06/07heure du matin :) ********************************
/*
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calorie_model.dart';
import '../models/meal_model.dart';
import '../services/calorie_api_service.dart';

class CalorieRepository {
  final CalorieApiService _apiService = CalorieApiService();
  final uuid = Uuid();

  // Get today's user's calorie data
  Future<CalorieData> getTodayCalorieData() async {
    try {
      final String userId = await _getCurrentUserId();
      //final dynamic response = await _apiService.getTodayCalorieData(userId);

      final response = await _apiService.getTodayCalorieData(userId);
      print('API Response structure: ${response.runtimeType}');
      print('API Response data: $response');

      // Check if data was found
      if (response['status'] == 'not_found') {
        return await _createNewCalorieData(userId);
      }

      // If there's a data field:
      if (response['data'] != null) {
        print('Data field structure: ${response['data'].runtimeType}');
        print('Data field content: ${response['data']}');
      }

      // Check meals specifically
      if (response['meals'] != null) {
        print('Meals structure: ${response['meals'].runtimeType}');
      }

      // Try parsing the response data
      try {
        // First try direct parsing
        if (response is Map<String, dynamic>) {
          return CalorieData.fromMap(response);
        }
        // Then try from 'data' field if it exists
        else if (response['data'] != null) {
          return CalorieData.fromMap(response['data']);
        } else {
          throw Exception('Unexpected response format');
        }
      } catch (e) {
        print('Error parsing calorie data: $e');
        throw Exception('Failed to parse calorie data: $e');
      }
    } catch (e) {
      print('Error getting calorie data: $e');

      // Return default data for guest users
      if (e.toString().contains('User not logged in')) {
        print('User is not logged in, returning default data');
        return CalorieData(
          username: 'Guest',
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          totalCalories: 0,
          calorieGoal: 2000,
          caloriePercentage: 0.0,
          meals: [],
        );
      }

      throw Exception('Failed to load calorie data: $e');
    }
  }

  // Create new calorie data for today
  Future<CalorieData> _createNewCalorieData(String userId) async {
    try {
      // Get user profile to get calorie goal and username
      final userData = await _apiService.getUserDetails(userId);

      final username = userData['nom'] ?? 'User';
      final calorieGoal = userData['calorieGoal'] ?? 2000;
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Create empty calorie data
      final calorieData = CalorieData(
        username: username,
        date: today,
        totalCalories: 0,
        calorieGoal: calorieGoal,
        caloriePercentage: 0.0,
        meals: [],
      );

      // Save to backend
      await _apiService.createDailyPlan(userId, calorieData.toMap());

      return calorieData;
    } catch (e) {
      print('Error creating calorie data: $e');
      throw Exception('Failed to create new calorie data: $e');
    }
  }

  // Add a meal to today's calories
  Future<void> addMealToToday({
    required String type,
    required String name,
    required int calories,
    required String imageUrl,
  }) async {
    try {
      final userId = await _getCurrentUserId();

      // Create new meal
      final meal = Meal(
        id: uuid.v4(),
        type: type,
        name: name,
        calories: calories,
        imageUrl: imageUrl,
        timestamp: DateTime.now(),
      );

      // Send to backend API through service
      await _apiService.addMeal(userId, meal.toMap());
    } catch (e) {
      print('Error adding meal: $e');
      throw Exception('Failed to add meal: $e');
    }
  }

  // Get calorie data for a specific date
  Future<CalorieData> getCalorieDataForDate(DateTime date) async {
    try {
      final userId = await _getCurrentUserId();
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      final response = await _apiService.getCalorieDataForDate(userId, dateStr);

      if (response['status'] == 'not_found') {
        // Create new data if not found
        return await _createNewCalorieData(userId);
      }

      return CalorieData.fromMap(response);
    } catch (e) {
      print('Error getting calorie data for date: $e');
      throw Exception('Failed to load calorie data: $e');
    }
  }

  // Remove a meal
  Future<void> removeMeal(String mealId) async {
    try {
      final userId = await _getCurrentUserId();
      await _apiService.removeMeal(userId, mealId);
    } catch (e) {
      print('Error removing meal: $e');
      throw Exception('Failed to remove meal: $e');
    }
  }

  // Helper method to get current user ID
  Future<String> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) {
      throw Exception('User not logged in');
    }

    return userId;
  }

  // Public method to get user ID for other components
  Future<String> getCurrentUserId() async {
    return await _getCurrentUserId();
  }

  // Get consumed meals history
  Future<List<dynamic>> getConsumedMealsForUser() async {
    try {
      final userId = await _getCurrentUserId();
      return await _apiService.getConsumedMealsForUser(userId);
    } catch (e) {
      print('Error getting consumed meals: $e');
      throw Exception('Failed to load consumed meals: $e');
    }
  }
}
*/





import 'package:flutter/material.dart';
import '../models/calorie_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class CalorieRepository {
  final ApiService _apiService = ApiService();
  final String _userIdKey = 'user_id';

  // Get the current user ID from shared preferences
  Future<String> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    // Default ID for testing - replace with actual login flow
    return prefs.getString(_userIdKey) ?? '6802a37e4ca8dd672d737e72';
  }

  // Get today's calorie data
  Future<CalorieData> getTodayCalorieData() async {
    try {
      final userId = await _getUserId();

      final response = await _apiService.dio.get(
        '/api/users/$userId/daily-plan',
      );

      if (response.statusCode == 200) {
        return CalorieData.fromMap(response.data);
      } else {
        throw Exception('Failed to load calorie data');
      }
    } catch (e) {
      debugPrint('Error fetching calorie data: $e');
      if (e is DioException) {
        debugPrint('DioError: ${e.message}');
        if (e.response != null) {
          debugPrint('Response data: ${e.response?.data}');
          debugPrint('Response status: ${e.response?.statusCode}');
        }
      }

      // Return empty data in case of error
      return CalorieData(
        username: 'User',
        date: DateTime.now().toString().split(' ')[0],
        totalCalories: 0,
        calorieGoal: 2000,
        caloriePercentage: 0.0,
        meals: [],
      );
    }
  }

  // Add a meal to today's plan
  Future<bool> addMeal(String recipeId, String mealType) async {
    try {
      final userId = await _getUserId();

      await _apiService.dio.post(
        '/api/users/$userId/daily-plan/meals',
        data: {'recipeId': recipeId, 'mealType': mealType},
      );

      return true;
    } catch (e) {
      debugPrint('Error adding meal: $e');
      return false;
    }
  }

  // Remove a meal from today's plan
  Future<bool> removeMeal(String mealId) async {
    try {
      final userId = await _getUserId();

      // Extract the meal type from the meal ID or pass it directly
      // This depends on how your backend identifies meals
      // For now, we'll use the mealId as the mealType since that's what our backend expects

      await _apiService.dio.delete(
        '/api/users/$userId/daily-plan/meals/$mealId',
      );

      return true;
    } catch (e) {
      debugPrint('Error removing meal: $e');
      return false;
    }
  }

  // Get calorie data for a specific date
  Future<CalorieData> getCalorieDataForDate(DateTime date) async {
    try {
      final userId = await _getUserId();
      final dateStr = date.toString().split(' ')[0]; // YYYY-MM-DD format

      final response = await _apiService.dio.get(
        '/api/users/$userId/daily-plan',
        queryParameters: {'date': dateStr},
      );

      if (response.statusCode == 200) {
        return CalorieData.fromMap(response.data);
      } else {
        throw Exception('Failed to load calorie data for date');
      }
    } catch (e) {
      debugPrint('Error fetching calorie data for date: $e');

      // Return empty data in case of error
      return CalorieData(
        username: 'User',
        date: date.toString().split(' ')[0],
        totalCalories: 0,
        calorieGoal: 2000,
        caloriePercentage: 0.0,
        meals: [],
      );
    }
  }
}
