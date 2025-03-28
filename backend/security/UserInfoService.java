package com.greenlyte712.security;

import com.greenlyte712.security.exceptions.UsernameAlreadyExistsException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class UserInfoService implements UserDetailsService {

    // Inject the UserInfoRepository
    @Autowired
    private UserInfoRepository userInfoRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // Method to find a user by username
    public Optional<UserInfo> findByUsername(String username) {
        return Optional.ofNullable(userInfoRepository.findByUsername(username));
    }

    // Method to save a user
    public UserInfo saveUser(UserInfo userInfo, boolean isPasswordReset) throws UsernameAlreadyExistsException {

        if (!isPasswordReset && userInfoRepository.findByUsername(userInfo.getUsername()) != null) {
            throw new UsernameAlreadyExistsException("Username already exists");
        }

        userInfo.setPassword(passwordEncoder.encode(userInfo.getPassword()));
        return userInfoRepository.save(userInfo);
    }

    // Method to retrieve all users
    public List<UserInfo> getAllUsers() {
        return userInfoRepository.findAll();
    }

    // Method to find a user by their ID
    public Optional<UserInfo> getUserById(Long id) {
        return userInfoRepository.findById(id);
    }

    // Method to delete a user by their ID
    public void deleteUser(Long id) {
        userInfoRepository.deleteById(id);
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        UserInfo userInfo = userInfoRepository.findByUsername(username);
        // Check if the user is found
        if (userInfo == null) {
            throw new UsernameNotFoundException("User not found with username: " + username);
        }
        // Convert UserInfo to UserDetails
        return new UserInfoDetails(userInfo);
    }

    public Optional<UserInfo> findByEmail(String email) {
        // TODO Auto-generated method stub
        return userInfoRepository.findByEmail(email);
    }

    // Method to generate reset token and set expiration time
    public String generateResetToken(UserInfo user) {
        String token = UUID.randomUUID().toString();
        user.setResetToken(token);
        user.setTokenExpirationTime(LocalDateTime.now().plusHours(1));  // Token valid for 1 hour
        userInfoRepository.save(user);  // Save the updated user with the token and expiration time
        return token;
    }

    public Optional<UserInfo> findByResetToken(String resetToken) {
        // TODO Auto-generated method stub
        return userInfoRepository.findByResetToken(resetToken);
    }


}