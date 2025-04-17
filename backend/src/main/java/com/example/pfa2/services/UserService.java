package com.example.pfa2.services;
import com.example.pfa2.models.User;
import com.example.pfa2.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

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
}
