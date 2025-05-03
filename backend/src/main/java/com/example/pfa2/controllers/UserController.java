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
import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/users")

public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/creer-compte")
    public User creerCompte(@RequestBody User user) {
        return userService.creerCompte(user);
    }
    /* 
    // Get user by ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable String id) {
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
    */
    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable String id) {
        try {
            System.out.println("Controller received request for user ID: " + id);
            Optional<User> user = userService.getUserById(id);

            if (user.isPresent()) {
                return ResponseEntity.ok(user.get());
            } else {
                System.out.println("User not found with ID: " + id);
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("error", "User not found with ID: " + id));
            }

        } catch (Exception e) {
            System.out.println("Error fetching user: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Error fetching user: " + e.getMessage()));
        }
    }
    // Get all users
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }
    

}