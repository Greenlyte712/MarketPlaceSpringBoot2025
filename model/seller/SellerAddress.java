package com.greenlyte712.model.seller;

import jakarta.persistence.Embeddable;

@Embeddable

public class SellerAddress {
	
	private String street;
    private String city;
    private String state;
    private String zipcode;

    // Constructors, getters, and setters

    public SellerAddress() {
        // Default constructor
    }

    public SellerAddress(String street, String city, String state, String zipcode) {
        this.street = street;
        this.city = city;
        this.state = state;
        this.zipcode = zipcode;
    }

    // Getters and Setters

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getZipcode() {
        return zipcode;
    }

    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }


}
