package com.example.pfa2.services;

import com.example.pfa2.models.PlatsConsommes;
import com.example.pfa2.models.Recipe;
import com.example.pfa2.repository.PlatsConsommesRepository;
import com.example.pfa2.repository.RecipeRepository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PlatsConsommesService {

    private final PlatsConsommesRepository platsConsommesRepository;
    private final RecipeRepository recipeRepository;

    @Autowired
    public PlatsConsommesService(PlatsConsommesRepository platsConsommesRepository,
            RecipeRepository recipeRepository) {
        this.platsConsommesRepository = platsConsommesRepository;
        this.recipeRepository = recipeRepository;
    }



    
    public void addConsumedPlate(String userId, String recipeId, String meal) {
        // Fetch the Recipe by recipeId
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(() -> new RuntimeException("Recipe not found with ID: " + recipeId));

        // Create a new PlatsConsommes instance
        PlatsConsommes platsConsommes = new PlatsConsommes(recipe, userId, meal);

        // Save to the repository (MongoDB will generate a unique _id)
        platsConsommesRepository.save(platsConsommes);
    }

    public List<PlatsConsommes> getConsumedPlatesByUserId(String userId) {
        return platsConsommesRepository.findByUserId(userId);
    }

     public List<PlatsConsommes> getConsumedPlatesByDateRange(String userId, LocalDateTime start, LocalDateTime end) {
        return platsConsommesRepository.findByUserIdAndDateConsommationBetween(userId, start, end);
    }
}