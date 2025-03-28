package com.greenlyte712.util;

import com.greenlyte712.model.buyer.Buyer;
import com.greenlyte712.model.seller.Seller;
import com.greenlyte712.security.UserInfo;
import com.greenlyte712.security.UserInfoService;
import com.greenlyte712.service.BuyerService;
import com.greenlyte712.service.SellerService;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
public class SecurityContextHolderUtil {

    private UserInfoService userInfoService;
    private SellerService sellerService;
    private BuyerService buyerService;

    public SecurityContextHolderUtil(UserInfoService userInfoService, SellerService sellerService, BuyerService buyerService) {
        this.userInfoService = userInfoService;
        this.sellerService = sellerService;
        this.buyerService = buyerService;
    }

    public Seller getAuthenticatedSellerEntity() {

        UserInfo userInfo = getAuthenticatedUserInfo();

        // Find Seller associated with UserInfo
        return sellerService.findByUserInfo(userInfo).orElseThrow(() -> new RuntimeException("Seller not found"));
    }

    public Buyer getAuthenticatedBuyerEntity() {

        UserInfo userInfo = getAuthenticatedUserInfo();

        // Find Seller associated with UserInfo
        return buyerService.findByUserInfo(userInfo).orElseThrow(() -> new RuntimeException("Seller not found"));
    }

    public UserInfo getAuthenticatedUserInfo() {

        String username = null;
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            username = ((UserDetails) principal).getUsername();
        } else {
            username = principal.toString();
        }

        // Find UserInfo based on username
        UserInfo userInfo = userInfoService.findByUsername(username).orElseThrow(() -> new RuntimeException("User not found"));

        return userInfo;
    }
}