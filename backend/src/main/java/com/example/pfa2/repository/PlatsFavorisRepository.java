package com.example.pfa2.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.example.pfa2.models.PlatsFavoris;

@Repository
public interface PlatsFavorisRepository extends MongoRepository<PlatsFavoris, String> {
    List<PlatsFavoris> findByUserId(String userId);
    boolean existsByUserIdAndId(String userId, String recipeId);
}
