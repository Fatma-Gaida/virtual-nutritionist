import 'package:flutter/material.dart';
import 'package:flutter_application/services/api_service.dart';
import 'package:flutter_application/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen>
    with SingleTickerProviderStateMixin {
  final RecipeRepository _repository = RecipeRepository(
    AuthService(ApiService()),
  );
  late Future<List<Recipe>> _recipesFuture;
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  RangeValues _calorieRange = RangeValues(0, 1000);
  bool _showFilters = false;
  List<Recipe> _filteredRecipes = [];
  List<Recipe> _allRecipes = [];
  Set<String> _favoriteRecipeIds = {};
  int _currentIndex = 1; // Calories tab is selected by default

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild the widget when the tab changes
    });
    _loadRecipes();
  }

  void _loadRecipes() {
    _recipesFuture = _repository.getAllRecipes();
    _recipesFuture.then((recipes) {
      setState(() {
        _allRecipes = recipes;
        _filteredRecipes = recipes;
      });
    });
    _loadFavorites();
  }

  void _loadFavorites() async {
    try {
      final favorites = await _repository.getFavoriteRecipeIds();
      setState(() {
        _favoriteRecipeIds = Set<String>.from(favorites);
      });
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  void _toggleFavorite(String recipeId) async {
    try {
      if (_favoriteRecipeIds.contains(recipeId)) {
        await _repository.removeFromFavorites(recipeId);
        setState(() {
          _favoriteRecipeIds.remove(recipeId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe removed from favorites')),
        );
      } else {
        await _repository.addToFavorites(recipeId);
        setState(() {
          _favoriteRecipeIds.add(recipeId);
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

  void _filterRecipes() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes =
          _allRecipes.where((recipe) {
            final matchesSearch = recipe.name.toLowerCase().contains(
              searchTerm,
            );
            final matchesCalories =
                recipe.calories >= _calorieRange.start &&
                recipe.calories <= _calorieRange.end;
            return matchesSearch && matchesCalories;
          }).toList();
    });
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

  Future<void> _addToDailyPlan(Recipe recipe) async {
    final userId = await getUserId();
    final caloriesLeft = await _getCaloriesLeft(userId);

    if (recipe.calories > caloriesLeft) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sorry, you can\'t eat this today')),
      );
      return;
    }

    try {
      final response = await ApiService().post(
        '/users/$userId/daily-plan/meals',
        {'recipeId': recipe.id, 'mealType': recipe.mealType},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${recipe.name} added to daily plan')),
        );
      } else {
        final errorMessage =
            response.data is String ? response.data : 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to add ${recipe.name} to daily plan: $errorMessage',
            ),
          ),
        );
      }
    } catch (e) {
      if (e is DioException && e.response?.data != null) {
        final errorMessage =
            e.response!.data is String ? e.response!.data : e.message;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to add ${recipe.name} to daily plan: $errorMessage',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add ${recipe.name} to daily plan: $e'),
          ),
        );
      }
    }
  }

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/water');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: FutureBuilder<List<Recipe>>(
          future: _recipesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No recipes available'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSearchBar(),
                if (_showFilters) _buildFilters(),
                _buildTabs(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMealsList('Breakfast'),
                      _buildMealsList('Lunch'),
                      _buildMealsList('Dinner'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[800],
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/addPlat');
        },
      ),
    );
  }

  Widget _buildHeader() {
    String mealType;
    switch (_tabController.index) {
      case 0:
        mealType = 'Breakfast';
        break;
      case 1:
        mealType = 'Lunch';
        break;
      case 2:
        mealType = 'Dinner';
        break;
      default:
        mealType = 'Breakfast';
    }

    final now = DateTime.now();
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final monthName = monthNames[now.month - 1];
    final dateText = 'Today, ${now.day} $monthName';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Image.asset('assets/images/breakfast.png', width: 40, height: 40),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your $mealType',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              Text(
                dateText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.calendar_today_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _filterRecipes(),
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _showFilters ? 100 : 0,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Text(
            'Calories: ${_calorieRange.start.toInt()} - ${_calorieRange.end.toInt()} kcal',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          RangeSlider(
            values: _calorieRange,
            min: 0,
            max: 1000,
            divisions: 20,
            labels: RangeLabels(
              _calorieRange.start.round().toString(),
              _calorieRange.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _calorieRange = values;
                _filterRecipes();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green[700],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[700],
          tabs: [
            Tab(text: 'Breakfast'),
            Tab(text: 'Lunch'),
            Tab(text: 'Dinner'),
          ],
        ),
      ),
    );
  }

/*
  Widget _buildMealsList(String mealType) {
    final meals =
        _filteredRecipes
            .where(
              (recipe) =>
                  recipe.mealType.toLowerCase() == mealType.toLowerCase(),
            )
            .toList();

    if (meals.isEmpty) {
      return Center(child: Text('No $mealType recipes found'));
    }

    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0, // Further adjusted to make items shorter
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final recipe = meals[index];
          final isFavorite = _favoriteRecipeIds.contains(recipe.id);
          return _buildRecipeCard(recipe, isFavorite);
        },
        clipBehavior: Clip.none, // Prevent clipping of floating action button
      ),
    );
  }
*/
  Widget _buildMealsList(String mealType) {
    final meals =
        _filteredRecipes
            .where(
              (recipe) =>
                  recipe.mealType.toLowerCase() == mealType.toLowerCase(),
            )
            .toList();

    if (meals.isEmpty) {
      return Center(child: Text('No $mealType recipes found'));
    }

    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio:
              0.65, // Adjusted to make items taller and prevent overflow
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final recipe = meals[index];
          final isFavorite = _favoriteRecipeIds.contains(recipe.id);
          return _buildRecipeCard(recipe, isFavorite);
        },
        clipBehavior: Clip.none,
      ),
    );
  }
  Widget _buildRecipeCard(Recipe recipe, bool isFavorite) {
    return GestureDetector(
      onTap: () {
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
                    height: 100, // Reduced from 120 to 100 to save space
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 100,
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
                    onTap: () => _toggleFavorite(recipe.id),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
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
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _addToDailyPlan(recipe),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 36),
                    ),
                    child: Text(
                      'Add to Daily Plan',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromRGBO(46, 125, 50, 1),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: _onNavBarTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Calories'),
        BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Water'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}
