import 'package:flutter/material.dart';
import 'package:flutter_application/services/api_service.dart';
import 'package:flutter_application/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';
import '../repositories/Calories_repository.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final RecipeRepository _recipeRepository = RecipeRepository(
    AuthService(ApiService()),
  );
  final CalorieRepository _calorieRepository = CalorieRepository();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favoriteIds = await _recipeRepository.getFavoriteRecipeIds();
    setState(() {
      _isFavorite = favoriteIds.contains(widget.recipe.id);
    });
  }

  void _toggleFavorite() async {
    try {
      if (_isFavorite) {
        await _recipeRepository.removeFromFavorites(widget.recipe.id);
        setState(() {
          _isFavorite = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe removed from favorites')),
        );
      } else {
        await _recipeRepository.addToFavorites(widget.recipe.id);
        setState(() {
          _isFavorite = true;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Recipe added to favorites')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update favorites: $e')));
    }
  }

  Future<int> _getCaloriesLeft(String userId) async {
    final apiService = ApiService();

    try {
      final response = await apiService.get('/users/$userId/daily-plan');
      if (response.statusCode == 200) {
        final data =
            response.data is String ? jsonDecode(response.data) : response.data;
        final calorieGoal = data['calorieGoal'] ?? 2000;

        final totalConsumedResponse = await apiService.get(
          '/users/$userId/consumed-plates/today',
        );
        if (totalConsumedResponse.statusCode == 200) {
          final consumedData =
              totalConsumedResponse.data is String
                  ? jsonDecode(totalConsumedResponse.data)
                  : totalConsumedResponse.data;
          final totalConsumedCalories = consumedData
              .map((dish) => (dish['calories'] as num?)?.toInt() ?? 0)
              .fold(0, (sum, calories) => sum + calories);
          return calorieGoal - totalConsumedCalories;
        }
      }
      return 2000; // Default if fetch fails
    } catch (e) {
      print('Error fetching calories left: $e');
      return 2000; // Default on error
    }
  }
      // Get user ID from shared preferences
  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) {
      throw Exception('User ID not found. Please log in.');
    }

    return userId;
  }

  Future<void> _addToDailyPlan() async {
    final userId = await getUserId();
  /*
    final userId =
        AuthService(ApiService()).currentUserId ??
        'user123'; // Replace with actual user ID logic
        */
    final caloriesLeft = await _getCaloriesLeft(userId);

    if (widget.recipe.calories > caloriesLeft) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sorry, you can\'t eat this today')),
      );
      return;
    }

    try {
      final response = await ApiService().post('/users/$userId/daily-plan/meals', {
        'recipeId': widget.recipe.id,
        'mealType': widget.recipe.mealType,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.recipe.name} added to daily plan')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add ${widget.recipe.name} to daily plan'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to add ${widget.recipe.name} to daily plan: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecipeInfo(),
                  SizedBox(height: 24),
                  _buildNutritionInfo(),
                  SizedBox(height: 24),
                  _buildIngredientsSection(),
                  SizedBox(height: 24),
                  _buildDescriptionSection(),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _addToDailyPlan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        minimumSize: Size(200, 48),
                      ),
                      child: Text('Add to Daily Plan'),
                    ),
                  ),
                  SizedBox(height: 16), // Extra space at the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'recipe-${widget.recipe.id}',
          child: Image.network(
            widget.recipe.imageUrl,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.restaurant,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                ),
          ),
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.7),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.7),
          child: IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: _toggleFavorite,
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }

  Widget _buildRecipeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.recipe.name,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            _buildInfoChip(
              Icons.access_time,
              '${widget.recipe.preparationTime} min',
            ),
            SizedBox(width: 16),
            _buildInfoChip(
              Icons.local_fire_department,
              '${widget.recipe.calories} kcal',
            ),
            SizedBox(width: 16),
            _buildInfoChip(Icons.restaurant, widget.recipe.mealType),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.green[700]),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo() {
    final protein = (widget.recipe.calories * 0.2 / 4).round();
    final carbs = (widget.recipe.calories * 0.5 / 4).round();
    final fat = (widget.recipe.calories * 0.3 / 9).round();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutrientInfo('Protein', '$protein g'),
          _buildDivider(),
          _buildNutrientInfo('Carbs', '$carbs g'),
          _buildDivider(),
          _buildNutrientInfo('Fat', '$fat g'),
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.green[700],
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.green[200]);
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        ...widget.recipe.ingredients.map(
          (ingredient) => _buildIngredientItem(ingredient),
        ),
      ],
    );
  }

  Widget _buildIngredientItem(Ingredient ingredient) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child:
                ingredient.imageUrlIng != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        ingredient.imageUrlIng!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Icon(Icons.restaurant, color: Colors.grey[400]),
                      ),
                    )
                    : Icon(Icons.restaurant, color: Colors.grey[400]),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${ingredient.quantity} ${ingredient.unit}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          widget.recipe.description,
          style: TextStyle(color: Colors.grey[800], fontSize: 16, height: 1.5),
        ),
      ],
    );
  }
}
