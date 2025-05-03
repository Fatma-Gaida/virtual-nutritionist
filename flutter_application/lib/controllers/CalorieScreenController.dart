import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class CalorieScreenController extends GetxController {
  final String userId;
  final String baseUrl;

  // Observable variables
  final RxBool isLoading = true.obs;
  final RxString userName = "User".obs;
  final RxInt calorieGoal = 0.obs;
  final RxInt totalCalories = 0.obs;
  final RxDouble caloriePercentage = 0.0.obs;
  final RxList<MealItem> meals = <MealItem>[].obs;

  CalorieScreenController({required this.userId, required this.baseUrl});

  @override
  void onInit() {
    super.onInit();
    fetchDailyPlan();
  }

  Future<void> fetchDailyPlan() async {
    isLoading.value = true;

/*
    // Check if userId and baseUrl are not empty
    if (userId.isEmpty) {
      isLoading.value = false;
      throw Exception('User ID is empty');
    } else {
      debugPrint('User ID is not empty');
    }
    if (baseUrl.isEmpty) {
      isLoading.value = false;
      throw Exception('Base URL cannot be empty');
    }else {
      debugPrint('Base URL is not empty: $baseUrl');
    }

*/



    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/daily-plan'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Update observable values
        userName.value = data['nom'] ?? "User";
        calorieGoal.value = data['calorieGoal'] ?? 2000;
        totalCalories.value = data['totalCalories'] ?? 0;
        caloriePercentage.value = data['caloriePercentage'] ?? 0.0;

        // Parse meals
        final List<MealItem> mealsList =
            (data['meals'] as List)
                .map((meal) => MealItem.fromJson(meal))
                .toList();

        meals.assignAll(mealsList);

        isLoading.value = false;
      } else {
        throw Exception('Failed to load daily plan: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> addToConsumedPlates(MealItem meal) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/consumed-plates'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'recipeId': meal.id, 'meal': meal.type}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          'Success',
          '${meal.name} added to consumed meals',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
        );

        // Refresh daily plan to update calorie count
        await fetchDailyPlan();
      } else {
        throw Exception('Failed to add meal: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add meal: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    }
  }

  int getCaloriesLeft() {
    return calorieGoal.value - totalCalories.value;
  }
}

class MealItem {
  final String id;
  final String type;
  final String name;
  final int calories;
  final String imageUrl;
  final String timestamp;

  MealItem({
    required this.id,
    required this.type,
    required this.name,
    required this.calories,
    required this.imageUrl,
    required this.timestamp,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      calories: json['calories'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
