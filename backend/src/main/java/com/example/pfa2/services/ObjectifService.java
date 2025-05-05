package com.example.pfa2.services;

import com.example.pfa2.models.Objectif;
import com.example.pfa2.models.User;
import com.example.pfa2.repository.ObjectifRepository;
import com.example.pfa2.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.ArrayList;

@Service
public class ObjectifService {

    @Autowired
    private ObjectifRepository objectifRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public Objectif creerObjectif(Objectif objectif) {
        // Validate required fields
        if (objectif.getTypeObj() == null || objectif.getUserId() == null || 
            objectif.getDateFin() == null) {
            throw new IllegalArgumentException("Tous les champs obligatoires doivent être fournis");
        }
        
        // Validate that user exists
        Optional<User> userOpt = userRepository.findById(objectif.getUserId());
        if (userOpt.isEmpty()) {
            throw new RuntimeException("Utilisateur non trouvé avec l'ID: " + objectif.getUserId());
        }
        
        // Validate objectif type
        if (!objectif.getTypeObj().equals("PERTE_POIDS") && 
            !objectif.getTypeObj().equals("MAINTIEN_POIDS") && 
            !objectif.getTypeObj().equals("PRISE_POIDS")) {
            throw new IllegalArgumentException("Type d'objectif non valide. Doit être PERTE_POIDS, MAINTIEN_POIDS ou PRISE_POIDS");
        }
        
        // Save the objective
        Objectif savedObjectif = objectifRepository.save(objectif);
        
        // Update user's objectifIds list
        User user = userOpt.get();
        if (user.getObjectifIds() == null) {
            user.setObjectifIds(new ArrayList<>());
        }
        user.getObjectifIds().add(savedObjectif.getIdObj());
        userRepository.save(user);
        
        return savedObjectif;
    }
    
    public Objectif modifierObjectif(String idObj, Objectif objectifDetails) {
        // Check if objective exists
        Optional<Objectif> objectifOpt = objectifRepository.findById(idObj);
        if (objectifOpt.isEmpty()) {
            throw new RuntimeException("Objectif non trouvé avec l'ID: " + idObj);
        }
        
        Objectif objectif = objectifOpt.get();
        
        // Update fields if they are not null
        if (objectifDetails.getTypeObj() != null) {
            // Validate objectif type
            if (!objectifDetails.getTypeObj().equals("PERTE_POIDS") && 
                !objectifDetails.getTypeObj().equals("MAINTIEN_POIDS") && 
                !objectifDetails.getTypeObj().equals("PRISE_POIDS")) {
                throw new IllegalArgumentException("Type d'objectif non valide. Doit être PERTE_POIDS, MAINTIEN_POIDS ou PRISE_POIDS");
            }
            objectif.setTypeObj(objectifDetails.getTypeObj());
        }
        
        if (objectifDetails.getPoidsCible() > 0) {
            objectif.setPoidsCible(objectifDetails.getPoidsCible());
        }
        
        if (objectifDetails.getCaloriesTotal() > 0) {
            objectif.setCaloriesTotal(objectifDetails.getCaloriesTotal());
        }
        
        if (objectifDetails.getDateFin() != null) {
            objectif.setDateFin(objectifDetails.getDateFin());
        }
        
        return objectifRepository.save(objectif);
    }
    
    public void supprimerObjectif(String idObj) {
        Optional<Objectif> objectifOpt = objectifRepository.findById(idObj);
        if (objectifOpt.isEmpty()) {
            throw new RuntimeException("Objectif non trouvé avec l'ID: " + idObj);
        }
        
        Objectif objectif = objectifOpt.get();
        
        // Remove reference from user
        Optional<User> userOpt = userRepository.findById(objectif.getUserId());
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.getObjectifIds().remove(idObj);
            userRepository.save(user);
        }
        
        // Delete the objective
        objectifRepository.deleteById(idObj);
    }
    
    public Optional<Objectif> consulterDetailsObjectif(String idObj) {
        return objectifRepository.findById(idObj);
    }
    
    public List<Objectif> getObjectifsByUserId(String userId) {
        return objectifRepository.findByUserId(userId);
    }
}