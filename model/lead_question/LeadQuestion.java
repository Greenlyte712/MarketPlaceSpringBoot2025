package com.greenlyte712.model.lead_question;

import com.greenlyte712.model.seller.Seller;
import jakarta.persistence.*;

@Entity
public class LeadQuestion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String question;

    @ManyToOne
    private Seller seller;

    public LeadQuestion(String question, Seller seller) {
        this.question = question;
        this.seller = seller;
    }

    public LeadQuestion() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public Seller getSeller() {
        return seller;
    }

    public void setSeller(Seller seller) {
        this.seller = seller;
    }
}