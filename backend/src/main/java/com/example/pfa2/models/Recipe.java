package com.example.pfa2.models;

import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "recipes")
public class Recipe {
    @Id
    private String id;
    private String name;
    private String description;
    private String imageUrl;
    private int preparationTime; 
    private int calories;
    private String mealType; // "Breakfast", "Lunch", "Dinner", "Snack"
    private List<Ingredient> ingredients;

    // Constructeurs
    public Recipe() {}
    
    public Recipe(String name, String description, String imageUrl, 
                  int preparationTime, int calories, String mealType, 
                  List<Ingredient> ingredients) {
        this.name = name;
        this.description = description;
        this.imageUrl = imageUrl;
        this.preparationTime = preparationTime;
        this.calories = calories;
        this.mealType = mealType;
        this.ingredients = ingredients;
    }
    
    // Getters and Setters
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public int getPreparationTime() {
        return preparationTime;
    }
    
    public void setPreparationTime(int preparationTime) {
        this.preparationTime = preparationTime;
    }
    
    public int getCalories() {
        return calories;
    }
    
    public void setCalories(int calories) {
        this.calories = calories;
    }
    
    public String getMealType() {
        return mealType;
    }
    
    public void setMealType(String mealType) {
        this.mealType = mealType;
    }
    
    public List<Ingredient> getIngredients() {
        return ingredients;
    }
    
    public void setIngredients(List<Ingredient> ingredients) {
        this.ingredients = ingredients;
    }
    
}
