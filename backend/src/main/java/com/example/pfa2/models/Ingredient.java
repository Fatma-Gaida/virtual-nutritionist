package com.example.pfa2.models;

public class Ingredient {
    private String name;
    private int quantity;
    private String unit; // g, ml
    private String imageUrlIng;
    // Constructeurs
    public Ingredient() {}
    
    public Ingredient(String name, int quantity, String unit, String imageUrlIng) {
        this.name = name;
        this.quantity = quantity;
        this.unit = unit;
        this.imageUrlIng = imageUrlIng;
    }
    
    // Getters and Setters
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }

    public String getImageUrlIng() {
        return imageUrlIng;
    }

    public void setImageUrlIng(String imageUrlIng) {
        this.imageUrlIng = imageUrlIng;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public String getUnit() {
        return unit;
    }
    
    public void setUnit(String unit) {
        this.unit = unit;
    }
}
