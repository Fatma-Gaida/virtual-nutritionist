import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/calorie_model.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart'; // Import your ApiService

class CalorieRepository {
  final ApiService _apiService = ApiService();
  final uuid = Uuid();

  // Get today's user's calorie data
  /*
  Future<CalorieData> getTodayCalorieData() async {
    try {
      // Get current user ID
      final userId = await _getCurrentUserId();

      // Call the API through your service
      final response = await _apiService.get('/calories/today/$userId');

      // Parse the response
      if (response.statusCode == 200) {
        return CalorieData.fromMap(response.data);
      } else if (response.statusCode == 404) {
        // If not found, create new calorie data for today
        return await _createNewCalorieData(userId);
      } else {
        throw Exception('Failed to load calorie data');
      }
    } catch (e) {
      print('Error getting calorie data: $e');
      throw Exception('Failed to load calorie data');
    }
  }
  */
  Future<CalorieData> getTodayCalorieData() async {
    try {
      // Get current user ID
      //final userId = '6802a37e4ca8dd672d737e72';
      final userId =await _getCurrentUserId();

      // Call the API through your service
      final response = await _apiService.get('/calories/today/$userId');

      // Parse the response
      if (response.statusCode == 200) {
        return CalorieData.fromMap(response.data);
      } else if (response.statusCode == 404) {
        // If not found, create new calorie data for today
        return await _createNewCalorieData(userId);
      } else {
        throw Exception('Failed to load calorie data');
      }
    } catch (e) {
      print('Error getting calorie data: $e');
      // Return a default CalorieData object for demonstration
      return CalorieData(
        username: 'User',
        date: 'Today',
        totalCalories: 0,
        calorieGoal: 2000,
        caloriePercentage: 0.0,
        meals: [],
      );
    }
  }
  // Create new calorie data for today
  Future<CalorieData> _createNewCalorieData(String userId) async {
    try {
      // Get user profile to get calorie goal and username
      final response = await _apiService.get('/users/$userId');
      final userData = response.data;

      final username = userData['name'] ?? 'User';
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
      await _apiService.post('/calories/create/$userId', calorieData.toMap());

      return calorieData;
    } catch (e) {
      print('Error creating calorie data: $e');
      throw Exception('Failed to create new calorie data');
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
      //final userId = '6802a37e4ca8dd672d737e72';
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
      await _apiService.post('/calories/meals/$userId', meal.toMap());
    } catch (e) {
      print('Error adding meal: $e');
      throw Exception('Failed to add meal');
    }
  }

  // Get calorie data for a specific date
  Future<CalorieData> getCalorieDataForDate(DateTime date) async {
    try {
      final userId = await _getCurrentUserId();
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      final response = await _apiService.get('/calories/$userId/date/$dateStr');

      if (response.statusCode == 200) {
        return CalorieData.fromMap(response.data);
      } else {
        // Create new data if not found
        return await _createNewCalorieData(userId);
      }
    } catch (e) {
      print('Error getting calorie data for date: $e');
      throw Exception('Failed to load calorie data');
    }
  }

  // Remove a meal
  Future<void> removeMeal(String mealId) async {
    try {
      final userId = await _getCurrentUserId();
      //final userId = '6802a37e4ca8dd672d737e72';
      await _apiService.post('/calories/meals/$userId/remove', {
        'mealId': mealId,
      });
    } catch (e) {
      print('Error removing meal: $e');
      throw Exception('Failed to remove meal');
    }
  }

  // Helper method to get current user ID
  Future<String> _getCurrentUserId() async {
    // Replace with your authentication implementation
    // For demo purposes, return a hardcoded ID
    return 'current_user_id';
  }
}
