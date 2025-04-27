package com.example.pfa2.controllers;

import com.example.pfa2.models.DailyPlan;
import com.example.pfa2.services.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users/{userId}/daily-plan")
@CrossOrigin(origins = "*")
public class DailyPlanController {
    
    @Autowired
    private UserService userService;
    
    // Get the user's daily plan
    @GetMapping
    public ResponseEntity<DailyPlan> getUserDailyPlan(@PathVariable String userId) {
        try {
            DailyPlan dailyPlan = userService.getUserDailyPlan(userId);
            return new ResponseEntity<>(dailyPlan, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // Add a meal to the daily plan
    @PostMapping("/meals")
    public ResponseEntity<DailyPlan> addMealToDailyPlan(
            @PathVariable String userId,
            @RequestParam String recipeId,
            @RequestParam String mealType) {
        try {
            DailyPlan updatedPlan = userService.addMealToDailyPlan(userId, recipeId, mealType);
            return new ResponseEntity<>(updatedPlan, HttpStatus.OK);
        } catch (IllegalArgumentException e) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}