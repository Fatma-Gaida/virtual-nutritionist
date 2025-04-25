package com.example.pfa2.controllers;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api") // Base path for all endpoints in this controller
@CrossOrigin(origins = "*")
public class ApiController {

    @GetMapping("/") // Handles GET requests to /api/
    public String apiRoot() {
        return "API is running!";
    }
}