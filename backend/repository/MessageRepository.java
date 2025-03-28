package com.greenlyte712.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.greenlyte712.model.message.Message;

public interface MessageRepository extends JpaRepository<Message, Long> {
    // Custom query methods can be defined here if needed
}
