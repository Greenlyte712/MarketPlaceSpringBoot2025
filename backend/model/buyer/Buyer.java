package com.greenlyte712.model.buyer;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.greenlyte712.security.UserInfo;
import jakarta.persistence.*;

@Entity
@JsonIgnoreProperties({"phoneNumber", "email", "zipCode", "userInfo"})
public class Buyer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String phoneNumber;
    private String email;
    private String zipCode;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "user_info_id", referencedColumnName = "id")
    @JsonIgnoreProperties("buyer")
    private UserInfo userInfo;

    // Constructors, getters, and setters

    public Buyer() {
        // Default constructor
    }

    public Buyer(String name, String phoneNumber, String email, String zipCode) {
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.zipCode = zipCode;
    }

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getZipCode() {
        return zipCode;
    }

    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }

    public UserInfo getUserInfo() {
        return userInfo;
    }

    public void setUserInfo(UserInfo userInfo) {
        this.userInfo = userInfo;
    }

    @Override
    public String toString() {
        return "Buyer [id=" + id + ", name=" + name + ", phoneNumber=" + phoneNumber + ", email=" + email + ", zipCode=" + zipCode + "]";
    }
}