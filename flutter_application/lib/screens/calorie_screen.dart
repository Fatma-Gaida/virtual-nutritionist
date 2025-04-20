// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_application/models/meal_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/calorie_model.dart';
import '../repositories/Calories_repository.dart';

class CalorieScreen extends StatefulWidget {
  const CalorieScreen({super.key});

  @override
  _CalorieScreenState createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  final CalorieRepository _repository = CalorieRepository();
  late Future<CalorieData> _calorieDataFuture;

  @override
  void initState() {
    super.initState();
    _calorieDataFuture = _repository.getTodayCalorieData();
  }

  // Refresh data after adding a new meal
  void _refreshData() {
    setState(() {
      _calorieDataFuture = _repository.getTodayCalorieData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: FutureBuilder<CalorieData>(
          future: _calorieDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            }

            final calorieData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(calorieData),
                  _buildCalorieCard(calorieData),
                  _buildMealsList(calorieData),
                  SizedBox(height: 80), // Space for bottom navigation
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader(CalorieData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.png'),
                radius: 24,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.username,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data.date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieCard(CalorieData data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2E6930),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'My Calories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.emoji_food_beverage, color: Colors.amber),
              ],
            ),
            SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 15.0,
              percent:
                  data.caloriePercentage > 1.0 ? 1.0 : data.caloriePercentage,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${data.totalCalories}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'KCAL',
                    style: TextStyle(color: Colors.green[300], fontSize: 14.0),
                  ),
                ],
              ),
              progressColor: Colors.amber,
              backgroundColor: Colors.green.withOpacity(0.3),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            SizedBox(height: 20),
            Row(
              /*
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientIndicator(
                  'Carbohydrates',
                  data.macros.carbohydratesPercentage,
                  '${data.macros.carbohydrates}g/${data.macros.carbohydratesTarget}g',
                  data.macros.carbohydratesPercentage > 1.0
                      ? 1.0
                      : data.macros.carbohydratesPercentage,
                ),
                _buildNutrientIndicator(
                  'Protein',
                  data.macros.proteinPercentage,
                  '${data.macros.protein}g/${data.macros.proteinTarget}g',
                  data.macros.proteinPercentage > 1.0
                      ? 1.0
                      : data.macros.proteinPercentage,
                ),
                _buildNutrientIndicator(
                  'Fat',
                  data.macros.fatPercentage,
                  '${data.macros.fat}g/${data.macros.fatTarget}g',
                  data.macros.fatPercentage > 1.0
                      ? 1.0
                      : data.macros.fatPercentage,
                ),
              ],
              */
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientIndicator(
    String label,
    double percent,
    String text,
    double displayPercent,
  ) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 30.0,
          lineWidth: 5.0,
          percent: displayPercent,
          center: Text(
            '${(displayPercent * 100).toInt()}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),
          progressColor: Colors.amber,
          backgroundColor: Colors.green.withOpacity(0.3),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
        SizedBox(height: 4),
        Text(text, style: TextStyle(color: Colors.green[300], fontSize: 10)),
      ],
    );
  }

  Widget _buildMealsList(CalorieData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meals today',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the recipes screen when "All" is clicked
                  Navigator.pushNamed(context, '/recipes').then((_) {
                    // Refresh data when returning from recipes screen
                    _refreshData();
                  });
                },
                child: Text('All'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
              ),
            ],
          ),
        ),
        ...data.meals.map((meal) => _buildMealItem(meal))/*.toList()*/,
      ],
    );
  }

  Widget _buildMealItem(Meal meal) {
    return Dismissible(
      key: Key(meal.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Remove meal when swiped
        _repository.removeMeal(meal.id).then((_) => _refreshData());
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                meal.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.fastfood, size: 24, color: Colors.amber);
                },
              ),
            ),
          ),
          title: Text(meal.name, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Row(
            children: [
              Text(meal.type, style: TextStyle(color: Colors.grey[600])),
              SizedBox(width: 10),
              Text(
                '${meal.calories} Kcal',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to meal details if needed
          },
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green[800],
      unselectedItemColor: Colors.grey,
      currentIndex: 1, // Calories tab is selected
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Calories'),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            backgroundColor: Colors.green[800],
            radius: 22,
            child: Icon(Icons.camera_alt, color: Colors.white),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Activity',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) {
        if (index == 1) {
          // Refresh data when tapping on Calories tab
          _refreshData();
        }
      },
    );
  }
}
