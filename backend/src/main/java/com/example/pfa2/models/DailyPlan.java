package com.example.pfa2.models;

import lombok.Data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Document(collection = "DailyPlan")
@Data
public class DailyPlan {
    @Id
    private String id;
    private String userId;
    private LocalDate date;
    private Map<String, Recipe> meals = new HashMap<>();

    private int totalCalories;
    private boolean completed;

    public DailyPlan() {
        this.date = LocalDate.now();
        this.completed = false;
    }
    
    public DailyPlan(String userId2) {
        this.userId = userId2;
        this.date = LocalDate.now();
    }
    
    // Add a meal to the daily plan
    public void addMeal(String mealType, Recipe recipe) {
        meals.put(mealType, recipe);
    }
    
    // Check if the plan is current (today's date)
    public boolean isCurrent() {
        return date.equals(LocalDate.now());
    }
    
    // Reset the plan for a new day
    public void resetForNewDay() {
        this.date = LocalDate.now();
        this.meals.clear();
    }

    //Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
    
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public Map<String, Recipe> getMeals() {
        return meals;
    }

    public void setMeals(Map<String, Recipe> meals) {
        this.meals = meals;
    }

    public int getTotalCalories() {
        return totalCalories;
    }

    public void setTotalCalories(int totalCalories) {
        this.totalCalories = totalCalories;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public void calculateTotalCalories() {
        totalCalories = meals.values().stream()
                .mapToInt(Recipe::getCalories)
                .sum();
    }

    public void markAsCompleted() {
        this.completed = true;
    }

    public void markAsNotCompleted() {
        this.completed = false;
    }

    public void clearMeals() {
        this.meals.clear();
    }

    public void removeMeal(String mealType) {
        this.meals.remove(mealType);
    }

    public Recipe getMeal(String mealType) {
        return this.meals.get(mealType);
    }

    public boolean hasMeal(String mealType) {
        return this.meals.containsKey(mealType);
    }

    public boolean isEmpty() {
        return this.meals.isEmpty();
    }

    public boolean isFull() {
        return this.meals.size() >= 3; // Assuming 3 meals per day
    }

    public void clear() {
        this.meals.clear();
        this.totalCalories = 0;
        this.completed = false;
    }
}