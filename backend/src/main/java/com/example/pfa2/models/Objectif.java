package com.example.pfa2.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;

@Document(collection = "objectifs")
@Data
@AllArgsConstructor
public class Objectif {
    
    @Id
    private String idObj;
    private String typeObj; // "PERTE_POIDS", "MAINTIEN_POIDS", "PRISE_POIDS"
    private double poidsCible;
    private int caloriesTotal;
    private LocalDate dateDebut;
    private LocalDate dateFin;
    private String userId;
    
    public Objectif() {
        this.dateDebut = LocalDate.now();
    }
    
    public Objectif(String typeObj, double poidsCible, int caloriesTotal, LocalDate dateFin, String userId) {
        this.typeObj = typeObj;
        this.poidsCible = poidsCible;
        this.caloriesTotal = caloriesTotal;
        this.dateDebut = LocalDate.now();
        this.dateFin = dateFin;
        this.userId = userId;
    }
    
    // Getters and Setters
    public String getIdObj() {
        return idObj;
    }
    
    public void setIdObj(String idObj) {
        this.idObj = idObj;
    }
    
    public String getTypeObj() {
        return typeObj;
    }
    
    public void setTypeObj(String typeObj) {
        this.typeObj = typeObj;
    }
    
    public double getPoidsCible() {
        return poidsCible;
    }
    
    public void setPoidsCible(double poidsCible) {
        this.poidsCible = poidsCible;
    }
    
    public int getCaloriesTotal() {
        return caloriesTotal;
    }
    
    public void setCaloriesTotal(int caloriesTotal) {
        this.caloriesTotal = caloriesTotal;
    }
    
    public LocalDate getDateDebut() {
        return dateDebut;
    }
    
    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }
    
    public LocalDate getDateFin() {
        return dateFin;
    }
    
    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }
    
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
}