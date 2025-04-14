package com.example.pfa2.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.example.pfa2.models.Recipe;

public interface RecipeRepository extends MongoRepository<Recipe, String>{
    List<Recipe> findByMealType(String mealType);
    List<Recipe> findByNameContainingIgnoreCase(String name);
    List<Recipe> findByCaloriesLessThanEqual(int maxCalories);

}
