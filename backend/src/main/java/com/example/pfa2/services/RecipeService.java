package com.example.pfa2.services;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.pfa2.models.PlatsConsommes;
import com.example.pfa2.models.PlatsFavoris;
import com.example.pfa2.models.Recipe;
import com.example.pfa2.models.User;
import com.example.pfa2.repository.PlatsConsommesRepository;
import com.example.pfa2.repository.PlatsFavorisRepository;
import com.example.pfa2.repository.RecipeRepository;
import com.example.pfa2.repository.UserRepository;

@Service
public class RecipeService {
    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private PlatsFavorisRepository platsFavorisRepository;
    
    @Autowired
    private PlatsConsommesRepository platsConsommesRepository;
    
    @Autowired
    private UserRepository userRepository;
    
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

    // Méthodes pour PlatsFavoris
    public List<PlatsFavoris> getFavoriteRecipes(String userId) {
        return platsFavorisRepository.findByUserId(userId);
    }
    
    public PlatsFavoris addFavoriteRecipe(String userId, String recipeId) {
        Optional<Recipe> recipeOpt = recipeRepository.findById(recipeId);
        Optional<User> userOpt = userRepository.findById(userId);
        
        if (recipeOpt.isPresent() && userOpt.isPresent()) {
            Recipe recipe = recipeOpt.get();
            User user = userOpt.get();
            
            // Vérifier si le plat est déjà dans les favoris
            if (!platsFavorisRepository.existsByUserIdAndId(userId, recipeId)) {
                PlatsFavoris platsFavoris = new PlatsFavoris(recipe, userId);
                
                // Ajouter l'ID à la liste des favoris de l'utilisateur
                List<String> platFavoriIds = user.getPlatFavoriIds();
                platFavoriIds.add(recipeId);
                user.setPlatFavoriIds(platFavoriIds);
                userRepository.save(user);
                
                return platsFavorisRepository.save(platsFavoris);
            }
        }
        return null;
    }
    
    public void removeFavoriteRecipe(String userId, String recipeId) {
        Optional<User> userOpt = userRepository.findById(userId);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Retirer l'ID de la liste des favoris de l'utilisateur
            List<String> platFavoriIds = user.getPlatFavoriIds();
            platFavoriIds.removeIf(id -> id.equals(recipeId));
            user.setPlatFavoriIds(platFavoriIds);
            userRepository.save(user);
            
            // Trouver et supprimer le plat favori
            List<PlatsFavoris> userFavorites = platsFavorisRepository.findByUserId(userId);
            userFavorites.stream()
                .filter(fav -> fav.getId().equals(recipeId))
                .findFirst()
                .ifPresent(fav -> platsFavorisRepository.delete(fav));
        }
    }
    
    // Méthodes pour PlatsConsommes
    public List<PlatsConsommes> getConsumedRecipes(String userId) {
        return platsConsommesRepository.findByUserId(userId);
    }
    
    public List<PlatsConsommes> getConsumedRecipesByDate(String userId, LocalDate date) {
        LocalDateTime startOfDay = date.atStartOfDay();
        LocalDateTime endOfDay = date.atTime(LocalTime.MAX);
        return platsConsommesRepository.findByUserIdAndDateConsommationBetween(userId, startOfDay, endOfDay);
    }
    
    public PlatsConsommes addConsumedRecipe(String userId, String recipeId, String repas) {
        Optional<Recipe> recipeOpt = recipeRepository.findById(recipeId);
        
        if (recipeOpt.isPresent()) {
            Recipe recipe = recipeOpt.get();
            PlatsConsommes platsConsommes = new PlatsConsommes(recipe, userId, repas);
            return platsConsommesRepository.save(platsConsommes);
        }
        return null;
    }
    
    public int getTotalCaloriesConsumedByDate(String userId, LocalDate date) {
        List<PlatsConsommes> consumedRecipes = getConsumedRecipesByDate(userId, date);
        return consumedRecipes.stream()
                .mapToInt(PlatsConsommes::getCalories)
                .sum();
    }
}
