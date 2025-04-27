/*
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';
import '../services/api_service.dart';

class RecipeRepository {
  final ApiService _apiService = ApiService();
  final String _favoritesKey = 'favorite_recipes';

/*
  // Get all recipes
  Future<List<Recipe>> getAllRecipes() async {
    try {
      final response = await _apiService.get('/recipes');
      final List<dynamic> recipesJson = response.data;

      return recipesJson.map((data) {
        // Make sure _id is included in the data
        final Map<String, dynamic> recipeData = Map<String, dynamic>.from(data);
        return Recipe.fromMap(recipeData);
      }).toList();
    } catch (e) {
      print('Error fetching recipes: $e');
      return [];
    }
  }
*/
  // Get recipes by mealType
  Future<List<Recipe>> getRecipesByMealType(String mealType) async {
    try {
      final response = await _apiService.get('/recipes/mealType/$mealType');
      final List<dynamic> recipesJson = response.data;

      return recipesJson.map((data) {
        final Map<String, dynamic> recipeData = Map<String, dynamic>.from(data);
        return Recipe.fromMap(recipeData);
      }).toList();
    } catch (e) {
      print('Error fetching recipes by meal type: $e');
      return [];
    }
  }

  // Get recipes filtered by calories
  Future<List<Recipe>> getRecipesByCalorieRange(int min, int max) async {
    try {
      final response = await _apiService.get(
        '/recipes/calories?min=$min&max=$max',
      );
      final List<dynamic> recipesJson = response.data;

      return recipesJson.map((data) {
        final Map<String, dynamic> recipeData = Map<String, dynamic>.from(data);
        return Recipe.fromMap(recipeData);
      }).toList();
    } catch (e) {
      print('Error fetching recipes by calorie range: $e');
      return [];
    }
  }

  // Get recipe by ID
  Future<Recipe?> getRecipeById(String id) async {
    try {
      final response = await _apiService.get('/recipes/$id');
      if (response.statusCode == 200) {
        return Recipe.fromMap(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching recipe by ID: $e');
      return null;
    }
  }

  // Save favorite recipes IDs (Keep using SharedPreferences for local storage)
  Future<void> saveFavoriteRecipeIds(List<String> favoriteIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, favoriteIds);
    } catch (e) {
      print('Error saving favorite recipes: $e');
    }
  }

  // Get favorite recipes IDs
  Future<List<String>> getFavoriteRecipeIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_favoritesKey) ?? [];
    } catch (e) {
      print('Error getting favorite recipes: $e');
      return [];
    }
  }
/*
  // Get favorite recipes
  Future<List<Recipe>> getFavoriteRecipes() async {
    try {
      final favoriteIds = await getFavoriteRecipeIds();
      if (favoriteIds.isEmpty) {
        return [];
      }

      // Send the list of favorite IDs to the backend
      final response = await _apiService.post('/recipes/favorites', {
        'ids': favoriteIds,
      });

      if (response.statusCode == 200) {
        final List<dynamic> recipesJson = response.data;
        return recipesJson.map((data) {
          final Map<String, dynamic> recipeData = Map<String, dynamic>.from(
            data,
          );
          return Recipe.fromMap(recipeData);
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching favorite recipes: $e');
      return [];
    }
  }

*/

// Get all recipes
  Future<List<Recipe>> getAllRecipes() async {
    try {
      final response = await _apiService.get('/recipes');
      final List<dynamic> recipesJson =
          response.data['data']; // Extract from 'data'

      return recipesJson.map((data) => Recipe.fromMap(data)).toList();
    } catch (e) {
      print('Error fetching recipes: $e');
      return [];
    }
  }

  // Get favorite recipes
  Future<List<Recipe>> getFavoriteRecipes() async {
    try {
      final favoriteIds = await getFavoriteRecipeIds();
      if (favoriteIds.isEmpty) return [];

      final response = await _apiService.post('/recipes/favorites', {
        'ids': favoriteIds,
      });

      if (response.statusCode == 200) {
        // Extract from 'recipes' key
        final List<dynamic> recipesJson = response.data['recipes'];
        return recipesJson.map((data) => Recipe.fromMap(data)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching favorite recipes: $e');
      return [];
    }
  }
}
*/
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';
import '../services/api_service.dart';

class RecipeRepository {
  final ApiService _apiService = ApiService();
  final String _favoritesKey = 'favorite_recipes';

  // Get all recipes
  Future<List<Recipe>> getAllRecipes() async {
    try {
      final response = await _apiService.get('/recipes');
      final List<dynamic> recipesJson = response.data;

      return recipesJson.map((data) {
        // Make sure _id is included in the data
        final Map<String, dynamic> recipeData = Map<String, dynamic>.from(data);
        return Recipe.fromMap(recipeData);
      }).toList();
    } catch (e) {
      print('Error fetching recipes: $e');
      return [];
    }
  }

  // Get recipes by mealType
  Future<List<Recipe>> getRecipesByMealType(String mealType) async {
    try {
      final response = await _apiService.get('/recipes/mealType/$mealType');
      final List<dynamic> recipesJson = response.data;

      return recipesJson.map((data) {
        final Map<String, dynamic> recipeData = Map<String, dynamic>.from(data);
        return Recipe.fromMap(recipeData);
      }).toList();
    } catch (e) {
      print('Error fetching recipes by meal type: $e');
      return [];
    }
  }

  // Get recipes filtered by calories
  Future<List<Recipe>> getRecipesByCalorieRange(int min, int max) async {
    try {
      final response = await _apiService.get(
        '/recipes/calories?min=$min&max=$max',
      );
      final List<dynamic> recipesJson = response.data;

      return recipesJson.map((data) {
        final Map<String, dynamic> recipeData = Map<String, dynamic>.from(data);
        return Recipe.fromMap(recipeData);
      }).toList();
    } catch (e) {
      print('Error fetching recipes by calorie range: $e');
      return [];
    }
  }

  /*
  // Get recipe by ID
  Future<Recipe?> getRecipeById(String id) async {
    try {
      final response = await _apiService.get('/recipes/$id');
      if (response.statusCode == 200) {
        return Recipe.fromMap(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching recipe by ID: $e');
      return null;
    }
  }
*/
  // Get recipe by ID
  Future<Recipe?> getRecipeById(String id) async {
    try {
      final response = await _apiService.get('/recipes/$id');
      if (response.statusCode == 200) {
        // Print the response to debug
        print('Recipe Response: ${response.data}');

        // Check if the response contains 'ingredients' and if so, ensure their structure
        if (response.data['ingredients'] != null) {
          for (var ingredient in response.data['ingredients']) {
            // Log the ingredient structure to debug
            print('Ingredient: $ingredient');

            // Check if imageUrlIng exists in the response
            if (!ingredient.containsKey('imageUrlIng')) {
              print(
                'imageUrlIng is missing for ingredient: ${ingredient['name']}',
              );
            }
          }
        }

        return Recipe.fromMap(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching recipe by ID: $e');
      return null;
    }
  }

  // Save favorite recipes IDs (Keep using SharedPreferences for local storage)
  Future<void> saveFavoriteRecipeIds(List<String> favoriteIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, favoriteIds);
    } catch (e) {
      print('Error saving favorite recipes: $e');
    }
  }

  // Get favorite recipes IDs
  Future<List<String>> getFavoriteRecipeIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_favoritesKey) ?? [];
    } catch (e) {
      print('Error getting favorite recipes: $e');
      return [];
    }
  }

  // Get favorite recipes
  Future<List<Recipe>> getFavoriteRecipes() async {
    try {
      final favoriteIds = await getFavoriteRecipeIds();
      if (favoriteIds.isEmpty) {
        return [];
      }

      // Send the list of favorite IDs to the backend
      final response = await _apiService.post('/recipes/favorites', {
        'ids': favoriteIds,
      });

      if (response.statusCode == 200) {
        final List<dynamic> recipesJson = response.data;
        return recipesJson.map((data) {
          final Map<String, dynamic> recipeData = Map<String, dynamic>.from(
            data,
          );
          return Recipe.fromMap(recipeData);
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching favorite recipes: $e');
      return [];
    }
  }
}
