package com.example.pfa2.controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.pfa2.models.User;
import com.example.pfa2.repository.UserRepository;

@RestController
@RequestMapping("/api/test")
public class UserTestController {

    @Autowired
    private UserRepository userRepository;

    /**
     * Get all users - for testing purposes
     */
    @GetMapping("/users")
    public ResponseEntity<?> getAllUsers() {
        try {
            List<User> users = userRepository.findAll();

            Map<String, Object> response = new HashMap<>();
            response.put("totalUsers", users.size());
            response.put("users", users);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Error fetching users: " + e.getMessage());
        }
    }

    /**
     * Get a specific user by ID - for testing purposes
     */
    @GetMapping("/users/{userId}")
    public ResponseEntity<?> getUser(@PathVariable String userId) {
        try {
            Optional<User> user = userRepository.findById(userId);

            if (user.isPresent()) {
                return ResponseEntity.ok(user.get());
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Error fetching user: " + e.getMessage());
        }
    }
}