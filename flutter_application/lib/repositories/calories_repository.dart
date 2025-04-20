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
}
