import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ConsumedDishesScreen extends StatefulWidget {
  final String userId;

  const ConsumedDishesScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  _ConsumedDishesScreenState createState() => _ConsumedDishesScreenState();
}

class _ConsumedDishesScreenState extends State<ConsumedDishesScreen> {
  bool isLoading = true;
  List<ConsumedDishItem> consumedDishes = [];
  final String baseUrl =
      "http://localhost:8080/api"; // Replace with your actual API URL

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchConsumedDishes();
      });
    }
  }

  Future<void> fetchConsumedDishes() async {
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
      final response = await http.get(
        Uri.parse('$baseUrl/users/${widget.userId}/consumed-plates'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            consumedDishes =
                data.map((dish) => ConsumedDishItem.fromJson(dish)).toList();
            isLoading = false;
          });
        }
      } else {
        throw Exception(
          'Failed to load consumed dishes: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load consumed dishes: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Consumed Dishes'),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : consumedDishes.isEmpty
              ? const Center(
                child: Text(
                  'No dishes consumed yet',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: consumedDishes.length,
                separatorBuilder:
                    (context, index) =>
                        Divider(height: 1, color: Colors.grey[300]),
                itemBuilder: (context, index) {
                  return _buildDishItem(consumedDishes[index]);
                },
              ),
    );
  }

  Widget _buildDishItem(ConsumedDishItem dish) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
                dish.imageUrl.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        dish.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _getMealIcon(dish.mealType);
                        },
                      ),
                    )
                    : _getMealIcon(dish.mealType),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.mealType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  dish.name,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
                Text(
                  '${dish.calories} kcal',
                  style: TextStyle(
                    color: Colors.amber[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Consumed: ${DateFormat('d MMM, HH:mm').format(DateTime.parse(dish.dateConsommation))}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
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

class ConsumedDishItem {
  final String id;
  final String mealType;
  final String name;
  final int calories;
  final String imageUrl;
  final String dateConsommation;

  ConsumedDishItem({
    required this.id,
    required this.mealType,
    required this.name,
    required this.calories,
    required this.imageUrl,
    required this.dateConsommation,
  });

  factory ConsumedDishItem.fromJson(Map<String, dynamic> json) {
    return ConsumedDishItem(
      id: json['_id'] ?? '',
      mealType: json['meal'] ?? '',
      name: json['name'] ?? '',
      calories: json['calories']?.toInt() ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      dateConsommation: json['dateConsommation'] ?? '',
    );
  }
}
