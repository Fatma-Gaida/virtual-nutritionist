import 'package:flutter/material.dart';
//import 'package:flutter_application/models/meal_model.dart';
import '../repositories/calories_repository.dart';
import 'package:intl/intl.dart';
class MealHistoryScreen extends StatefulWidget {
  @override
  _MealHistoryScreenState createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends State<MealHistoryScreen> {
  final CalorieRepository _repository = CalorieRepository();
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Use the public method instead of the private one
      final userId = await _repository.getCurrentUserId();

      // Use the existing public method
      final response = await _repository.getConsumedMealsForUser(userId);

      // Fetch meal history from API
      /*final response = await _repository._apiService.get(
        '/users/$userId/plats-consommes',
      );*/
      /*final response = await _repository.apiService.get(
        '/users/$userId/plats-consommes',
      );*/
      //final response = await _repository.getConsumedMealsForUser(userId);
      if (response.statusCode == 200) {
        // Group consumed plates by date
        Map<String, List<dynamic>> groupedByDate = {};

        for (var plate in response.data) {
          String date =
              plate['date'] != null
                  ? DateFormat(
                    'yyyy-MM-dd',
                  ).format(DateTime.parse(plate['date']))
                  : 'Unknown Date';

          if (!groupedByDate.containsKey(date)) {
            groupedByDate[date] = [];
          }

          groupedByDate[date]!.add(plate);
        }

        // Convert to format for ListView
        List<Map<String, dynamic>> history = [];
        groupedByDate.forEach((date, plates) {
          history.add({'date': date, 'plates': plates});
        });

        // Sort by date descending (newest first)
        history.sort((a, b) => b['date'].compareTo(a['date']));

        setState(() {
          _history = history;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load meal history');
      }
    } catch (e) {
      print('Error loading meal history: $e');
      setState(() {
        _isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load meal history: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal History'),
        backgroundColor: const Color(0xFF2E6930),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _history.isEmpty
              ? const Center(child: Text('No meal history found'))
              : ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final dateData = _history[index];
                  final date = dateData['date'];
                  final plates = dateData['plates'] as List;

                  return _buildDateSection(date, plates);
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadHistory,
        backgroundColor: const Color(0xFF2E6930),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildDateSection(String dateStr, List plates) {
    // Format date for display
    final date = DateTime.parse(dateStr);
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(date);

    // Calculate total calories for this date
    int totalCalories = 0;
    for (var plate in plates) {
      // Find the calorie info for this recipe ID
      // Note: In a real app, you would need to fetch this information
      // You might need to make additional API calls or store this in your database
      totalCalories += 0; // Replace with actual calories
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Total: $totalCalories calories',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ...plates.map<Widget>((plate) => _buildMealItem(plate)).toList(),
        ],
      ),
    );
  }

  Widget _buildMealItem(Map<String, dynamic> plate) {
    // Get meal type and name
    final mealType = plate['repas'] ?? 'Unknown';
    final recipeId = plate['recipeId'] ?? '';
    String mealName = 'Unknown Meal';
    int calories = 0;

    // In a real app, you would fetch recipe details based on recipeId
    // For now, we'll just display the recipe ID

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getMealTypeColor(mealType),
        child: Icon(_getMealTypeIcon(mealType), color: Colors.white),
      ),
      title: Text(mealName),
      subtitle: Text('$mealType - $recipeId'),
      trailing: Text(
        '$calories kcal',
        style: const TextStyle(
          color: Colors.amber,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return Colors.green;
      case 'dinner':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getMealTypeIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }
}
