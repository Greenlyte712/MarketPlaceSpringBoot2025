package com.greenlyte712.service;

import com.greenlyte712.dto.LeadQuestionDTO;
import com.greenlyte712.model.lead_question.LeadQuestion;
import com.greenlyte712.model.seller.Seller;
import com.greenlyte712.repository.LeadQuestionRepository;
import com.greenlyte712.repository.SellerRepository;
import com.greenlyte712.security.UserInfo;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SellerService {

    private final SellerRepository sellerRepository;
    private final LeadQuestionRepository leadQuestionRepository;

    public SellerService(SellerRepository sellerRepository, LeadQuestionRepository leadQuestionRepository) {
        this.sellerRepository = sellerRepository;
        this.leadQuestionRepository = leadQuestionRepository;
    }

    public List<Seller> getAllSellers() {
        return sellerRepository.findAll();
    }

    public Optional<Seller> getSellerById(Long id) {
        return sellerRepository.findById(id);
    }

    public Optional<Seller> getSellerByCompanyName(String name) {
        return sellerRepository.findByCompanyName(name);
    }

    public List<Seller> getSellersByZipCodeAndTag(String zipCode, String tag) {
        return sellerRepository.findSellersByZipCodeAndTag(zipCode, tag).orElseGet(List::of);
    }

    public Seller saveSeller(Seller seller) {
        return sellerRepository.save(seller);
    }

    public void deleteSeller(Long id) {
        sellerRepository.deleteById(id);
    }

    public Optional<Seller> findByUserInfo(UserInfo userInfo) {
        // TODO Auto-generated method stub
        return sellerRepository.findByUserInfo(userInfo);
    }

    public LeadQuestion createLeadQuestion(Long sellerId, LeadQuestionDTO leadQuestionDTO) {
        Seller seller = sellerRepository.findById(sellerId).orElseThrow(() -> new RuntimeException("Seller not found"));

        LeadQuestion leadQuestion = new LeadQuestion();
        leadQuestion.setQuestion(leadQuestionDTO.getQuestion());
        leadQuestion.setSeller(seller);

        return leadQuestionRepository.save(leadQuestion);
    }

    public void deleteLeadQuestion(Long leadQuestionId) {
        LeadQuestion leadQuestion = leadQuestionRepository.findById(leadQuestionId).orElseThrow(() -> new RuntimeException("LeadQuestion not found"));

        leadQuestionRepository.delete(leadQuestion);
    }

    public void updateCompanyDescription(Long sellerId, String companyDescription) {
        Seller seller = sellerRepository.findById(sellerId).orElseThrow(() -> new RuntimeException("Seller not found"));
        seller.setCompanyDescription(companyDescription);
        sellerRepository.save(seller);
    }

    public void updateCompanyWebAddress(Long sellerId, String companyWebAddress) {
        Seller seller = sellerRepository.findById(sellerId).orElseThrow(() -> new RuntimeException("Seller not found"));
        seller.setWebAddress(companyWebAddress);
        sellerRepository.save(seller);
    }

    public void updateMetaTags(Long sellerId, List<String> metaTags) {
        Seller seller = sellerRepository.findById(sellerId).orElseThrow(() -> new RuntimeException("Seller not found"));
        seller.setMetaTags(metaTags);
        sellerRepository.save(seller);
    }

    public void updateServicedZipCodes(Long sellerId, List<String> servicedZipcodes) {
        Seller seller = sellerRepository.findById(sellerId).orElseThrow(() -> new RuntimeException("Seller not found"));
        seller.setServicedZipCodes(servicedZipcodes);
        sellerRepository.save(seller);
    }

    public void updateCompanyName(Long sellerId, String companyName) {
        Seller seller = sellerRepository.findById(sellerId).orElseThrow(() -> new RuntimeException("Seller not found"));
        seller.setCompanyName(companyName);
        sellerRepository.save(seller);
    }

    public void updateEmail(Long sellerId, String email) {
        Seller seller = sellerRepository.findById(sellerId).orElseThrow(() -> new RuntimeException("Seller not found"));
        seller.setEmail(email);
        sellerRepository.save(seller);
    }

    public void updatePhoneNumber(Long sellerId, String phoneNumber) {
        Seller seller = sellerRepository.findById(sellerId).orElseThrow(() -> new RuntimeException("Seller not found"));
        seller.setPhoneNumber(phoneNumber);
        sellerRepository.save(seller);
    }

    public void updateStreetAddress(Long sellerId, String street) {
        Seller seller = sellerRepository.findById(sellerId).orElseThrow(() -> new RuntimeException("Seller not found"));
        seller.getSellerAddress().setStreet(street);
        sellerRepository.save(seller);
    }

    public void updateStateAddress(Long sellerId, String state) {
        Seller seller = sellerRepository.findById(sellerId).orElseThrow(() -> new RuntimeException("Seller not found"));
        seller.getSellerAddress().setState(state);
        sellerRepository.save(seller);
    }

    public void updateCityAddress(Long sellerId, String city) {
        Seller seller = sellerRepository.findById(sellerId).orElseThrow(() -> new RuntimeException("Seller not found"));
        seller.getSellerAddress().setCity(city);
        sellerRepository.save(seller);
    }
}