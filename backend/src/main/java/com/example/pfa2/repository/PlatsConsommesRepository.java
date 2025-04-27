package com.example.pfa2.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.example.pfa2.models.PlatsConsommes;

public interface PlatsConsommesRepository extends MongoRepository<PlatsConsommes, String> {
    List<PlatsConsommes> findByUserId(String userId);
    List<PlatsConsommes> findByUserIdAndDateConsommationBetween(
            String userId, LocalDateTime start, LocalDateTime end
    );
}
