class Recipe {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int preparationTime; // in minutes
  final int calories;
  final String mealType; // Breakfast, Lunch, Dinner
  final List<Ingredient> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.preparationTime,
    required this.calories,
    required this.mealType,
    required this.ingredients,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      preparationTime: map['preparationTime'] ?? 0,
      calories: map['calories'] ?? 0,
      mealType: map['mealType'] ?? 'Breakfast',
      ingredients:
          (map['ingredients'] as List?)
              ?.map((ingredient) => Ingredient.fromMap(ingredient))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'preparationTime': preparationTime,
      'calories': calories,
      'mealType': mealType,
      'ingredients':
          ingredients.map((ingredient) => ingredient.toMap()).toList(),
    };
  }
}

class Ingredient {
  final String name;
  final double quantity;
  final String unit;
  final String? imageUrlIng; // URL for ingredient image

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
    this.imageUrlIng,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] ?? '',
      quantity:
          (map['quantity'] is int)
              ? (map['quantity'] as int).toDouble()
              : map['quantity']?.toDouble() ?? 0.0,
      unit: map['unit'] ?? '',
      imageUrlIng: map['imageUrlIng'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      if (imageUrlIng != null) 'imageUrlIng': imageUrlIng,
    };
  }
}
