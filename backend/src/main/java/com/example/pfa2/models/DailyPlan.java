package com.example.pfa2.models;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Document(collection = "dailyPlans")
@Data
public class DailyPlan {
    @Id
    private String id;
    private String userId;
    private LocalDate date;
    private Map<String, Recipe> meals = new HashMap<>();
    
    public DailyPlan() {
        this.date = LocalDate.now();
    }
    
    public DailyPlan(String userId) {
        this.userId = userId;
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
}