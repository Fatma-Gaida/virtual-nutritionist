package com.example.pfa2.controllers;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.pfa2.models.Recipe;
import com.example.pfa2.services.RecipeService;

@RestController
@RequestMapping("/api/recipes")
@CrossOrigin(origins = "*")
public class RecipeController {
    @Autowired
    private RecipeService recipeService;
    
    // Récupérer toutes les recettes
    @GetMapping
    public ResponseEntity<List<Recipe>> getAllRecipes() {
        List<Recipe> recipes = recipeService.getAllRecipes();
        return new ResponseEntity<>(recipes, HttpStatus.OK);
    }
    
    // Récupérer les recettes par type de repas
    @GetMapping("/meal/{mealType}")
    public ResponseEntity<List<Recipe>> getRecipesByMealType(@PathVariable String mealType) {
        List<Recipe> recipes = recipeService.getRecipesByMealType(mealType);
        return new ResponseEntity<>(recipes, HttpStatus.OK);
    }
    
    // Rechercher des recettes par nom
    @GetMapping("/search")
    public ResponseEntity<List<Recipe>> searchRecipes(@RequestParam String name) {
        List<Recipe> recipes = recipeService.searchRecipesByName(name);
        return new ResponseEntity<>(recipes, HttpStatus.OK);
    }
    
    // Récupérer une recette par ID
    @GetMapping("/{id}")
    public ResponseEntity<Recipe> getRecipeById(@PathVariable String id) {
        Optional<Recipe> recipe = recipeService.getRecipeById(id);
        return recipe.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }
    
    // Créer une nouvelle recette
    @PostMapping
    public ResponseEntity<Recipe> createRecipe(@RequestBody Recipe recipe) {
        Recipe savedRecipe = recipeService.saveRecipe(recipe);
        return new ResponseEntity<>(savedRecipe, HttpStatus.CREATED);
    }
        
    // Supprimer une recette
    @DeleteMapping("/{id}")
    public ResponseEntity<HttpStatus> deleteRecipe(@PathVariable String id) {
        try {
            recipeService.deleteRecipe(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // Rechercher des recettes avec un nombre maximum de calories
    @GetMapping("/calories/max/{maxCalories}")
    public ResponseEntity<List<Recipe>> getRecipesByMaxCalories(@PathVariable int maxCalories) {
        List<Recipe> recipes = recipeService.getRecipesByMaxCalories(maxCalories);
        return new ResponseEntity<>(recipes, HttpStatus.OK);
    }
}
