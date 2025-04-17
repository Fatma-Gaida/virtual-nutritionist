package com.example.pfa2.controllers;

import com.example.pfa2.models.User;
import com.example.pfa2.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/creer-compte")
    public User creerCompte(@RequestBody User user) {
        return userService.creerCompte(user);
    }
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
}