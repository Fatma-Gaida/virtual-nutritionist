package com.example.pfa2.models;
import lombok.*;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Document(collection = "users")
@Data
@AllArgsConstructor
public class User {
    @Id
    private ObjectId idU;
    private String nom;
    private String email;
    private String motDePasse;
    private LocalDate dob;
    private String sexe;
    private double taille;
    private double poids;
    private List<String> allergies;
    private List<String> maladies;
    private String etatActivite;
    private String dashBoardQuotidienId;
    private List<String> notificationIds = new ArrayList<>();
    private List<String> objectifIds = new ArrayList<>();
    private List<String> platFavoriIds = new ArrayList<>();


    public User() {
    }

    // Getters and Setters
    public ObjectId getIdU() {
        return idU;
    }

    public void setIdU(ObjectId idu) {
        this.idU = idu;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public String getSexe() {
        return sexe;
    }

    public void setSexe(String sexe) {
        this.sexe = sexe;
    }

    public Double getTaille() {
        return taille;
    }

    public void setTaille(Double taille) {
        this.taille = taille;
    }

    public Double getPoids() {
        return poids;
    }

    public void setPoids(double poids) {
        this.poids = poids;
    }

    public List<String> getAllergies() {
        return allergies;
    }

    public void setAllergies(List<String> allergies) {
        this.allergies = allergies;
    }

    public List<String> getMaladies() {
        return maladies;
    }

    public void setMaladies(List<String> maladies) {
        this.maladies = maladies;
    }

    public String getEtatActivite() {
        return etatActivite;
    }

    public void setEtatActivite(String etatActivite) {
        this.etatActivite = etatActivite;
    }

    public String getDashBoardQuotidienId() {
        return dashBoardQuotidienId;
    }

    public void setDashBoardQuotidienId(String dashBoardQuotidienId) {
        this.dashBoardQuotidienId = dashBoardQuotidienId;
    }

    public List<String> getNotificationIds() {
        return notificationIds;
    }

    public void setNotificationIds(List<String> notificationIds) {
        this.notificationIds = notificationIds;
    }

    public List<String> getObjectifIds() {
        return objectifIds;
    }

    public void setObjectifIds(List<String> objectifIds) {
        this.objectifIds = objectifIds;
    }

    public List<String> getPlatFavoriIds() {
        return platFavoriIds;
    }

    public void setPlatFavoriIds(List<String> platFavoriIds) {
        this.platFavoriIds = platFavoriIds;
    }


}
