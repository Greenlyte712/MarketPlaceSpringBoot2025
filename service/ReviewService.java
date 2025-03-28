package com.greenlyte712.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.greenlyte712.model.review.Review;
import com.greenlyte712.model.seller.Seller;
import com.greenlyte712.repository.ReviewRepository;

@Service
public class ReviewService {

    private final ReviewRepository reviewRepository;

    
    public ReviewService(ReviewRepository reviewRepository) {
        this.reviewRepository = reviewRepository;
    }

    public Review createReview(Review review) {
        return reviewRepository.save(review);
    }

    public Optional<Review> getReviewById(Long id) {
        return reviewRepository.findById(id);
    }
    
    public List<Review> getAllReviewsBySeller(Optional<Seller> seller) {
        return reviewRepository.findBySeller(seller);
    }

    public List<Review> getAllReviews() {
        return reviewRepository.findAll();
    }

    public void deleteReview(Long id) {
        reviewRepository.deleteById(id);
    }

	
}


