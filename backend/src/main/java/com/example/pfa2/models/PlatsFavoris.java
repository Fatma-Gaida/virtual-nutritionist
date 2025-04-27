package com.example.pfa2.models;

import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "PlatsFavoris")
public class PlatsFavoris extends Recipe {
    
    private String userId;
    
    // Constructeurs
    public PlatsFavoris() {
        super();
    }
    
    public PlatsFavoris(Recipe recipe, String userId2) {
        super(recipe.getName(), recipe.getDescription(), recipe.getImageUrl(),
              recipe.getPreparationTime(), recipe.getCalories(), 
              recipe.getMealType(), recipe.getIngredients());
        this.setId(recipe.getId());
        this.userId = userId2;
    }
    
    // Getters and Setters
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
}
