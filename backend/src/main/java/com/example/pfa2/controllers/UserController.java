package com.example.pfa2.controllers;

import com.example.pfa2.models.User;
import com.example.pfa2.repository.UserRepository;
import com.example.pfa2.services.UserService;

import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/users")

public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository; // Inject the repository directly for testing
/* 
    @GetMapping("/test")
    public String testEndpoint() {
        return "API is accessible!";
    }
*/
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }
    @PostMapping("/register")
    public ResponseEntity<?> creerCompte(@RequestBody User user) {
        try {
            User createdUser = userService.creerCompte(user);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdUser);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Une erreur est survenue lors de la création du compte");
        }
    }

    @PutMapping("/{userId}/details")
    public ResponseEntity<User> updateUserDetails(
            @PathVariable String userId,
            @RequestParam(required = false) Double poids,
            @RequestParam(required = false) Double taille,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dob,
            @RequestParam(required = false) String sexe,
            @RequestParam(required = false) List<String> allergies,
            @RequestParam(required = false) List<String> maladies,
            @RequestParam(required = false) String etatActivite) {

        try {
            User updatedUser = userService.updateUserDetails(
                    userId,
                    poids != null ? poids : 0,
                    taille != null ? taille : 0,
                    dob,
                    sexe,
                    allergies,
                    maladies,
                    etatActivite
            );
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    // Get user by ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable ObjectId  id) {
        try {
            Optional<User> user = userService.getUserById(id);

            if (user.isPresent()) {
                return ResponseEntity.ok(user.get()); // HTTP 200 + user data
            } else {
                return ResponseEntity.notFound().build(); // HTTP 404
            }

        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Invalid ID format"); // HTTP 400
        }
    }



//    @GetMapping("/test-find-by-email")
//    public ResponseEntity<?> testFindByEmail(@RequestParam String email) {
//        User user = userRepository.findByEmail(email.trim());
//        return user.isPresent()
//                ? ResponseEntity.ok(user.get())
//                : ResponseEntity.notFound().build();
//    }

//    @Autowired
//    @GetMapping("/{id}/tdee")
//    public ResponseEntity<?> getTDEE(@PathVariable("id") String id) {
//        Optional<User> userOptional = userRepository.findById(new ObjectId(id));
//        if (userOptional.isEmpty()) {
//            Map<String, Object> error = new HashMap<>();
//            error.put("message", "Utilisateur avec l'ID " + id + " non trouvé.");
//            error.put("status", 404);
//            return ResponseEntity.status(404).body(error);
//        }
//        double tdee = userService.calculateTDEE(userOptional.get());
//        return ResponseEntity.ok(tdee);
//    }
}