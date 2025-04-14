package com.example.pfa2.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.pfa2.models.Recipe;
import com.example.pfa2.repository.RecipeRepository;

@Service
public class RecipeService {
    @Autowired
    private RecipeRepository recipeRepository;
    
    public List<Recipe> getAllRecipes() {
        return recipeRepository.findAll();
    }
    
    public List<Recipe> getRecipesByMealType(String mealType) {
        return recipeRepository.findByMealType(mealType);
    }
    
    public List<Recipe> searchRecipesByName(String name) {
        return recipeRepository.findByNameContainingIgnoreCase(name);
    }
    
    public Optional<Recipe> getRecipeById(String id) {
        return recipeRepository.findById(id);
    }
    
    public Recipe saveRecipe(Recipe recipe) {
        return recipeRepository.save(recipe);
    }
    
    public void deleteRecipe(String id) {
        recipeRepository.deleteById(id);
    }
    
    public List<Recipe> getRecipesByMaxCalories(int maxCalories) {
        return recipeRepository.findByCaloriesLessThanEqual(maxCalories);
    }
}
