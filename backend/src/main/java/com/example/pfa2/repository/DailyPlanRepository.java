
package com.example.pfa2.repository;

import java.time.LocalDate;
import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.example.pfa2.models.DailyPlan;

@Repository
public interface DailyPlanRepository extends MongoRepository<DailyPlan, String> {

    /**
     * Find a daily plan by user ID and date
     */
    Optional<DailyPlan> findByUserIdAndDate(String userId, LocalDate date);

    /**
     * Find all daily plans for a user
     */
    Iterable<DailyPlan> findByUserId(String userId);

    /**
     * Find all daily plans for a user between two dates
     */
    Iterable<DailyPlan> findByUserIdAndDateBetween(String userId, LocalDate startDate, LocalDate endDate);
}