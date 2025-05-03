import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/CalorieScreenController.dart';
import 'package:flutter/foundation.dart';

class CalorieScreenGetX extends StatelessWidget {
  final String userId;
  final String baseUrl;

  const CalorieScreenGetX({
    Key? key,
    required this.userId,
    required this.baseUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller with Get.put to make it available
    if (userId.isEmpty || baseUrl.isEmpty) {
      return const Center(child: Text('Invalid user ID or base URL'));
    }

    // Add URL validation
    try {
      Uri.parse('$baseUrl/users/$userId/daily-plan');
    } catch (e) {
      return Center(child: Text('Invalid URL: $e'));
    }

    final controller = Get.put(
      CalorieScreenController(userId: userId, baseUrl: baseUrl),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(controller),
                      _buildCalorieDashboard(controller),
                      _buildMealList(controller),
                    ],
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.fetchDailyPlan();
        },
        child: const Icon(Icons.refresh),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }

  Widget _buildHeader(CalorieScreenController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.grey[600]),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      'Hi ${controller.userName.value}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Today, ${DateFormat('d MMM').format(DateTime.now())}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieDashboard(CalorieScreenController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32), // Dark green color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'My Calories 🥑',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              height: 180,
              width: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Obx(
                    () => SizedBox(
                      height: 180,
                      width: 180,
                      child: CircularProgressIndicator(
                        value: controller.caloriePercentage.value.clamp(
                          0.0,
                          1.0,
                        ),
                        strokeWidth: 12,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.yellow,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Text(
                          '${controller.totalCalories.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text(
                        'KCAL',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Goal: ${controller.calorieGoal.value} KCAL',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 16),
                Text(
                  'Left: ${controller.getCaloriesLeft()} KCAL',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealList(CalorieScreenController controller) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meals today',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'All',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () =>
                  controller.meals.isEmpty
                      ? Center(
                        child: Text(
                          'No meals planned for today',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                      : ListView.separated(
                        itemCount: controller.meals.length,
                        separatorBuilder:
                            (context, index) =>
                                Divider(height: 1, color: Colors.grey[300]),
                        itemBuilder: (context, index) {
                          return _buildMealItem(
                            controller,
                            controller.meals[index],
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealItem(CalorieScreenController controller, MealItem meal) {
    return InkWell(
      onTap: () {
        // Navigate to meal details screen if needed
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child:
                  meal.imageUrl.isNotEmpty
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          meal.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _getMealIcon(meal.type);
                          },
                        ),
                      )
                      : _getMealIcon(meal.type),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.type,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    meal.name,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  Text(
                    '${meal.calories} kcal',
                    style: TextStyle(
                      color: Colors.amber[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () {
                controller.addToConsumedPlates(meal);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMealIcon(String mealType) {
    IconData iconData;
    Color iconColor;

    switch (mealType.toLowerCase()) {
      case 'breakfast':
        iconData = Icons.breakfast_dining;
        iconColor = Colors.amber;
        break;
      case 'lunch':
        iconData = Icons.lunch_dining;
        iconColor = Colors.orange;
        break;
      case 'dinner':
        iconData = Icons.dinner_dining;
        iconColor = Colors.red;
        break;
      case 'snack':
        iconData = Icons.cookie;
        iconColor = Colors.brown;
        break;
      default:
        iconData = Icons.fastfood;
        iconColor = Colors.brown;
    }

    return Center(child: Icon(iconData, size: 32, color: iconColor));
  }
}
