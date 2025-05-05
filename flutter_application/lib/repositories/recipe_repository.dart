import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';
import '../services/auth_service.dart';

class RecipeRepository {
  final String baseUrl =
      'http://localhost:8080/api'; // Update with your API base URL
  final AuthService _authService;

  RecipeRepository(this._authService);

  // Get all recipes
  Future<List<Recipe>> getAllRecipes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recipes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Get favorite recipes
  Future<List<Recipe>> getFavoriteRecipes() async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final response = await http.get(Uri.parse('$baseUrl/favorites/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load favorite recipes: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Get favorite recipe IDs
  Future<List<String>> getFavoriteRecipeIds() async {
    try {
      final recipes = await getFavoriteRecipes();
      return recipes.map((recipe) => recipe.id).toList();
    } catch (e) {
      throw Exception('Failed to get favorite recipe IDs: $e');
    }
  }

  // Add recipe to favorites
  Future<void> addToFavorites(String recipeId) async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/favorites/add'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'userId': userId,
          'recipeId': recipeId,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add to favorites: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Remove recipe from favorites
  Future<void> removeFromFavorites(String recipeId) async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/remove'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'userId': userId,
          'recipeId': recipeId,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to remove from favorites: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // For testing when backend is not available
  // This is a fallback implementation using SharedPreferences
  Future<void> saveFavoriteRecipeIds(List<String> favoriteIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_recipes', favoriteIds);
    } catch (e) {
      print('Error saving favorite ids: $e');
    }
  }
}
