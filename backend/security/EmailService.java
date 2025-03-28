package com.greenlyte712.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendPasswordResetEmail(String to, String token) {
        String subject = "Password Reset Request";
        String resetLink = "http://localhost:53660/frontendRequestResetPassword?token=" + token; // Change this to your actual reset URL, which is a frontend page, so it will have a different port number for localhost

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setFrom("your_email_address_here");
        message.setSubject(subject);
        message.setText("To reset your password, please click the link below:\n" + resetLink);
        mailSender.send(message);
    }
}