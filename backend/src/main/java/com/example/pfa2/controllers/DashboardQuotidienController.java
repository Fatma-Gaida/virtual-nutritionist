package com.example.pfa2.controllers;

import com.example.pfa2.models.DashboardQuotidien;
import com.example.pfa2.models.PlatsConsommes;
import com.example.pfa2.services.DashboardQuotidienService;
import com.example.pfa2.services.RecipeService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/dashboard")
@CrossOrigin(origins = "*")
public class DashboardQuotidienController {

    @Autowired
    private DashboardQuotidienService dashboardService;
    
    @Autowired
    private RecipeService recipeService;
    
    // Récupérer le dashboard quotidien d'un utilisateur
    @GetMapping("/{userId}")
    public ResponseEntity<DashboardQuotidien> getDashboardQuotidien(@PathVariable String userId) {
        try {
            DashboardQuotidien dashboard = dashboardService.getDashboardQuotidien(userId);
            return new ResponseEntity<>(dashboard, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // Mettre à jour l'objectif de calories pour un utilisateur
    @PutMapping("/{userId}/objectif")
    public ResponseEntity<DashboardQuotidien> updateCalorieGoal(
            @PathVariable String userId,
            @RequestParam int caloriesObjectif) {
        try {
            DashboardQuotidien dashboard = dashboardService.mettreAJourObjectifCalories(userId, caloriesObjectif);
            return new ResponseEntity<>(dashboard, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    // Mettre à jour le dashboard après consommation d'un plat
    @PostMapping("/consumed/{userId}/{recipeId}")
    public ResponseEntity<DashboardQuotidien> addConsumedRecipe(
            @PathVariable String userId,
            @PathVariable String recipeId,
            @RequestParam String repas) {
        try {
            // Ajouter le plat comme consommé
            PlatsConsommes platsConsommes = recipeService.addConsumedRecipe(userId, recipeId, repas);
            if (platsConsommes == null) {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
            }

            // Mettre à jour le dashboard
            DashboardQuotidien dashboard = dashboardService.mettreAJourCaloriesApresConsommation(userId, recipeId);
            return new ResponseEntity<>(dashboard, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    
    // Réinitialiser le dashboard pour une nouvelle journée
    @PostMapping("/{userId}/reinitialiser")
    public ResponseEntity<DashboardQuotidien> reinitialiserDashboard(@PathVariable String userId) {
        try {
            DashboardQuotidien dashboard = dashboardService.reinitialiserDashboard(userId);
            return new ResponseEntity<>(dashboard, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}