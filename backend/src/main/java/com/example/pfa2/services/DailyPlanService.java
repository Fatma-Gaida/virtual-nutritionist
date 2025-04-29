package com.example.pfa2.services;

import java.time.LocalDate;
import java.util.HashMap;

import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.pfa2.models.DailyPlan;
import com.example.pfa2.models.User;
import com.example.pfa2.models.Recipe;
import com.example.pfa2.repository.DailyPlanRepository;
import com.example.pfa2.repository.RecipeRepository;
import com.example.pfa2.repository.UserRepository;

@Service
public class DailyPlanService {
    
    @Autowired
    private DailyPlanRepository dailyPlanRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private RecipeRepository recipeRepository;
    
    /**
     * Get the daily plan for a user by user ID and date
     * If no plan exists for that date, create a new one
     */
    public DailyPlan getDailyPlanForUser(String userId, LocalDate date) {
        // Find existing plan for the user and date
        Optional<DailyPlan> existingPlan = dailyPlanRepository.findByUserIdAndDate(userId, date);
        
        // Return the existing plan if found
        if (existingPlan.isPresent()) {
            return existingPlan.get();
        }
        
        // Create a new plan if none exists
        DailyPlan newPlan = new DailyPlan();
        newPlan.setUserId(userId);
        newPlan.setDate(date);
        newPlan.setMeals(new HashMap<>());
        newPlan.setTotalCalories(0);
        newPlan.setCompleted(false);
        
        return dailyPlanRepository.save(newPlan);
    }
    
    /**
     * Get today's daily plan for a user
     */
    public DailyPlan getTodayPlanForUser(String userId) {
        return getDailyPlanForUser(userId, LocalDate.now());
    }
    
    /**
     * Add a meal to the user's daily plan
     */
    public DailyPlan addMealToPlan(String userId, String mealType, String recipeId) {
        // Get today's plan
        DailyPlan dailyPlan = getTodayPlanForUser(userId);
        
        // Find the recipe
        Optional<Recipe> recipeOpt = recipeRepository.findById(recipeId);
        if (!recipeOpt.isPresent()) {
            throw new IllegalArgumentException("Recipe not found with ID: " + recipeId);
        }
        
        Recipe recipe = recipeOpt.get();
        
        // Add the meal to the plan
        dailyPlan.addMeal(mealType, recipe);
        
        // Recalculate total calories
        dailyPlan.calculateTotalCalories();
        
        // Save and return updated plan
        return dailyPlanRepository.save(dailyPlan);
    }
    
    /**
     * Remove a meal from the user's daily plan
     */
    public DailyPlan removeMealFromPlan(String userId, String mealType) {
        // Get today's plan
        DailyPlan dailyPlan = getTodayPlanForUser(userId);
        
        // Remove the meal
        dailyPlan.removeMeal(mealType);
        
        // Recalculate total calories
        dailyPlan.calculateTotalCalories();
        
        // Save and return updated plan
        return dailyPlanRepository.save(dailyPlan);
    }
    
    /**
     * Clear all meals from the user's daily plan
     */
    public DailyPlan clearMealsFromPlan(String userId) {
        // Get today's plan
        DailyPlan dailyPlan = getTodayPlanForUser(userId);
        
        // Clear meals
        dailyPlan.clearMeals();
        dailyPlan.setTotalCalories(0);
        
        // Save and return updated plan
        return dailyPlanRepository.save(dailyPlan);
    }
    
    /**
     * Mark daily plan as completed
     */
    public DailyPlan markPlanAsCompleted(String userId) {
        DailyPlan dailyPlan = getTodayPlanForUser(userId);
        dailyPlan.markAsCompleted();
        return dailyPlanRepository.save(dailyPlan);
    }
    
    /**
     * Get the calorie goal for a user
     */
    public int getUserCalorieGoal(String userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Assuming User has a calorieGoal field
            // If not, you can implement a calculation based on user data
            return user.getCalorieGoal(); 
        }
        // Default calorie goal if user not found
        return 2000;
    }
}