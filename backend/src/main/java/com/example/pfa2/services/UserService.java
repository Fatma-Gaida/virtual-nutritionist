package com.example.pfa2.services;
import com.example.pfa2.models.DailyPlan;
import com.example.pfa2.models.Recipe;
import com.example.pfa2.models.User;
import com.example.pfa2.repository.DailyPlanRepository;
import com.example.pfa2.repository.RecipeRepository;
import com.example.pfa2.repository.UserRepository;

import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.Period;
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
        if (user.getNom() == null || user.getEmail() == null || user.getMotDePasse() == null )
        {
            throw new IllegalArgumentException("Tous les champs obligatoires doivent être fournis");
        }
        return userRepository.save(user);
    }


    public User updateUserDetails(String userId,
                                  double poids,
                                  double taille,
                                  LocalDate dob,
                                  String sexe,
                                  List<String> allergies,
                                  List<String> maladies,
                                  String etatActivite) {

        return userRepository.findById(new ObjectId(userId))
                .map(user -> {
                    // Update only the specified fields
                    if (poids > 0) user.setPoids(poids);
                    if (taille > 0) user.setTaille(taille);
                    if (dob != null) user.setDob(dob);
                    if (sexe != null) user.setSexe(sexe);
                    if (allergies != null) user.setAllergies(allergies);
                    if (maladies != null) user.setMaladies(maladies);
                    if (etatActivite != null) user.setEtatActivite(etatActivite);

                    return userRepository.save(user);
                })
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
    }



    public Optional<User> getUserById(ObjectId id) {
        return userRepository.findById(id);
    }
    /*
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
    */
    public DailyPlan getUserDailyPlan(String userId) {
        try {
            // Try to find an existing plan for today
            Optional<DailyPlan> existingPlan = dailyPlanRepository.findByUserIdAndDate(userId, LocalDate.now());

            if (existingPlan.isPresent()) {
                return existingPlan.get();
            }

            // Try to find most recent plan for this user
            Optional<DailyPlan> oldPlan = dailyPlanRepository.findFirstByUserIdOrderByDateDesc(userId);

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
        } catch (Exception e) {
            // Log the specific error
            System.err.println("Error in getUserDailyPlan: " + e.getMessage());
            e.printStackTrace();
            throw e; // Rethrow to be handled by controller
        }
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
//        dailyPlan.addMeal(mealType, recipe);

        // Save and return updated plan
        return dailyPlanRepository.save(dailyPlan);
    }
    
    
    public User authenticate(String email, String password) {
        String trimmedEmail = email.trim();
        System.out.println("Searching for email: '" + trimmedEmail + "'");

        // For debugging, list all emails in the database
        List<User> allUsers = userRepository.findAll();
        System.out.println("All emails in the database:");
        for (User u : allUsers) {
            System.out.println("- " + u.getEmail());
        }

        User user = userRepository.findByEmail(trimmedEmail);


        if (!user.getMotDePasse().equals(password)) {
            System.out.println("PASSWORD MISMATCH");
            throw new RuntimeException("Invalid password");
        }

        return user;
    }
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }


    public double calculateTDEE(User user) {
        // Validation des données
        if (user.getPoids() <= 0 || user.getTaille() <= 0 || user.getDob() == null
                || user.getSexe() == null || user.getEtatActivite() == null) {
            throw new IllegalArgumentException("Données utilisateur incomplètes ou invalides.");
        }

        // Calcul de l'âge
        int age = Period.between(user.getDob(), LocalDate.of(2025, 4, 23)).getYears();
        if (age <= 0) {
            throw new IllegalArgumentException("Âge invalide.");
        }

        // Calcul du TMB
        double tmb;
        if (user.getSexe().equalsIgnoreCase("Man")) {
            tmb = (10 * user.getPoids()) + (6.25 * user.getTaille()) - (5 * age) + 5;
        } else if (user.getSexe().equalsIgnoreCase("Woman")) {
            tmb = (10 * user.getPoids()) + (6.25 * user.getTaille()) - (5 * age) - 161;
        } else {
            throw new IllegalArgumentException("Sexe invalide. Valeurs attendues : 'Homme' ou 'Femme'.");
        }

        // Calcul du TDEE en fonction du niveau d'activité
        double activityFactor;
        switch (user.getEtatActivite()) {
            case "Sedentary":
                activityFactor = 1.55;
                break;
            case "Lightly active":
                activityFactor = 1.85;
                break;
            case "Moderately active":
                activityFactor = 2.2;
                break;
            case "Very active":
                activityFactor = 2.4;
                break;
            default:
                throw new IllegalArgumentException("Niveau d'activité invalide.");
        }

        BigDecimal tdee = BigDecimal.valueOf(tmb * activityFactor)
                .setScale(0, RoundingMode.HALF_UP);
        return tdee.doubleValue();
    }

}

