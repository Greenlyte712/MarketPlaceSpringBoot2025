package com.greenlyte712.model.seller;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.greenlyte712.model.lead_question.LeadQuestion;
import com.greenlyte712.security.UserInfo;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@JsonIgnoreProperties({"userInfo", "leadQuestions"})
public class Seller {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String companyName;
    private String phoneNumber;

    @Embedded
    private SellerAddress sellerAddress;

    private String email;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "user_info_id", referencedColumnName = "id")
    @JsonIgnoreProperties("seller")
    private UserInfo userInfo;

    @OneToMany(mappedBy = "seller", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LeadQuestion> leadQuestions = new ArrayList<>();

    private String companyDescription; // New field for company description

    private String webAddress; // New field for website link

    @ElementCollection
    private List<String> metaTags = new ArrayList<>(); // New field for meta tags

    @ElementCollection
    private List<String> servicedZipCodes = new ArrayList<>();

    public Seller() {
        // Default constructor
    }

    public Seller(String companyName, String phoneNumber, SellerAddress sellerAddress, String email, String companyDescription, String webAddress, List<String> metaTags) {
        this.companyName = companyName;
        this.phoneNumber = phoneNumber;
        this.sellerAddress = sellerAddress;
        this.email = email;
        this.companyDescription = companyDescription;
        this.webAddress = webAddress;
        this.metaTags = metaTags;
    }

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public SellerAddress getSellerAddress() {
        return sellerAddress;
    }

    public void setSellerAddress(SellerAddress sellerAddress) {
        this.sellerAddress = sellerAddress;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public UserInfo getUserInfo() {
        return userInfo;
    }

    public void setUserInfo(UserInfo userInfo) {
        this.userInfo = userInfo;
    }

    public List<LeadQuestion> getLeadQuestions() {
        return leadQuestions;
    }

    public void setLeadQuestions(List<LeadQuestion> leadQuestions) {
        this.leadQuestions = leadQuestions;
    }

    public String getCompanyDescription() {
        return companyDescription;
    }

    public void setCompanyDescription(String companyDescription) {
        this.companyDescription = companyDescription;
    }

    public String getWebAddress() {
        return webAddress;
    }

    public void setWebAddress(String webAddress) {
        this.webAddress = webAddress;
    }

    public List<String> getMetaTags() {
        return metaTags;
    }

    public void setMetaTags(List<String> metaTags) {
        this.metaTags = metaTags;
    }

    public List<String> getServicedZipCodes() {
        return servicedZipCodes;
    }

    public void setServicedZipCodes(List<String> servicedZipCodes) {
        this.servicedZipCodes = servicedZipCodes;
    }

    @Override
    public String toString() {
        return "Seller [id=" + id + ", companyName=" + companyName + ", phoneNumber=" + phoneNumber + ", sellerAddress=" + sellerAddress + "]";
    }
}