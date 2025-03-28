package com.greenlyte712.controller;

import com.greenlyte712.model.buyer.Buyer;
import com.greenlyte712.model.seller.Seller;
import com.greenlyte712.security.JwtService;
import com.greenlyte712.security.UserInfo;
import com.greenlyte712.security.UserInfoService;
import com.greenlyte712.service.BuyerService;
import com.greenlyte712.service.SellerService;
import com.greenlyte712.util.SecurityContextHolderUtil;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@CrossOrigin("*")
@RequestMapping("/buyer")
//Version 0001
public class BuyerController {

    private final BuyerService buyerService;

    private final SellerService sellerService;

    private UserInfoService userInfoService;

    private JwtService jwtService;

    private SecurityContextHolderUtil securityContextHolderUtil;

    public BuyerController(BuyerService buyerService, SellerService sellerService, UserInfoService userInfoService, JwtService jwtService, SecurityContextHolderUtil securityContextHolderUtil) {

        this.buyerService = buyerService;
        this.sellerService = sellerService;
        this.userInfoService = userInfoService;
        this.jwtService = jwtService;
        this.securityContextHolderUtil = securityContextHolderUtil;
    }

    @PostMapping("/create-buyer-account")
    public String createBuyerAccount(@RequestBody Buyer buyer) {

        UserInfo userInfo = securityContextHolderUtil.getAuthenticatedUserInfo();

        buyer.setUserInfo(userInfo);

        buyerService.saveBuyer(buyer);

        return "Buyer created...";
    }

    @GetMapping("/get-all-sellers")
    public ResponseEntity<List<Seller>> getAllSellers() {
        List<Seller> sellers = sellerService.getAllSellers();
        return ResponseEntity.ok(sellers);
    }

    @GetMapping("/sellersByZipAndTag")
    public List<Seller> getSellersByZipCode(@RequestParam String zipCode, @RequestParam String tag) {

        System.out.println("SellerS::::: " + sellerService.getSellersByZipCodeAndTag(zipCode, tag));

        return sellerService.getSellersByZipCodeAndTag(zipCode, tag);
    }

    @GetMapping("/seller/{id}")
    public ResponseEntity<Seller> getSellerById(@PathVariable Long id) {
        Optional<Seller> seller = sellerService.getSellerById(id);
        if (seller.isPresent()) {
            return ResponseEntity.ok(seller.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }
}