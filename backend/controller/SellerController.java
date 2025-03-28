package com.greenlyte712.controller;

import com.greenlyte712.dto.LeadQuestionDTO;
import com.greenlyte712.model.lead_question.LeadQuestion;
import com.greenlyte712.model.seller.Seller;
import com.greenlyte712.repository.LeadQuestionRepository;
import com.greenlyte712.security.JwtService;
import com.greenlyte712.security.UserInfo;
import com.greenlyte712.security.UserInfoService;
import com.greenlyte712.service.SellerService;
import com.greenlyte712.util.SecurityContextHolderUtil;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/seller")

public class SellerController {

    private final SellerService sellerService;
    private UserInfoService userInfoService;
    private JwtService jwtService;
    private LeadQuestionRepository leadQuestionRepository;
    private SecurityContextHolderUtil securityContextHolderUtil;

    public SellerController(SellerService sellerService, UserInfoService userInfoService, JwtService jwtService, LeadQuestionRepository leadQuestionRepository, SecurityContextHolderUtil securityContextHolderUtil) {

        this.sellerService = sellerService;
        this.userInfoService = userInfoService;
        this.jwtService = jwtService;
        this.leadQuestionRepository = leadQuestionRepository;
        this.securityContextHolderUtil = securityContextHolderUtil;
    }

    @PostMapping("/create-seller-account")
    public String createSellerAccount(@RequestBody Seller seller) {

        UserInfo userInfo = securityContextHolderUtil.getAuthenticatedUserInfo();
        seller.setUserInfo(userInfo);

        sellerService.saveSeller(seller);

        return "Seller created...";
    }

    @PostMapping("/create-lead-questions")
    public ResponseEntity<LeadQuestion> createLeadQuestion(@RequestBody LeadQuestionDTO leadQuestionDTO) {

        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();

        Long sellerId = seller.getId();

        LeadQuestion leadQuestion = sellerService.createLeadQuestion(sellerId, leadQuestionDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(leadQuestion);
    }

    @GetMapping("/get-lead-questions")
    public ResponseEntity<List<LeadQuestionDTO>> getLeadQuestions() {

        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();

        // Retrieve Lead Questions by Seller ID
        List<LeadQuestion> leadQuestions = leadQuestionRepository.getLeadQuestionBySellerId(seller.getId());

        // Map LeadQuestion entities to DTOs (if needed)
        List<LeadQuestionDTO> leadQuestionDTOs = leadQuestions.stream().map(leadQuestion -> new LeadQuestionDTO(leadQuestion.getId(), leadQuestion.getQuestion())).toList();

        return ResponseEntity.ok(leadQuestionDTOs);
    }

    @GetMapping("/seller-view-their-details")
    public ResponseEntity<Seller> sellerViewTheirDetails() {

        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();

        return ResponseEntity.ok(seller);
    }

    //Present on frontend
    @PostMapping("/seller-update-their-company-description")
    public ResponseEntity<String> sellerUpdateTheirCompanyDescription(@RequestParam String companyDescription) {

        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();

        sellerService.updateCompanyDescription(seller.getId(), companyDescription);

        return ResponseEntity.ok("Description is updated");
    }
    //Present on frontend
    @PostMapping("/seller-update-their-web-address")
    public ResponseEntity<String> sellerUpdateTheirWebAddress(@RequestParam String webAddress) {
        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();
        sellerService.updateCompanyWebAddress(seller.getId(), webAddress);
        return ResponseEntity.ok("Web address is updated");
    }

    //Present on frontend
    @PostMapping("/seller-update-their-meta-tags")
    public ResponseEntity<String> sellerUpdateTheirMetaTags(@RequestBody List<String> metaTags) {
        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();
        sellerService.updateMetaTags(seller.getId(), metaTags);
        return ResponseEntity.ok("Meta tags are updated");
    }

    //Present on frontend
    @PostMapping("/seller-update-their-serviced-zip-codes")
    public ResponseEntity<String> sellerUpdateTheirServicedZipCodes(@RequestBody List<String> servicedZipCodes) {
        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();
        sellerService.updateServicedZipCodes(seller.getId(), servicedZipCodes);
        return ResponseEntity.ok("Services zip codes are updated");
    }
    //Present on frontend
    @PostMapping("/seller-update-their-company-name")
    public ResponseEntity<String> sellerUpdateTheirCompanyName(@RequestParam String companyName) {
        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();
        sellerService.updateCompanyName(seller.getId(), companyName);
        return ResponseEntity.ok("Company name updated");
    }
    //Present on frontend
    @PostMapping("/seller-update-their-email")
    public ResponseEntity<String> sellerUpdateTheirEmail(@RequestParam String email) {
        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();
        sellerService.updateEmail(seller.getId(), email);
        return ResponseEntity.ok("Email updated");
    }
// present on frontend
    @PostMapping("/seller-update-their-phone-number")
    public ResponseEntity<String> sellerUpdateTheirPhoneNumber(@RequestParam String phoneNumber) {
        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();
        sellerService.updatePhoneNumber(seller.getId(), phoneNumber);
        return ResponseEntity.ok("Phone number updated");
    }
// present on frontend
    @PostMapping("/seller-update-their-street-address")
    public ResponseEntity<String> sellerUpdateTheirStreetAddress(@RequestParam String street) {
        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();
        sellerService.updateStreetAddress(seller.getId(), street);
        return ResponseEntity.ok("Street address updated");
    }

    @PostMapping("/seller-update-their-city-address")
    public ResponseEntity<String> sellerUpdateTheirCityAddress(@RequestParam String city) {
        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();
        sellerService.updateCityAddress(seller.getId(), city);
        return ResponseEntity.ok("City address updated");
    }

    @PostMapping("/seller-update-their-state-address")
    public ResponseEntity<String> sellerUpdateTheirStateAddress(@RequestParam String state) {
        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();
        sellerService.updateStateAddress(seller.getId(), state);
        return ResponseEntity.ok("State address updated");
    }

    @DeleteMapping("/delete-lead-question-by-id/{id}")
    public ResponseEntity<String> deleteLeadQuestionById(@PathVariable Long id) {
        sellerService.deleteLeadQuestion(id);
        return ResponseEntity.ok("Lead question deleted successfully");
    }
}