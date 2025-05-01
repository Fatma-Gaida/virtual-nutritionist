package com.example.pfa2.models;

import lombok.Data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;

@Document(collection = "DashboardQuotidien")
@Data
public class DashboardQuotidien {
    @Id
    private String id;
    private String userId;
    private LocalDate date;
    private int caloriesNecessaires;
    private int caloriesConsommees;
    private int caloriesRestantes;
    
    public DashboardQuotidien() {
        this.date = LocalDate.now();
    }
    
    public DashboardQuotidien(String userId, int caloriesNecessaires) {
        this.userId = userId;
        this.date = LocalDate.now();
        this.caloriesNecessaires = caloriesNecessaires;
        this.caloriesConsommees = 0;
        this.caloriesRestantes = caloriesNecessaires;
    }
    
    // Méthode pour mettre à jour les calories après consommation d'un plat
    public void ajouterCaloriesConsommees(int calories) {
        int newCaloriesConsommees = this.caloriesConsommees + calories;
        
        if (newCaloriesConsommees >= this.caloriesNecessaires) {
            this.caloriesConsommees = this.caloriesNecessaires;
            this.caloriesRestantes = 0;
        } else {
            this.caloriesConsommees = newCaloriesConsommees;
            this.caloriesRestantes = this.caloriesNecessaires - this.caloriesConsommees;
        }
    }
    
    // Méthode pour réinitialiser le dashboard pour une nouvelle journée
    public void reinitialiserPourNouvelleJournee() {
        this.date = LocalDate.now();
        this.caloriesConsommees = 0;
        this.caloriesRestantes = this.caloriesNecessaires;
    }
    
    // Getters et Setters
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    public LocalDate getDate() {
        return date;
    }
    
    public void setDate(LocalDate date) {
        this.date = date;
    }
    
    public int getCaloriesNecessaires() {
        return caloriesNecessaires;
    }
    
    public void setCaloriesNecessaires(int caloriesNecessaires) {
        this.caloriesNecessaires = caloriesNecessaires;
        // Recalculer les calories restantes quand on change les calories nécessaires
        this.caloriesRestantes = Math.max(0, this.caloriesNecessaires - this.caloriesConsommees);
    }
    
    public int getCaloriesConsommees() {
        return caloriesConsommees;
    }
    
    public void setCaloriesConsommees(int caloriesConsommees) {
        if (caloriesConsommees >= this.caloriesNecessaires) {
            this.caloriesConsommees = this.caloriesNecessaires;
            this.caloriesRestantes = 0;
        } else {
            this.caloriesConsommees = caloriesConsommees;
            this.caloriesRestantes = this.caloriesNecessaires - this.caloriesConsommees;
        }
    }
    
    public int getCaloriesRestantes() {
        return caloriesRestantes;
    }
    
    public void setCaloriesRestantes(int caloriesRestantes) {
        this.caloriesRestantes = caloriesRestantes;
    }
    
    // Vérifier si le dashboard est pour la journée actuelle
    public boolean estCourant() {
        return date.equals(LocalDate.now());
    }
    
    // Pourcentage de calories consommées par rapport aux calories nécessaires
    public double getPourcentageCaloriesConsommees() {
        if (caloriesNecessaires == 0) return 0;
        // Si on a atteint ou dépassé l'objectif, retourner 100%
        if (caloriesConsommees >= caloriesNecessaires) return 100.0;
        return (double) caloriesConsommees / caloriesNecessaires * 100;
    }
}