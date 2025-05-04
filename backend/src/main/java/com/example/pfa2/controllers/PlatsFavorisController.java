package com.example.pfa2.controllers;

import com.example.pfa2.models.PlatsFavoris;
import com.example.pfa2.services.PlatsFavorisService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/favorites")
@CrossOrigin(origins = "*") // For development only, restrict in production
public class PlatsFavorisController {

    @Autowired
    private PlatsFavorisService platsFavorisService;

    /**
     * Get all favorite recipes for a user
     * 
     * @param userId User ID
     * @return List of favorite recipes
     */
    @GetMapping("/{userId}")
    public ResponseEntity<List<PlatsFavoris>> getFavoritesByUserId(@PathVariable String userId) {
        System.out.println("Looking up user with ID: " + userId);
        List<PlatsFavoris> favorites = platsFavorisService.getFavoritesByUserId(userId);
        
        return ResponseEntity.ok(favorites);
    }

    /**
     * Check if a recipe is in user's favorites
     * 
     * @param userId   User ID
     * @param recipeId Recipe ID
     * @return Boolean status
     */
    @GetMapping("/check/{userId}/{recipeId}")
    public ResponseEntity<Map<String, Boolean>> checkIfFavorite(
            @PathVariable String userId,
            @PathVariable String recipeId) {
        boolean isFavorite = platsFavorisService.isRecipeInFavorites(userId, recipeId);
        return ResponseEntity.ok(Map.of("isFavorite", isFavorite));
    }

    /**
     * Add a recipe to user's favorites
     * 
     * @param request Request body containing userId and recipeId
     * @return The added favorite recipe
     */
    @PostMapping("/add")
    public ResponseEntity<?> addToFavorites(@RequestBody Map<String, String> request) {
        String userId = request.get("userId");
        String recipeId = request.get("recipeId");

        if (userId == null || recipeId == null) {
            return ResponseEntity.badRequest().body("userId and recipeId are required");
        }

        try {
            PlatsFavoris favorite = platsFavorisService.addToFavorites(userId, recipeId);
            return ResponseEntity.status(HttpStatus.CREATED).body(favorite);
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to add recipe to favorites: " + e.getMessage());
        }
    }

    /**
     * Remove a recipe from user's favorites
     * 
     * @param request Request body containing userId and recipeId
     * @return Success message
     */
    @DeleteMapping("/remove")
    public ResponseEntity<?> removeFromFavorites(@RequestBody Map<String, String> request) {
        String userId = request.get("userId");
        String recipeId = request.get("recipeId");

        if (userId == null || recipeId == null) {
            return ResponseEntity.badRequest().body("userId and recipeId are required");
        }

        try {
            platsFavorisService.removeFromFavorites(userId, recipeId);
            return ResponseEntity.ok("Recipe removed from favorites");
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to remove recipe from favorites: " + e.getMessage());
        }
    }
}