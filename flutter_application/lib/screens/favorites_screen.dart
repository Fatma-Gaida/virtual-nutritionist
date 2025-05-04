import 'package:flutter/material.dart';
import 'package:flutter_application/services/api_service.dart';
import 'package:flutter_application/services/auth_service.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final RecipeRepository _repository = RecipeRepository(
    AuthService(ApiService()),
  );
  late Future<List<Recipe>> _favoriteRecipesFuture;
  List<Recipe> _favoriteRecipes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final recipes = await _repository.getFavoriteRecipes();
      setState(() {
        _favoriteRecipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load favorite recipes: $e';
        _isLoading = false;
      });
    }
  }

  void _removeFromFavorites(String recipeId) async {
    try {
      await _repository.removeFromFavorites(recipeId);
      _loadFavoriteRecipes(); // Reload the list after removal
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Recipe removed from favorites')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove from favorites: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('My Favorites'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: SafeArea(
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _favoriteRecipes.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No favorite recipes yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add recipes to your favorites to see them here',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
                : RefreshIndicator(
                  onRefresh: _loadFavoriteRecipes,
                  child: GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _favoriteRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _favoriteRecipes[index];
                      return _buildRecipeCard(recipe);
                    },
                  ),
                ),
      ),
      //bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return GestureDetector(
      onTap: () {
        // Navigate to recipe details
        Navigator.pushNamed(context, '/recipe-details', arguments: recipe);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    recipe.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 120,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.restaurant,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                        ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _removeFromFavorites(recipe.id),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.favorite, color: Colors.red, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${recipe.preparationTime} min',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${recipe.calories} kcal',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
/*
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromRGBO(46, 125, 50, 1),
      unselectedItemColor: Colors.grey,
      currentIndex: 3, // Profile tab
      onTap: (index) {
        // Handle navigation based on index
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/dashboard');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/recipes');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/water');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Calories'),
        BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Water'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

*/
}
