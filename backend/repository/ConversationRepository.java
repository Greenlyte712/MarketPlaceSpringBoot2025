package com.greenlyte712.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.greenlyte712.model.conversation.Conversation;

public interface ConversationRepository extends JpaRepository<Conversation, Long> {

	List<Conversation> findBySellerId(Long sellerId);
    // Custom query methods can be defined here if needed

	@Query("SELECT c FROM Conversation c " +
			"LEFT JOIN FETCH c.messages m " +
			"WHERE c.seller.id = :sellerId " +
			"ORDER BY m.timestamp DESC")
	    List<Conversation> findBySellerIdWithMessages(@Param("sellerId") Long sellerId);

	@Query("SELECT c FROM Conversation c " +
			"LEFT JOIN FETCH c.messages m " +
			"WHERE c.buyer.id = :buyerId " +
			"ORDER BY m.timestamp DESC")
    List<Conversation> findByBuyerIdWithMessages(@Param("buyerId") Long buyerId);
}