package com.greenlyte712.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.greenlyte712.model.review.Review;
import com.greenlyte712.model.seller.Seller;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
	
	List<Review> findBySeller(Seller seller);

	List<Review> findBySeller(Optional<Seller> seller);

}
