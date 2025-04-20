package com.example.pfa2.services;
import com.example.pfa2.models.DailyPlan;
import com.example.pfa2.models.Recipe;
import com.example.pfa2.models.User;
import com.example.pfa2.repository.DailyPlanRepository;
import com.example.pfa2.repository.RecipeRepository;
import com.example.pfa2.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private DailyPlanRepository dailyPlanRepository;


    public User creerCompte(User user) {
        // Check if email already exists
        if (userRepository.findByEmail(user.getEmail()) != null) {
            throw new RuntimeException("Email déjà utilisé !");
        }

        // Validate required fields
        if (user.getNom() == null || user.getEmail() == null || user.getMotDePasse() == null ||
                user.getDob() == null || user.getSexe() == null || user.getEtatActivite() == null) {
            throw new IllegalArgumentException("Tous les champs obligatoires doivent être fournis");
        }

        // Initialize null collections to empty lists
        if (user.getAllergies() == null) {
            user.setAllergies(new ArrayList<>());
        }
        if (user.getMaladies() == null) {
            user.setMaladies(new ArrayList<>());
        }
        if (user.getNotificationIds() == null) {
            user.setNotificationIds(new ArrayList<>());
        }
        if (user.getObjectifIds() == null) {
            user.setObjectifIds(new ArrayList<>());
        }
        if (user.getPlatFavoriIds() == null) {
            user.setPlatFavoriIds(new ArrayList<>());
        }

        return userRepository.save(user);
    }

    public Optional<User> getUserById(String id) {
        return userRepository.findById(id);
    }
    
    public DailyPlan getUserDailyPlan(String userId) {
        // Try to find an existing plan for today
        Optional<DailyPlan> existingPlan = dailyPlanRepository.findByUserIdAndDate(userId, LocalDate.now());
        
        if (existingPlan.isPresent()) {
            return existingPlan.get();
        }
        
        // Try to find any plan for this user (might be from a previous day)
        Optional<DailyPlan> oldPlan = dailyPlanRepository.findByUserId(userId);
        
        if (oldPlan.isPresent()) {
            DailyPlan plan = oldPlan.get();
            // If it's an old plan, reset it for today
            if (!plan.getDate().equals(LocalDate.now())) {
                plan.resetForNewDay();
                return dailyPlanRepository.save(plan);
            }
            return plan;
        }
        
        // If no plan exists at all, create a new one
        DailyPlan newPlan = new DailyPlan(userId);
        return dailyPlanRepository.save(newPlan);
    }
    
    public DailyPlan addMealToDailyPlan(String userId, String recipeId, String mealType) {
        // Get recipe
        Optional<Recipe> recipeOpt = recipeRepository.findById(recipeId);
        if (recipeOpt.isEmpty()) {
            throw new RuntimeException("Recette introuvable avec l'ID : " + recipeId);
        }
        Recipe recipe = recipeOpt.get();
        
        // Get or create daily plan
        DailyPlan dailyPlan = getUserDailyPlan(userId);
        
        // Add meal to plan
        dailyPlan.addMeal(mealType, recipe);
        
        // Save and return updated plan
        return dailyPlanRepository.save(dailyPlan);
    }
    
}

