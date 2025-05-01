package com.example.pfa2.services;

import com.example.pfa2.models.DashboardQuotidien;
import com.example.pfa2.models.Recipe;
import com.example.pfa2.models.User;
import com.example.pfa2.repository.DashboardQuotidienRepository;
import com.example.pfa2.repository.RecipeRepository;
import com.example.pfa2.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DashboardQuotidienService {

    @Autowired
    private DashboardQuotidienRepository dashboardRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private RecipeRepository recipeRepository;
    
    @Autowired
    private RecipeService recipeService;
    
    // Récupérer ou créer le dashboard quotidien d'un utilisateur
    public DashboardQuotidien getDashboardQuotidien(String userId) {
        LocalDate today = LocalDate.now();
        
        // Chercher un dashboard existant pour aujourd'hui
        Optional<DashboardQuotidien> dashboardOpt = dashboardRepository.findByUserIdAndDate(userId, today);
        
        if (dashboardOpt.isPresent()) {
            return dashboardOpt.get();
        } else {
            // Si pas de dashboard pour aujourd'hui, créer un nouveau
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                // Valeur par défaut pour calories nécessaires (peut être personnalisée)
                int caloriesNecessaires = user.getCalorieGoal() > 0 ? user.getCalorieGoal() : 2000;
                
                DashboardQuotidien nouveauDashboard = new DashboardQuotidien(userId, caloriesNecessaires);
                
                // Calculer les calories déjà consommées aujourd'hui
                int caloriesConsommees = recipeService.getTotalCaloriesConsumedByDate(userId, today);
                nouveauDashboard.setCaloriesConsommees(caloriesConsommees);
                nouveauDashboard.ajouterCaloriesConsommees(0); // Pour recalculer les calories restantes
                
                return dashboardRepository.save(nouveauDashboard);
            } else {
                throw new RuntimeException("Utilisateur non trouvé");
            }
        }
    }
    
    public DashboardQuotidien mettreAJourCaloriesApresConsommation(String userId, String recipeId) {
        log.info("Mise à jour des calories pour userId: {} et recipeId: {}", userId, recipeId);
        DashboardQuotidien dashboard = getDashboardQuotidien(userId);
        
        Optional<Recipe> recipeOpt = recipeRepository.findById(recipeId);
        if (recipeOpt.isPresent()) {
            Recipe recipe = recipeOpt.get();
            log.info("Avant ajout - Calories consommées: {}, Calories recette: {}", 
                    dashboard.getCaloriesConsommees(), recipe.getCalories());
            dashboard.ajouterCaloriesConsommees(recipe.getCalories());
            log.info("Après ajout - Calories consommées: {}", dashboard.getCaloriesConsommees());
            return dashboardRepository.save(dashboard);
        } else {
            throw new RuntimeException("Recette non trouvée");
        }
    }
    
    // Mettre à jour l'objectif de calories pour un utilisateur
    public DashboardQuotidien mettreAJourObjectifCalories(String userId, int nouvelObjectif) {
        DashboardQuotidien dashboard = getDashboardQuotidien(userId);
        
        // Mettre à jour l'objectif de calories pour l'utilisateur
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setCalorieGoal(nouvelObjectif);
            userRepository.save(user);
        }
        
        // Mettre à jour le dashboard
        dashboard.setCaloriesNecessaires(nouvelObjectif);
        return dashboardRepository.save(dashboard);
    }
    
    // Réinitialiser le dashboard pour une nouvelle journée
    public DashboardQuotidien reinitialiserDashboard(String userId) {
        DashboardQuotidien dashboard = getDashboardQuotidien(userId);
        dashboard.reinitialiserPourNouvelleJournee();
        return dashboardRepository.save(dashboard);
    }
}