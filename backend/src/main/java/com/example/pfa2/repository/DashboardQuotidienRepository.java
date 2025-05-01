package com.example.pfa2.repository;

import com.example.pfa2.models.DashboardQuotidien;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface DashboardQuotidienRepository extends MongoRepository<DashboardQuotidien, String> {
    
    // Trouver le dashboard d'un utilisateur à une date spécifique
    Optional<DashboardQuotidien> findByUserIdAndDate(String userId, LocalDate date);
    
    // Trouver le dashboard le plus récent d'un utilisateur
    Optional<DashboardQuotidien> findFirstByUserIdOrderByDateDesc(String userId);
    
    // Vérifier si un dashboard existe pour un utilisateur à une date spécifique
    boolean existsByUserIdAndDate(String userId, LocalDate date);
}