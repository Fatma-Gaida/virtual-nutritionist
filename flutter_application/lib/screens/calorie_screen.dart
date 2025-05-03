import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalorieScreen extends StatefulWidget {
  final String userId;

  const CalorieScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _CalorieScreenState createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  bool isLoading = true;
  String userName = "";
  int calorieGoal = 0;
  int totalCalories = 0;
  double caloriePercentage = 0.0;
  List<MealItem> meals = [];
  final String baseUrl =
      "http://localhost:8080/api"; // Replace with your actual API URL

  @override
  void initState() {
    super.initState();
    // Don't fetch data here - it will be done in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isLoading) {
      // Delay the fetch until after mount
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchDailyPlan();
      });
    }
  }

  Future<void> fetchDailyPlan() async {
    // Check if the widget is mounted before starting the loading state
    if (!mounted) return;

    // Validate userId before making the API call
    if (widget.userId.isEmpty) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User ID is missing')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print('Fetching data for user ID: ${widget.userId}');

      final response = await http.get(
        Uri.parse('$baseUrl/users/${widget.userId}/daily-plan'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Check mounted before updating state
        if (mounted) {
          setState(() {
            userName = data['nom'] ?? "User";
            calorieGoal = data['calorieGoal'] ?? 2000;
            totalCalories = data['totalCalories'] ?? 0;
            caloriePercentage = data['caloriePercentage'] ?? 0.0;
            meals =
                (data['meals'] as List? ?? [])
                    .map((meal) => MealItem.fromJson(meal))
                    .toList();
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load daily plan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      // Check mounted before showing error state
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
      }
    }
  }

  Future<void> addToConsumedPlates(MealItem meal) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/${widget.userId}/consumed-plates'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'recipeId': meal.id, 'meal': meal.type}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${meal.name} added to consumed meals')),
        );

        // Check mounted before refreshing data
        if (mounted) {
          await fetchDailyPlan();
        }
      } else {
        throw Exception(
          'Failed to add meal to consumed plates: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add meal: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildCalorieDashboard(),
                    _buildMealList(),
                  ],
                ),
              ),
    );
  }

  Widget _buildHeader() {
    String today = DateFormat('EEEE, d MMM').format(DateTime.now());

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
                  Text(
                    'Hi $userName',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget _buildCalorieDashboard() {
    int caloriesLeft = calorieGoal - totalCalories;

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
                  SizedBox(
                    height: 180,
                    width: 180,
                    child: CircularProgressIndicator(
                      value: caloriePercentage.clamp(0.0, 1.0),
                      strokeWidth: 12,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.yellow,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$caloriesLeft', //how many colories left to achive your calorie goal
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  Widget _buildMealList() {
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
            child:
                meals.isEmpty
                    ? Center(
                      child: Text(
                        'No meals planned for today',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                    : ListView.separated(
                      itemCount: meals.length,
                      separatorBuilder:
                          (context, index) =>
                              Divider(height: 1, color: Colors.grey[300]),
                      itemBuilder: (context, index) {
                        return _buildMealItem(meals[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealItem(MealItem meal) {
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
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
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
                addToConsumedPlates(meal);
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
      default:
        iconData = Icons.fastfood;
        iconColor = Colors.brown;
    }

    return Center(child: Icon(iconData, size: 32, color: iconColor));
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
