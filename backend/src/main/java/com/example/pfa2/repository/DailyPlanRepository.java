package com.example.pfa2.repository;

import com.example.pfa2.models.DailyPlan;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface DailyPlanRepository extends MongoRepository<DailyPlan, String> {
    Optional<DailyPlan> findByUserIdAndDate(String userId, LocalDate date);
    Optional<DailyPlan> findByUserId(String userId);
}