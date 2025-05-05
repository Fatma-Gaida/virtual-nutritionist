package com.example.pfa2.controllers;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.pfa2.models.DailyPlan;
import com.example.pfa2.models.Recipe;
import com.example.pfa2.models.User;
import com.example.pfa2.repository.UserRepository;
import com.example.pfa2.services.DailyPlanService;

@RestController
@RequestMapping("/api")
public class DailyPlanController {

    @Autowired
    private DailyPlanService dailyPlanService;

    @Autowired
    private UserRepository userRepository;

    /*
     * Get the daily plan for a user
     * If date parameter is provided, get the plan for that date
     * Otherwise, get today's plan
     */
    /* 
    @GetMapping("/users/{userId}/daily-plan")
    public ResponseEntity<?> getDailyPlan(
            @PathVariable String userId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
    
        // Verify user exists
        Optional<User> userOpt = userRepository.findById(userId);
        
    
        User user = userOpt.get();
    
        // If date is not provided, use today's date
        if (date == null) {
            date = LocalDate.now();
        }
    
        // Get daily plan for the user and date
        DailyPlan dailyPlan = dailyPlanService.getDailyPlanForUser(userId, date);
    
        // Convert to response format
        Map<String, Object> response = formatDailyPlanResponse(dailyPlan, user);
    
        return ResponseEntity.ok(response);
    }
    */
    @GetMapping("/users/{userId}/daily-plan")
public ResponseEntity<?> getDailyPlan(
        @PathVariable String userId,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {

    System.out.println("Looking up user with ID: " + userId);
    
    // Try to find the user
    Optional<User> userOpt = userRepository.findById(userId);
    
    // Debug output
    System.out.println("User found: " + userOpt.isPresent());
    
    // Return 404 if user not found
    if (!userOpt.isPresent()) {
        // Try to find any users in the database to confirm the repository works
        List<User> allUsers = userRepository.findAll();
        System.out.println("Total users in database: " + allUsers.size());
        if (!allUsers.isEmpty()) {
            System.out.println("First user ID: " + allUsers.get(0).getId());
        }
        
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found with ID: " + userId);
    }

    User user = userOpt.get();
    System.out.println("Retrieved user: " + user.getNom());

    // If date is not provided, use today's date
    if (date == null) {
        date = LocalDate.now();
    }

    // Get daily plan for the user and date
    try {
        DailyPlan dailyPlan = dailyPlanService.getDailyPlanForUser(userId, date);
        
        // Convert to response format
        Map<String, Object> response = formatDailyPlanResponse(dailyPlan, user);
        
        return ResponseEntity.ok(response);
    } catch (Exception e) {
        e.printStackTrace();
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body("Error retrieving daily plan: " + e.getMessage());
    }
    }
    /**
     * Add a meal to the user's daily plan
     */
    @PostMapping("/users/{userId}/daily-plan/meals")
    public ResponseEntity<?> addMealToDailyPlan(
            @PathVariable String userId,
            @RequestBody Map<String, String> mealRequest) {

        // Extract meal type and recipe ID from request
        String mealType = mealRequest.get("mealType");
        String recipeId = mealRequest.get("recipeId");

        if (mealType == null || recipeId == null) {
            return ResponseEntity.badRequest().body("Meal type and recipe ID must be provided");
        }

        try {
            // Add meal to plan
            DailyPlan updatedPlan = dailyPlanService.addMealToPlan(userId, mealType, recipeId);

            // Get user for response formatting
            Optional<User> userOpt = userRepository.findById(userId);
            if (!userOpt.isPresent()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
            }

            // Format response
            Map<String, Object> response = formatDailyPlanResponse(updatedPlan, userOpt.get());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to add meal: " + e.getMessage());
        }
    }

    /**
     * Remove a meal from the user's daily plan
     */
    @DeleteMapping("/users/{userId}/daily-plan/meals/{mealType}")
    public ResponseEntity<?> removeMealFromDailyPlan(
            @PathVariable String userId,
            @PathVariable String mealType) {

        try {
            // Remove meal from plan
            DailyPlan updatedPlan = dailyPlanService.removeMealFromPlan(userId, mealType);

            // Get user for response formatting
            Optional<User> userOpt = userRepository.findById(userId);
            if (!userOpt.isPresent()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
            }

            // Format response
            Map<String, Object> response = formatDailyPlanResponse(updatedPlan, userOpt.get());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to remove meal: " + e.getMessage());
        }
    }

    /**
     * Clear all meals from the user's daily plan
     */
    @DeleteMapping("/users/{userId}/daily-plan/meals")
    public ResponseEntity<?> clearDailyPlan(@PathVariable String userId) {
        try {
            // Clear meals from plan
            DailyPlan updatedPlan = dailyPlanService.clearMealsFromPlan(userId);

            // Get user for response formatting
            Optional<User> userOpt = userRepository.findById(userId);
            if (!userOpt.isPresent()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
            }

            // Format response
            Map<String, Object> response = formatDailyPlanResponse(updatedPlan, userOpt.get());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to clear daily plan: " + e.getMessage());
        }
    }


    /**
     * Format the daily plan response to match what the frontend expects
     */
    private Map<String, Object> formatDailyPlanResponse(DailyPlan dailyPlan, User user) {
        Map<String, Object> response = new HashMap<>();

        // Basic user info
        response.put("nom", user.getNom());
        response.put("date", formatDate(dailyPlan.getDate()));

        // Calorie information
        int totalCalories = dailyPlan.getTotalCalories();
        int calorieGoal = user.getCalorieGoal();
        double caloriePercentage = calorieGoal > 0 ? (double) totalCalories / calorieGoal : 0;

        response.put("totalCalories", totalCalories);
        response.put("calorieGoal", calorieGoal);
        response.put("caloriePercentage", caloriePercentage);

        // Meals list converted to the format expected by frontend
        response.put("meals", dailyPlan.getMeals().entrySet().stream()
                .map(entry -> formatMeal(entry.getKey(), entry.getValue()))
                .collect(Collectors.toList()));

        return response;
    }

    /**
     * Format a meal for the frontend
     */
    private Map<String, Object> formatMeal(String mealType, DailyPlan.MealEntry mealEntry) {
        Map<String, Object> mealMap = new HashMap<>();

        mealMap.put("id", mealEntry.getRecipeId());
        mealMap.put("type", mealType);
        mealMap.put("name", mealEntry.getName());
        mealMap.put("calories", mealEntry.getCalories());
        mealMap.put("imageUrl", ""); // Add default or fetch from Recipe if needed
        mealMap.put("timestamp", LocalDate.now().toString()); // Current date as timestamp

        return mealMap;
    }
    /**
     * Format a meal for the frontend
     */
    private Map<String, Object> formatMeal(String mealType, Recipe recipe) {
        Map<String, Object> mealMap = new HashMap<>();

        mealMap.put("id", recipe.getId());
        mealMap.put("type", mealType);
        mealMap.put("name", recipe.getName());
        mealMap.put("calories", recipe.getCalories());
        mealMap.put("imageUrl", recipe.getImageUrl());
        mealMap.put("timestamp", LocalDate.now().toString()); // Current date as timestamp

        return mealMap;
    }

    /**
     * Format date as a string
     */
    private String formatDate(LocalDate date) {
        return date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }
}