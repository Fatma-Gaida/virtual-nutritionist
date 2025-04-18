package com.example.pfa2.controllers;

import com.example.pfa2.models.Recipe;
import com.example.pfa2.models.User;
import com.example.pfa2.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/creer-compte")
    public User creerCompte(@RequestBody User user) {
        return userService.creerCompte(user);
    }
    // Get user by ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable String id) {
        try {
            Optional<User> user = userService.getUserById(id);

            if (user.isPresent()) {
                return ResponseEntity.ok(user.get()); // HTTP 200 + user data
            } else {
                return ResponseEntity.notFound().build(); // HTTP 404
            }

        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Invalid ID format"); // HTTP 400
        }
    }

    //Add recipe into PlatsFavoris 
    @PutMapping("/{id}/favoris/add/{recipeId}")
    public ResponseEntity<?> addRecipeToFavorites(@PathVariable String id, @PathVariable String recipeId) {
        try {
            User updatedUser = userService.addRecipeToFavorites(id, recipeId);
            return ResponseEntity.ok(updatedUser);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    //Get all favorites recipes of a specefic user
    @GetMapping("/{id}/favoris")
    public ResponseEntity<?> getUserFavoriteRecipes(@PathVariable String id) {
        try {
            List<Recipe> recipes = userService.getFavoriteRecipes(id);
            return ResponseEntity.ok(recipes);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    //Remove recipe from FavoriteRecipes 
    @PutMapping("/{id}/favoris/remove/{recipeId}")
    public ResponseEntity<?> removeRecipeFromFavorites(@PathVariable String id, @PathVariable String recipeId) {
        try {
            User updatedUser = userService.removeRecipeFromFavorites(id, recipeId);
            return ResponseEntity.ok(updatedUser);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}