package com.example.pfa2.controllers;

import com.example.pfa2.models.Objectif;
import com.example.pfa2.services.ObjectifService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/objectifs")
public class ObjectifController {

    @Autowired
    private ObjectifService objectifService;
    
    @PostMapping
    public ResponseEntity<?> creerObjectif(@RequestBody Objectif objectif) {
        try {
            Objectif newObjectif = objectifService.creerObjectif(objectif);
            return ResponseEntity.status(HttpStatus.CREATED).body(newObjectif);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Erreur lors de la création de l'objectif: " + e.getMessage()));
        }
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<?> modifierObjectif(@PathVariable("id") String idObj, @RequestBody Objectif objectif) {
        try {
            Objectif updatedObjectif = objectifService.modifierObjectif(idObj, objectif);
            return ResponseEntity.ok(updatedObjectif);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Erreur lors de la modification de l'objectif: " + e.getMessage()));
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> supprimerObjectif(@PathVariable("id") String idObj) {
        try {
            objectifService.supprimerObjectif(idObj);
            return ResponseEntity.ok(Map.of("message", "Objectif supprimé avec succès"));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Erreur lors de la suppression de l'objectif: " + e.getMessage()));
        }
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<?> consulterDetailsObjectif(@PathVariable("id") String idObj) {
        try {
            Optional<Objectif> objectif = objectifService.consulterDetailsObjectif(idObj);
            if (objectif.isPresent()) {
                return ResponseEntity.ok(objectif.get());
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("error", "Objectif non trouvé avec l'ID: " + idObj));
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Erreur lors de la consultation de l'objectif: " + e.getMessage()));
        }
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<?> getObjectifsByUserId(@PathVariable("userId") String userId) {
        try {
            List<Objectif> objectifs = objectifService.getObjectifsByUserId(userId);
            return ResponseEntity.ok(objectifs);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Erreur lors de la récupération des objectifs: " + e.getMessage()));
        }
    }
}