package com.greenlyte712.model.review;

import java.time.LocalDateTime;
import java.util.Optional;

import com.greenlyte712.model.buyer.Buyer;
import com.greenlyte712.model.seller.Seller;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import org.springframework.stereotype.Component;

@Entity

public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String sellerCompanyName;

    @ManyToOne
    private Buyer reviewer;

    @ManyToOne
    private Seller seller;

    private int rating; // Rating out of 5

    private String comment; // Review comment

    private LocalDateTime createdAt;

    // Constructors, getters, and setters

    public Review() {
        this.createdAt = LocalDateTime.now();
    }

    public Review(Buyer reviewer,String sellerCompanyName , Seller seller, int rating, String comment) {
        this.reviewer = reviewer;
        this.sellerCompanyName = sellerCompanyName;
        this.seller = seller;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = LocalDateTime.now();
    }

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Optional<Buyer> getReviewer() {
        return Optional.ofNullable(reviewer);
    }

    public void setReviewer(Optional<Buyer> reviewer) {
        this.reviewer = reviewer.orElse(null);
    }



    public String getSellerCompanyName() {
		return sellerCompanyName;
	}

	public void setSellerCompanyName(String sellerCompanyName) {
		this.sellerCompanyName = sellerCompanyName;
	}

	public Seller getSeller() {
        return seller;
    }

    public void setSeller(Seller seller) {
        this.seller = seller;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

	@Override
	public String toString() {
		return "Review [id=" + id + ", sellerCompanyName=" + sellerCompanyName + ", reviewer=" + reviewer + ", seller="
				+ seller + ", rating=" + rating + ", comment=" + comment + ", createdAt=" + createdAt + "]";
	}


}