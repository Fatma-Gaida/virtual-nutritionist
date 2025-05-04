package com.example.pfa2.repository;

import com.example.pfa2.models.Objectif;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface ObjectifRepository extends MongoRepository<Objectif, String> {
    List<Objectif> findByUserId(String userId);
}