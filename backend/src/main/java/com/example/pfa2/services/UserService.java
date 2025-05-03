package com.example.pfa2.services;

import com.example.pfa2.models.DailyPlan;
import com.example.pfa2.models.Recipe;
import com.example.pfa2.models.User;
import com.example.pfa2.repository.DailyPlanRepository;
import com.example.pfa2.repository.RecipeRepository;
import com.example.pfa2.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
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

    /* 
    public Optional<User> getUserById(String idU) {
        return userRepository.findById(idU);
    }
    */
    public Optional<User> getUserById(String userId) {
        System.out.println("Looking up user with ID: " + userId);

        // Print all user IDs in the database for debugging
        List<User> allUsers = userRepository.findAll();
        System.out.println("All user IDs in the database:");
        for (User u : allUsers) {
            System.out.println("- " + u.getId());
        }

        Optional<User> user = userRepository.findById(userId);
        System.out.println("User found: " + (user.isPresent() ? "YES" : "NO"));

        return user;
    }

    // Mettre à jour l'objectif de calories
    public User updateCalorieGoal(String userId, int caloriesObjectif) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setCalorieGoal(caloriesObjectif);
            return userRepository.save(user);
        }
        throw new RuntimeException("Utilisateur non trouvé");
    }

    public DailyPlan getUserDailyPlan(String userId) {
        // Try to find an existing plan for today
        Optional<DailyPlan> existingPlan = dailyPlanRepository.findByUserIdAndDate(userId, LocalDate.now());

        if (existingPlan.isPresent()) {
            return existingPlan.get();
        }

        // Try to find any plan for this user (might be from a previous day)
        Iterable<DailyPlan> oldPlan = dailyPlanRepository.findByUserId(userId);

        //if (oldPlan.isPresent()) {
        //DailyPlan plan = oldPlan.get();
            DailyPlan plan = oldPlan.iterator().hasNext() ? oldPlan.iterator().next() : null;
            // If it's an old plan, reset it for today
            if (!plan.getDate().equals(LocalDate.now())) {
                plan.resetForNewDay();
                return dailyPlanRepository.save(plan);
            }
            //return plan;
        //}

        // If no plan exists at all, create a new one
        DailyPlan newPlan = new DailyPlan(userId);
        Recipe breakfastRecipe = recipeRepository.findById("67fba92eb6527b3a505df972").orElse(null);
        if (breakfastRecipe != null) {
            newPlan.addMeal("Breakfast", breakfastRecipe);
        } else {
            System.out.println("Recette de petit-déjeuner introuvable !");
        }
        Recipe lunchRecipe = recipeRepository.findById("680453cb5d9c927a4365c2d1").orElse(null);
        if (lunchRecipe != null) {
            newPlan.addMeal("Lunch", lunchRecipe);
        } else {
            System.out.println("Recette de déjeuner introuvable !");
        }
        Recipe dinnerRecipe = recipeRepository.findById("680454cb5d9c927a4365c2d2").orElse(null);
        if (dinnerRecipe != null) {
            newPlan.addMeal("Dinner", dinnerRecipe);
        } else {
            System.out.println("Recette de dîner introuvable !");
        }
        newPlan.setDate(LocalDate.now());
        newPlan.setCompleted(false); // Set completed to false for a new plan
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

    /*
     * public User authenticate(String email, String password) {
     * String trimmedEmail = email.trim();
     * System.out.println("Searching for email: '" + trimmedEmail + "'");
     * 
     * // For debugging, list all emails in the database
     * List<User> allUsers = userRepository.findAll();
     * System.out.println("All emails in the database:");
     * for (User u : allUsers) {
     * System.out.println("- " + u.getEmail());
     * }
     * 
     * User user = userRepository.findByEmail(trimmedEmail);
     * 
     * if (!user.getMotDePasse().equals(password)) {
     * System.out.println("PASSWORD MISMATCH");
     * throw new RuntimeException("Invalid password");
     * }
     * 
     * return user;
     * }
     */
    public User authenticate(String email, String password) {
        String trimmedEmail = email.trim();
        System.out.println("Searching for email: '" + trimmedEmail + "'");

        // For debugging, list all emails in the database
        List<User> allUsers = userRepository.findAll();
        System.out.println("All emails in the database:");
        for (User u : allUsers) {
            System.out.println("- " + u.getEmail());
        }
        System.out.println("Provided password: " + password);
        System.out.println("**********************************************");
        User user = userRepository.findByEmail(trimmedEmail);
        System.out.println("User found: " + (user != null ? user.getEmail() : "null"));
        // Check if user exists
        if (user == null) {
            System.out.println("USER NOT FOUND");
            throw new RuntimeException("Invalid email or password");
        }

        if (!user.getMotDePasse().equals(password)) {
            System.out.println("PASSWORD MISMATCH");
            System.out.println("Provided password: " + password);
            System.out.println("Stored password: " + user.getMotDePasse());
            throw new RuntimeException("Invalid password");
        } else {
            System.out.println("PASSWORD MATCHED");
        }

        return user;
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }


    @Autowired
    private MongoTemplate mongoTemplate;

    public User findUserByIdDirectly(String userId) {
        try {
            Query query = new Query(Criteria.where("_id").is(userId));
            return mongoTemplate.findOne(query, User.class);
        } catch (Exception e) {
            System.out.println("Error in direct MongoDB query: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
