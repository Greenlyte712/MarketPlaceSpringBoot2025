package com.greenlyte712.model.conversation;

import java.util.ArrayList;
import java.util.List;

import com.greenlyte712.model.buyer.Buyer;
import com.greenlyte712.model.message.Message;
import com.greenlyte712.model.seller.Seller;

import jakarta.persistence.*;

@Entity
public class Conversation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private Buyer buyer;

    @ManyToOne
    private Seller seller;

    @OneToMany(mappedBy = "conversation", fetch = FetchType.EAGER, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Message> messages = new ArrayList<>();

    // Constructors
    public Conversation() {
        // Default constructor
    }

    public Conversation(Buyer buyer, Seller seller) {
        this.buyer = buyer;
        this.seller = seller;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Buyer getBuyer() {
        return buyer;
    }

    public void setBuyer(Buyer buyer) {
        this.buyer = buyer;
    }

    public Seller getSeller() {
        return seller;
    }

    public void setSeller(Seller seller) {
        this.seller = seller;
    }

    public List<Message> getMessages() {
        return messages;
    }

    public void setMessages(List<Message> messages) {
        this.messages = messages;
    }

    public void addMessage(Message message) {
        messages.add(message);
        message.setConversation(this);
    }

    @Override
    public String toString() {
        return "Conversation [id=" + id + ", buyer=" + buyer + ", seller=" + seller + "]";
    }
}