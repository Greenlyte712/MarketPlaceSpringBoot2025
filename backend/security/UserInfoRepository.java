package com.greenlyte712.security;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserInfoRepository extends JpaRepository<UserInfo, Long> {
	 // Custom method to find by username
	UserInfo findByUsername(String username);

	Optional<UserInfo> findByEmail(String email);

	Optional<UserInfo> findByResetToken(String resetToken);
}
