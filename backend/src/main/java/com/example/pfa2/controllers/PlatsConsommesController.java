package com.example.pfa2.controllers;

import com.example.pfa2.dto.ConsumedPlateRequest;
import com.example.pfa2.models.PlatsConsommes;
import com.example.pfa2.services.PlatsConsommesService;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/users/{userId}/consumed-plates")
public class PlatsConsommesController {

    private final PlatsConsommesService platsConsommesService;

    @Autowired
    public PlatsConsommesController(PlatsConsommesService platsConsommesService) {
        this.platsConsommesService = platsConsommesService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public void addConsumedPlate(@PathVariable String userId,
            @RequestBody ConsumedPlateRequest request) {
        try {
            platsConsommesService.addConsumedPlate(userId, request.getRecipeId(), request.getMeal());
        } catch (RuntimeException e) {
            if (e.getMessage().startsWith("Recipe not found")) {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, e.getMessage());
            }
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Error adding consumed plate");
        }
    }



    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public List<PlatsConsommes> getConsumedPlates(@PathVariable String userId) {
        return platsConsommesService.getConsumedPlatesByUserId(userId);
    }


    @GetMapping("/today")
    @ResponseStatus(HttpStatus.OK)
    public List<PlatsConsommes> getConsumedPlatesToday(@PathVariable String userId) {
        LocalDateTime startOfDay = LocalDateTime.now().toLocalDate().atStartOfDay();
        LocalDateTime endOfDay = startOfDay.plusDays(1).minusSeconds(1);
        return platsConsommesService.getConsumedPlatesByDateRange(userId, startOfDay, endOfDay);
    }
}
