package com.example.pfa2.services;
import com.example.pfa2.models.Recipe;
import com.example.pfa2.models.User;
import com.example.pfa2.repository.RecipeRepository;
import com.example.pfa2.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RecipeRepository recipeRepository;

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

    public User addRecipeToFavorites(String id, String recipeId) {
        Optional<User> optionalUser = userRepository.findById(id);
        if (optionalUser.isEmpty()) {
            throw new RuntimeException("Utilisateur introuvable avec l'ID : " + id);
        }
    
        User user = optionalUser.get();
    
        if (!user.getPlatFavoriIds().contains(recipeId)) {
            user.getPlatFavoriIds().add(recipeId);
            return userRepository.save(user);
        } else {
            throw new RuntimeException("Recette déjà dans les favoris");
        }
    }
    

    public List<Recipe> getFavoriteRecipes(String id) {
        Optional<User> optionalUser = userRepository.findById(id);
        if (optionalUser.isEmpty()) throw new RuntimeException("Utilisateur introuvable");

        List<String> favIds = optionalUser.get().getPlatFavoriIds();
        return recipeRepository.findAllById(favIds);
    }

    public User removeRecipeFromFavorites(String userId, String recipeId) {
        Optional<User> optionalUser = userRepository.findById(userId);
        if (optionalUser.isEmpty()) throw new RuntimeException("Utilisateur introuvable");
    
        User user = optionalUser.get();
        if (user.getPlatFavoriIds().contains(recipeId)) {
            user.getPlatFavoriIds().remove(recipeId);
            return userRepository.save(user);
        } else {
            throw new RuntimeException("Recette non trouvée dans les favoris");
        }
    }
    
}

