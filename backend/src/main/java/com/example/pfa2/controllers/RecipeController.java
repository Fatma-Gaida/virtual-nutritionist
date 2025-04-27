package com.example.pfa2.controllers;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
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

import com.example.pfa2.models.PlatsConsommes;
import com.example.pfa2.models.PlatsFavoris;
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

    // Recuperer tous les plats favoris d'un utilisateur specifique
    @GetMapping("/favorites/{userId}")
    public ResponseEntity<List<PlatsFavoris>> getFavoriteRecipes(@PathVariable String userId) {
        List<PlatsFavoris> favorites = recipeService.getFavoriteRecipes(userId);
        return new ResponseEntity<>(favorites, HttpStatus.OK);
    }
    
    //ajouter un plat favoris
    @PostMapping("/favorites/{userId}/{recipeId}")
    public ResponseEntity<PlatsFavoris> addFavoriteRecipe(
            @PathVariable String userId, 
            @PathVariable String recipeId) {
        PlatsFavoris platsFavoris = recipeService.addFavoriteRecipe(userId, recipeId);
        if (platsFavoris != null) {
            return new ResponseEntity<>(platsFavoris, HttpStatus.CREATED);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
    
    //supprimer un plat favoris
    @DeleteMapping("/favorites/{userId}/{recipeId}")
    public ResponseEntity<Void> removeFavoriteRecipe(
            @PathVariable String userId, 
            @PathVariable String recipeId) {
        recipeService.removeFavoriteRecipe(userId, recipeId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
    
    // recuperer tous les plats consommes
    @GetMapping("/consumed/{userId}")
    public ResponseEntity<List<PlatsConsommes>> getConsumedRecipes(@PathVariable String userId) {
        List<PlatsConsommes> consumed = recipeService.getConsumedRecipes(userId);
        return new ResponseEntity<>(consumed, HttpStatus.OK);
    }
    
    //recuperer les plats consommes pour date specifique
    @GetMapping("/consumed/{userId}/date/{date}")
    public ResponseEntity<List<PlatsConsommes>> getConsumedRecipesByDate(
            @PathVariable String userId,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        List<PlatsConsommes> consumed = recipeService.getConsumedRecipesByDate(userId, date);
        return new ResponseEntity<>(consumed, HttpStatus.OK);
    }
    
    //confirmer la consommation d'un plat
    @PostMapping("/consumed/{userId}/{recipeId}")
    public ResponseEntity<PlatsConsommes> addConsumedRecipe(
            @PathVariable String userId,
            @PathVariable String recipeId,
            @RequestParam String repas) {
        PlatsConsommes platsConsommes = recipeService.addConsumedRecipe(userId, recipeId, repas);
        if (platsConsommes != null) {
            return new ResponseEntity<>(platsConsommes, HttpStatus.CREATED);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
    
    //recuperer le total dee caloris consommes par date 
    @GetMapping("/consumed/{userId}/calories/{date}")
    public ResponseEntity<Integer> getTotalCaloriesConsumedByDate(
            @PathVariable String userId,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        int totalCalories = recipeService.getTotalCaloriesConsumedByDate(userId, date);
        return new ResponseEntity<>(totalCalories, HttpStatus.OK);
    }
}
