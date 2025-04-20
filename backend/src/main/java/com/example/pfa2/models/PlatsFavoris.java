package com.example.pfa2.models;

import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "platsFavoris")
public class PlatsFavoris extends Recipe {
    
    private String userId;
    private boolean isFavorite;
    
    // Constructeurs
    public PlatsFavoris() {
        super();
        this.isFavorite = true;
    }
    
    public PlatsFavoris(Recipe recipe, String userId) {
        super(recipe.getName(), recipe.getDescription(), recipe.getImageUrl(),
              recipe.getPreparationTime(), recipe.getCalories(), 
              recipe.getMealType(), recipe.getIngredients());
        this.setId(recipe.getId());
        this.userId = userId;
        this.isFavorite = true;
    }
    
    // Getters and Setters
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    public boolean isFavorite() {
        return isFavorite;
    }
    
    public void setFavorite(boolean isFavorite) {
        this.isFavorite = isFavorite;
    }
}
