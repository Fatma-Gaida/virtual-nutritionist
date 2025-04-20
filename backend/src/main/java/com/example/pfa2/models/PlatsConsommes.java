package com.example.pfa2.models;

import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;

@Document(collection = "platsConsommes")
public class PlatsConsommes extends Recipe {
    
    private String userId;
    private LocalDateTime dateConsommation;
    private String meal; // "Petit-déjeuner", "Déjeuner", "Dîner", "Snacks"
    
    // Constructeurs
    public PlatsConsommes() {
        super();
        this.dateConsommation = LocalDateTime.now();
    }
    
    public PlatsConsommes(Recipe recipe, String userId, String meal) {
        super(recipe.getName(), recipe.getDescription(), recipe.getImageUrl(),
              recipe.getPreparationTime(), recipe.getCalories(), 
              recipe.getMealType(), recipe.getIngredients());
        this.setId(recipe.getId());
        this.userId = userId;
        this.meal = meal;
        this.dateConsommation = LocalDateTime.now();
    }
    
    // Getters and Setters
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    public LocalDateTime getDateConsommation() {
        return dateConsommation;
    }
    
    public void setDateConsommation(LocalDateTime dateConsommation) {
        this.dateConsommation = dateConsommation;
    }
    
    public String getMeal() {
        return meal;
    }
    
    public void setMeal(String meal) {
        this.meal = meal;
    }
}