package com.greenlyte712.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.greenlyte712.model.buyer.Buyer;
import com.greenlyte712.repository.BuyerRepository;
import com.greenlyte712.security.UserInfo;

@Service
public class BuyerService {
	
	private final BuyerRepository buyerRepository;

    
    public BuyerService(BuyerRepository buyerRepository) {
        this.buyerRepository = buyerRepository;
    }

    public List<Buyer> getAllBuyers() {
        return buyerRepository.findAll();
    }

    public Optional<Buyer> getBuyerById(Long id) {
        return buyerRepository.findById(id);
    }

    public Buyer saveBuyer(Buyer buyer) {
        return buyerRepository.save(buyer);
    }

    public void deleteBuyer(Long id) {
        buyerRepository.deleteById(id);
    }

	public Optional<Buyer> findByUserInfo(UserInfo userInfo) {
		// TODO Auto-generated method stub
		return buyerRepository.findByUserInfo(userInfo);
	}

}
