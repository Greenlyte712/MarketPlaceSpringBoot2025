package com.greenlyte712.repository;

import com.greenlyte712.security.UserInfo;
import org.springframework.data.jpa.repository.JpaRepository;

import com.greenlyte712.model.seller.Seller;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface SellerRepository extends JpaRepository<Seller, Long>{

	Optional<Seller> findByCompanyName(String name);

    Optional<Seller> findByUserInfo(UserInfo userInfo);

    @Query("SELECT s FROM Seller s WHERE :zipCode MEMBER OF s.servicedZipCodes AND :tag MEMBER OF s.metaTags")
    Optional<List<Seller>> findSellersByZipCodeAndTag(@Param("zipCode") String zipCode, @Param("tag") String tag);



}