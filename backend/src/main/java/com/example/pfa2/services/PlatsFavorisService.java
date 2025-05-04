package com.example.pfa2.services;

import com.example.pfa2.models.PlatsFavoris;
import com.example.pfa2.models.Recipe;
import com.example.pfa2.repository.PlatsFavorisRepository;
import com.example.pfa2.repository.RecipeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PlatsFavorisService {

    @Autowired
    private PlatsFavorisRepository platsFavorisRepository;

    @Autowired
    private RecipeRepository recipeRepository;

    /**
     * Get all favorite recipes for a specific user
     * 
     * @param userId the ID of the user
     * @return List of favorite recipes
     */
    public List<PlatsFavoris> getFavoritesByUserId(String userId) {
        return platsFavorisRepository.findByUserId(userId);
    }

    /**
     * Check if a recipe is in user's favorites
     * 
     * @param userId   the ID of the user
     * @param recipeId the ID of the recipe
     * @return true if the recipe is in favorites, false otherwise
     */
    public boolean isRecipeInFavorites(String userId, String recipeId) {
        return platsFavorisRepository.existsByUserIdAndId(userId, recipeId);
    }

    /**
     * Add a recipe to user's favorites
     * 
     * @param userId   the ID of the user
     * @param recipeId the ID of the recipe
     * @return the saved favorite recipe
     */
    public PlatsFavoris addToFavorites(String userId, String recipeId) {
        // Check if already in favorites
        if (isRecipeInFavorites(userId, recipeId)) {
            throw new IllegalStateException("Recipe is already in favorites");
        }

        // Find the recipe
        Optional<Recipe> recipeOpt = recipeRepository.findById(recipeId);
        if (recipeOpt.isEmpty()) {
            throw new IllegalArgumentException("Recipe not found with id: " + recipeId);
        }

        // Create and save favorite
        Recipe recipe = recipeOpt.get();
        PlatsFavoris favorite = new PlatsFavoris(recipe, userId);
        return platsFavorisRepository.save(favorite);
    }

    /**
     * Remove a recipe from user's favorites
     * 
     * @param userId   the ID of the user
     * @param recipeId the ID of the recipe
     */
    public void removeFromFavorites(String userId, String recipeId) {
        // Check if in favorites
        if (!isRecipeInFavorites(userId, recipeId)) {
            throw new IllegalStateException("Recipe is not in favorites");
        }

        // Delete from favorites
        platsFavorisRepository.deleteById(recipeId);
    }
}