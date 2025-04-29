/*import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';
import '../repositories/Calories_repository.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final RecipeRepository _recipeRepository = RecipeRepository();
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

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    _recipeRepository.getFavoriteRecipeIds().then((favoriteIds) {
      if (_isFavorite) {
        favoriteIds.add(widget.recipe.id);
      } else {
        favoriteIds.remove(widget.recipe.id);
      }
      _recipeRepository.saveFavoriteRecipeIds(favoriteIds);
    });
  }

  void _addToMealPlan() async {
    try {
      // Convert recipe to meal and add to today's calories
      await _calorieRepository.addMealToToday(
        type: widget.recipe.mealType,
        name: widget.recipe.name,
        calories: widget.recipe.calories,
        imageUrl: widget.recipe.imageUrl,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${widget.recipe.name} to your meal plan'),
          backgroundColor: Colors.green[700],
        ),
      );

      // Navigate back to calories screen
      Navigator.pop(context);
      Navigator.pop(context); // Pop back to CalorieScreen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add meal: $e'),
          backgroundColor: Colors.red,
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
                  SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomButton(),
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
    // In a real app, you would calculate these values from the ingredients
    final protein =
        (widget.recipe.calories * 0.2 / 4)
            .round(); // 20% of calories from protein
    final carbs =
        (widget.recipe.calories * 0.5 / 4)
            .round(); // 50% of calories from carbs
    final fat =
        (widget.recipe.calories * 0.3 / 9).round(); // 30% of calories from fat

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

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _addToMealPlan,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Add to my meal plan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';
import '../repositories/Calories_repository.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final RecipeRepository _recipeRepository = RecipeRepository();
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

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    _recipeRepository.getFavoriteRecipeIds().then((favoriteIds) {
      if (_isFavorite) {
        favoriteIds.add(widget.recipe.id);
      } else {
        favoriteIds.remove(widget.recipe.id);
      }
      _recipeRepository.saveFavoriteRecipeIds(favoriteIds);
    });
  }
/*
  void _addToMealPlan() async {
    try {
      // Convert recipe to meal and add to today's calories
      await _calorieRepository.addMealToToday(
        type: widget.recipe.mealType,
        name: widget.recipe.name,
        calories: widget.recipe.calories,
        imageUrl: widget.recipe.imageUrl,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${widget.recipe.name} to your meal plan'),
          backgroundColor: Colors.green[700],
        ),
      );

      // Navigate back to calories screen
      Navigator.pop(context);
      Navigator.pop(context); // Pop back to CalorieScreen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add meal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
*/
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
                  SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      //bottomSheet: _buildBottomButton(),
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
    // In a real app, you would calculate these values from the ingredients
    final protein =
        (widget.recipe.calories * 0.2 / 4)
            .round(); // 20% of calories from protein
    final carbs =
        (widget.recipe.calories * 0.5 / 4)
            .round(); // 50% of calories from carbs
    final fat =
        (widget.recipe.calories * 0.3 / 9).round(); // 30% of calories from fat

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

/*
  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _addToMealPlan,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Add to my meal plan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
*/


}
