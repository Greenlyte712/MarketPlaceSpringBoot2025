package com.greenlyte712.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.greenlyte712.model.buyer.Buyer;
import com.greenlyte712.security.UserInfo;

public interface BuyerRepository extends JpaRepository<Buyer, Long> {

	Optional<Buyer> findByUserInfo(UserInfo userInfo);

}
