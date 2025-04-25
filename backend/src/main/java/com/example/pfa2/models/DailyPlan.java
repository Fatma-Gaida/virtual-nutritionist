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

    // Change to match the DB structure
    private Map<String, MealInfo> meals = new HashMap<>();
    private int totalCalories;
    private boolean completed;

    // Inner class to represent meal info
    @Data
    public static class MealInfo {
        private String recipeId;
        private String name;
        private int calories;
    }

    public DailyPlan() {
        this.date = LocalDate.now();
        this.completed = false;
        this.totalCalories = 0;
    }

    public DailyPlan(String userId) {
        this.userId = userId;
        this.date = LocalDate.now();
        this.completed = false;
        this.totalCalories = 0;
    }

    // Add a meal to the daily plan
    public void addMeal(String mealType, Recipe recipe) {
        MealInfo mealInfo = new MealInfo();
        mealInfo.setRecipeId(recipe.getId());
        mealInfo.setName(recipe.getName());
        mealInfo.setCalories(recipe.getCalories());

        meals.put(mealType, mealInfo);
        recalculateTotalCalories();
    }

    private void recalculateTotalCalories() {
        this.totalCalories = meals.values().stream()
                .mapToInt(MealInfo::getCalories)
                .sum();
    }

    // Check if the plan is current (today's date)
    public boolean isCurrent() {
        return date.equals(LocalDate.now());
    }

    // Reset the plan for a new day
    public void resetForNewDay() {
        this.date = LocalDate.now();
        this.meals.clear();
        this.totalCalories = 0;
        this.completed = false;
    }
}