package com.example.pfa2.dto;

public class ConsumedPlateRequest {
    private String recipeId;
    private String meal;

    // Constructors
    public ConsumedPlateRequest() {
    }

    public ConsumedPlateRequest(String recipeId, String meal) {
        this.recipeId = recipeId;
        this.meal = meal;
    }

    // Getters and Setters
    public String getRecipeId() {
        return recipeId;
    }

    public void setRecipeId(String recipeId) {
        this.recipeId = recipeId;
    }

    public String getMeal() {
        return meal;
    }

    public void setMeal(String meal) {
        this.meal = meal;
    }
}