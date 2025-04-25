import 'package:flutter_application/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calorie_model.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';

class CalorieRepository {
  final ApiService _apiService = ApiService();
  //ApiService get apiService => _apiService;
  final uuid = Uuid();

  
/*
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
          date: DateTime.now(),
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
*/
/*
// Get today's user's calorie data
  Future<CalorieData> getTodayCalorieData() async {
    try {
      // Get current user ID
      final userId = await _getCurrentUserId();

      // Log the user ID to verify it's correct
      print('Fetching calorie data for user: $userId');

      // Call the API through your service
      final response = await _apiService.get('/users/$userId/daily-plan');
      print(
        'API Response: ${response.data}',
      ); // Debug log to see actual response

      // Parse the response
      if (response.statusCode == 200) {
        // Check if response.data is a Map
        if (response.data is Map<String, dynamic>) {
          return CalorieData.fromMap(response.data);
        } else {
          // If it's not a Map, log the error and throw an exception
          print('Unexpected response format: ${response.data.runtimeType}');
          throw Exception('Unexpected response format from API');
        }
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
          date: DateTime.now(),
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



  */
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
      //final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Create empty calorie data
      final calorieData = CalorieData(
        username: username,
        date: DateTime.now(),
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


Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) {
      return null;
    }

    // Create an IdU object from the stored string
    final idU = IdU(
      timestamp: int.parse(userId),
      date: null, // We don't store the date part
    );

    // Retrieve all stored user data
    return User(
      idU: idU,
      nom: prefs.getString('user_name') ?? '',
      email: prefs.getString('user_email') ?? '',
      dob:
          prefs.getString('user_dob') != null
              ? DateTime.parse(prefs.getString('user_dob')!)
              : null,
      sexe: prefs.getString('user_sexe'),
      taille: prefs.getDouble('user_taille'),
      poids: prefs.getDouble('user_poids'),
      etatActivite: prefs.getString('user_etat_activite'),
      allergies: prefs.getStringList('user_allergies') ?? [],
      maladies: prefs.getStringList('user_maladies') ?? [],
      notificationIds: prefs.getStringList('user_notification_ids') ?? [],
      objectifIds: prefs.getStringList('user_objectif_ids') ?? [],
      platFavoriIds: prefs.getStringList('user_plat_favori_ids') ?? [],
    );
  }


  Future<CalorieData> getTodayCalorieData() async {
    try {
      // Get current user ID
      final userId = await _getCurrentUserId();

      // Get the user's daily plan
      final planResponse = await _apiService.get('/users/$userId/daily-plan');

      // Get the user's consumed meals
      final consumedResponse = await _apiService.get(
        '/users/$userId/plats-consommes',
      );

      if (planResponse.statusCode == 200 &&
          consumedResponse.statusCode == 200) {
        // Combine daily plan with consumed meals info
        final dailyPlan = planResponse.data;
        final consumedMeals = consumedResponse.data;

        // Create a CalorieData object that includes consumed meals
        return _createCalorieDataFromResponses(dailyPlan, consumedMeals);
      } else if (planResponse.statusCode == 404) {
        // If not found, create new calorie data for today
        return await _createNewCalorieData(userId);
      } else {
        throw Exception(
          'Failed to load calorie data: ${planResponse.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting calorie data: $e');

      // Return default data if user is not logged in
      if (e.toString().contains('User not logged in')) {
        return CalorieData(
          username: 'Guest',
          date: DateTime.now(),
          totalCalories: 0,
          calorieGoal: 2000,
          caloriePercentage: 0.0,
          meals: [],
        );
      }

      throw Exception('Failed to load calorie data: $e');
    }
  }

  // Helper method to create CalorieData from API responses
  CalorieData _createCalorieDataFromResponses(
    Map<String, dynamic> dailyPlan,
    List<dynamic> consumedMeals,
  ) {
    // Extract user name
    final username = dailyPlan['username'] ?? 'User';

    // Parse date
    final date =
        dailyPlan['date'] != null
            ? DateTime.parse(dailyPlan['date'])
            : DateTime.now();

    // Default calorie goal
    final calorieGoal = 2000;

    // Convert meals to our app model format
    List<Meal> meals = [];
    int totalCalories = 0;

    // Process meals from the plan that have been consumed
    if (dailyPlan['meals'] != null && dailyPlan['meals'] is Map) {
      final mealsMap = dailyPlan['meals'] as Map<String, dynamic>;

      mealsMap.forEach((mealType, mealData) {
        // Check if this meal has been consumed
        bool isConsumed = consumedMeals.any(
          (consumed) =>
              consumed['recipeId'] == mealData['recipeId'] &&
              consumed['repas'] == mealType,
        );

        if (isConsumed) {
          totalCalories += (mealData['calories'] ?? 0) as int;

          meals.add(
            Meal(
              id: mealData['recipeId'] ?? '',
              type: mealType,
              name: mealData['name'] ?? '',
              calories: mealData['calories'] ?? 0,
              imageUrl:
                  'https://example.com/placeholders/meal.jpg', // Replace with actual image URL
              timestamp: date,
            ),
          );
        }
      });
    }

    // Calculate percentage of goal
    final caloriePercentage =
        calorieGoal > 0 ? totalCalories / calorieGoal : 0.0;

    return CalorieData(
      username: username,
      date: date,
      totalCalories: totalCalories,
      calorieGoal: calorieGoal,
      caloriePercentage: caloriePercentage,
      meals: meals,
    );
  }

  // Get recipe information by ID
Future<Map<String, dynamic>> getRecipeById(String recipeId) async {
  try {
    final response = await _apiService.get('/recipes/$recipeId');
    
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Recipe not found: $recipeId');
    }
  } catch (e) {
    print('Error fetching recipe: $e');
    throw Exception('Failed to load recipe: $e');
  }
}

// Get consumed meals history
Future<List<Map<String, dynamic>>> getConsumedMealsHistory() async {
  try {
    final userId = await _getCurrentUserId();
    final response = await _apiService.get('/users/$userId/plats-consommes');
    
    if (response.statusCode == 200) {
      // Add recipe details to each consumed meal
      List<Map<String, dynamic>> enrichedHistory = [];
      
      for (var meal in response.data) {
        try {
          final recipeId = meal['recipeId'];
          final recipeData = await getRecipeById(recipeId);
          
          // Combine meal consumption data with recipe details
          enrichedHistory.add({
            ...meal,
            'recipeName': recipeData['name'],
            'calories': recipeData['calories'],
            'imageUrl': recipeData['imageUrl'],
          });
        } catch (e) {
          // If recipe details can't be fetched, still include the meal
          enrichedHistory.add(meal);
        }
      }
      
      return enrichedHistory;
    } else {
      throw Exception('Failed to load meal history: ${response.statusCode}');
    }
  } catch (e) {
    print('Error getting meal history: $e');
    throw Exception('Failed to load meal history: $e');
  }
}
Future<dynamic> getConsumedMealsForUser(String userId) async {
    return await _apiService.get('/users/$userId/plats-consommes');
  }

  Future<String> getCurrentUserId() async {
    return await _getCurrentUserId();
  }
}
