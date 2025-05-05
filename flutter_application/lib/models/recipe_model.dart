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




  //added at 08:13 04/05/2025
  /*
   factory Recipe.fromJson(Map<String, dynamic> json) {
    // Handle ingredients which might be a List<dynamic> or List<String>
    List<String> parsedIngredients = [];
    if (json['ingredients'] != null) {
      parsedIngredients = (json['ingredients'] as List)
          .map((item) => item.toString())
          .toList();
    }

    return Recipe(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      preparationTime: json['preparationTime'] ?? 0,
      calories: json['calories'] ?? 0,
      mealType: json['mealType'] ?? '',
      ingredients: json['ingredients'] ?? [],
    );
  }
  */

  //updated at 10:23 04/05/2025
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      preparationTime: json['preparationTime'] as int,
      calories: json['calories'] as int,
      mealType: json['mealType'] as String,
      ingredients:
          (json['ingredients'] as List)
              .map((item) => Ingredient.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'preparationTime': preparationTime,
      'calories': calories,
      'mealType': mealType,
      'ingredients': ingredients,
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

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      quantity: json['quantity'] as double,
      unit: json['unit'] as String,
      imageUrlIng: json['imageUrlIng'] as String
    );
  }
}
