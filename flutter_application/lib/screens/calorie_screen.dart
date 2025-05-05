import 'package:flutter/material.dart';
import 'package:flutter_application/screens/notifications_screen.dart';
import 'package:flutter_application/screens/recipe_screen.dart';
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
  int totalConsumedCalories = 0; // Sum of consumed calories for today
  double caloriePercentage = 0.0;
  List<MealItem> meals = [];
  final String baseUrl = "http://localhost:8080/api";
  final Set<String> consumedMealIds = {}; // Track consumed meals

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
        fetchData();
      });
    }
  }

  Future<void> fetchData() async {
    if (!mounted) return;

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
      await Future.wait([fetchDailyPlan(), fetchConsumedPlatesToday()]);
      if (mounted) {
        setState(() {
          isLoading = false;
          updateCaloriePercentage();
        });
      }
    } catch (e) {
      print('Error: $e');
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

  Future<void> fetchDailyPlan() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/${widget.userId}/daily-plan'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (mounted) {
        setState(() {
          userName = data['nom'] ?? "User";
          calorieGoal = data['calorieGoal'] ?? 2000;
          meals =
              (data['meals'] as List? ?? [])
                  .map((meal) => MealItem.fromJson(meal))
                  .toList();
        });
      }
    } else {
      throw Exception('Failed to load daily plan: ${response.statusCode}');
    }
  }

  Future<void> fetchConsumedPlatesToday() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/${widget.userId}/consumed-plates/today'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (mounted) {
        setState(() {
          totalConsumedCalories = data
              .map((dish) => (dish['calories'] as num?)?.toInt() ?? 0)
              .reduce((a, b) => a + b);
          consumedMealIds.clear();
          consumedMealIds.addAll(
            data.map((dish) => dish['id'] ?? dish['_id'] ?? ''),
          );
        });
      }
    } else {
      throw Exception('Failed to load consumed plates: ${response.statusCode}');
    }
  }

  void updateCaloriePercentage() {
    int caloriesLeft = calorieGoal - totalConsumedCalories;
    caloriePercentage =
        (calorieGoal > 0)
            ? 1.0 - (caloriesLeft / calorieGoal).clamp(0.0, 1.0)
            : 0.0;
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
        if (mounted) {
          setState(() {
            consumedMealIds.add(meal.id);
          });
          await fetchConsumedPlatesToday(); // Refresh consumed calories
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieDashboard() {
    int caloriesLeft = calorieGoal - totalConsumedCalories;

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
                        '$caloriesLeft',
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
    int caloriesLeft = calorieGoal - totalConsumedCalories;

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
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecipesScreen()),
                    );
                  },
                  child: const Text('All'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                meals.isEmpty
                    ? Center(
                      child:
                          caloriesLeft > 0
                              ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'No meals planned for today, but you still have $caloriesLeft kcal left!',
                                    style: TextStyle(color: Colors.grey[600]),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RecipesScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text('Eat Something Else'),
                                  ),
                                ],
                              )
                              : Text(
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
    bool isConsumed = consumedMealIds.contains(meal.id);

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
            isConsumed
                ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
                : IconButton(
                  icon: const Icon(Icons.add, size: 24),
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
