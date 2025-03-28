package com.greenlyte712.security;

import com.greenlyte712.security.exceptions.UsernameAlreadyExistsException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Optional;

@RestController
@RequestMapping("/auth")

//server.port=8085
public class UserController {

    @Autowired
    private UserInfoService userInfoService;
    @Autowired
    private JwtService jwtService;
    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private EmailService emailService;

    // POST Mappings
    // http://localhost:8085/auth/addNewUser
    @PostMapping("/addNewUser")
    public ResponseEntity<String> addNewUser(@RequestBody UserInfo userInfo) {

        userInfo.setId(0);
        try {
            UserInfo savedUser = userInfoService.saveUser(userInfo, false);

            return ResponseEntity.ok(savedUser.getUsername() + " created.");
        } catch (UsernameAlreadyExistsException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("username already exists.");
        }
    }

    // http://localhost:8085/auth/generateToken
    @PostMapping("/generateToken")
    public ResponseEntity<String> authenticateAndGetToken(@RequestBody AuthRequest authRequest) {

        Authentication authentication = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(authRequest.getUsername(), authRequest.getPassword()));

        if (authentication.isAuthenticated()) {

            Optional<UserInfo> optionalUser = userInfoService.findByUsername(authRequest.getUsername());

            if (optionalUser.isPresent()) {

                UserInfo user = optionalUser.get();

                return ResponseEntity.ok(jwtService.generateToken(authRequest.getUsername(), user.getRoles()));
            } else {
                // If user not found, throw a 404 Not Found error, but 401 is Spring's default
                // behavior anyways
                throw new UsernameNotFoundException("see GlobalEceptionHandler...");
            }
        } else {
            // If authentication fails, throw a 401 Unauthorized error
            throw new BadCredentialsException("see GlobalEceptionHandler...");
        }
    }

    // Endpoint to request password reset
    @PostMapping("/requestResetPassword")
    public ResponseEntity<String> requestResetPassword(@RequestParam String email) {
        Optional<UserInfo> optionalUser = userInfoService.findByEmail(email);

        if (optionalUser.isPresent()) {
            UserInfo user = optionalUser.get();

            // Generate reset token
            String token = userInfoService.generateResetToken(user);

            // Send password reset email
            emailService.sendPasswordResetEmail(user.getEmail(), token);

            return ResponseEntity.ok("Password reset email sent to: " + email);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User with email " + email + " not found.");
        }
    }

    @PostMapping("/resetPassword")
    public ResponseEntity<String> resetPassword(@RequestParam String token, @RequestParam String newPassword) {
        // Logic to validate the token and find the user
        Optional<UserInfo> optionalUser = userInfoService.findByResetToken(token);

        if (optionalUser.isPresent()) {
            UserInfo user = optionalUser.get();

            // Check if token is expired
            if (user.getTokenExpirationTime().isBefore(LocalDateTime.now())) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Token has expired.");
            }

            user.setPassword(newPassword);
            user.setResetToken(null); // Clear the reset token
            user.setTokenExpirationTime(null); // Clear the expiration time
            try {
                userInfoService.saveUser(user, true);
            } catch (UsernameAlreadyExistsException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } // Save the updated user info with the new password

            return ResponseEntity.ok("Password reset successfully for user: " + user.getEmail());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Invalid token.");
        }
    }
}