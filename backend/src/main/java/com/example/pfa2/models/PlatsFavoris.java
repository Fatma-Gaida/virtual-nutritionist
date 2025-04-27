package com.example.pfa2.models;

import org.bson.types.ObjectId;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "PlatsFavoris")
public class PlatsFavoris extends Recipe {
    
    private ObjectId userId;
    private boolean isFavorite;
    
    // Constructeurs
    public PlatsFavoris() {
        super();
        this.isFavorite = true;
    }
    
    public PlatsFavoris(Recipe recipe, ObjectId userId2) {
        super(recipe.getName(), recipe.getDescription(), recipe.getImageUrl(),
              recipe.getPreparationTime(), recipe.getCalories(), 
              recipe.getMealType(), recipe.getIngredients());
        this.setId(recipe.getId());
        this.userId = userId2;
        this.isFavorite = true;
    }
    
    // Getters and Setters
    public ObjectId getUserId() {
        return userId;
    }
    
    public void setUserId(ObjectId userId) {
        this.userId = userId;
    }
    
    public boolean isFavorite() {
        return isFavorite;
    }
    
    public void setFavorite(boolean isFavorite) {
        this.isFavorite = isFavorite;
    }
}
