package com.greenlyte712.controller;

import com.greenlyte712.dto.ReviewDTO;
import com.greenlyte712.model.buyer.Buyer;
import com.greenlyte712.model.review.Review;
import com.greenlyte712.model.seller.Seller;
import com.greenlyte712.security.UserInfo;
import com.greenlyte712.security.UserInfoService;
import com.greenlyte712.service.BuyerService;
import com.greenlyte712.service.ReviewService;
import com.greenlyte712.service.SellerService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/reviews")
public class ReviewsController {

    private final ReviewService reviewService;
    private final SellerService sellerService;
    private final BuyerService buyerService;
    private final UserInfoService userInfoService;

    public ReviewsController(ReviewService reviewService, SellerService sellerService, BuyerService buyerService, UserInfoService userInfoService) {
        this.reviewService = reviewService;
        this.sellerService = sellerService;
        this.buyerService = buyerService;
        this.userInfoService = userInfoService;
    }

    @PostMapping("/write_seller_review")
    public ResponseEntity<Review> createReview(@RequestBody ReviewDTO reviewDTO) {

        Review review = new Review();

        Optional<Seller> seller = sellerService.getSellerByCompanyName(reviewDTO.getCompanyName());

        if (seller.isPresent()) {
            // If seller is found, set the seller for the review
            review.setSeller(seller.orElse(null));

            // Retrieve the authenticated user's username
            String username = null;
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            if (principal instanceof UserDetails) {
                username = ((UserDetails) principal).getUsername();
            } else {
                username = principal.toString();
            }

            // Find UserInfo based on username
            Optional<UserInfo> userInfoOpt = userInfoService.findByUsername(username);
            if (userInfoOpt.isPresent()) {
                UserInfo userInfo = userInfoOpt.get();

                // Retrieve Buyer by UserInfo
                Optional<Buyer> reviewer = buyerService.findByUserInfo(userInfo);
                if (reviewer.isPresent()) {
                    review.setReviewer(Optional.of(reviewer.get()));
                    review.setSellerCompanyName(reviewDTO.getCompanyName());
                    review.setRating(reviewDTO.getRating());
                    review.setComment(reviewDTO.getComment());
                    // Save and return the review
                    Review createdReview = reviewService.createReview(review);
                    return new ResponseEntity<>(createdReview, HttpStatus.CREATED);
                }
            }

            // Return an error if the buyer could not be found
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        } else {
            // Return an error if the seller is not found
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/seller/{sellerId}")
    public ResponseEntity<List<Review>> getReviewsBySeller(@PathVariable Long sellerId) {
        // Assuming you have a method to retrieve Seller by ID in SellerService
        // You can adjust this based on your actual implementation
        Optional<Seller> seller = sellerService.getSellerById(sellerId);
        if (seller == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        List<Review> reviews = reviewService.getAllReviewsBySeller(seller);
        return new ResponseEntity<>(reviews, HttpStatus.OK);
    }

    @GetMapping("/get_all_reviews")
    public ResponseEntity<List<Review>> getAllReviews() {

        List<Review> reviews = reviewService.getAllReviews();
        return new ResponseEntity<>(reviews, HttpStatus.OK);
    }
}