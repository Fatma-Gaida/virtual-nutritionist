package com.example.pfa2.repository;

import java.util.List;

import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.example.pfa2.models.PlatsFavoris;

@Repository
public interface PlatsFavorisRepository extends MongoRepository<PlatsFavoris, String> {
    List<PlatsFavoris> findByUserId(ObjectId userId);
    boolean existsByUserIdAndId(ObjectId userId, String recipeId);
}
