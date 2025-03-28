package com.greenlyte712.dto;

import org.springframework.stereotype.Component;


public class ReviewDTO {

    private String companyName;

    private int rating;

    private String comment;

    public ReviewDTO() {
    }

    public ReviewDTO(String companyName, int rating, String comment) {
        this.companyName = companyName;
        this.rating = rating;
        this.comment = comment;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
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

    @Override
    public String toString() {
        return "ReviewDTO{" + "companyName='" + companyName + '\'' + ", rating=" + rating + ", comment='" + comment + '\'' + '}';
    }
}