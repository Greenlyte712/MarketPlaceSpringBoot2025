package com.greenlyte712.service;

import com.greenlyte712.model.buyer.Buyer;
import com.greenlyte712.model.conversation.Conversation;
import com.greenlyte712.model.lead_question.LeadQuestion;
import com.greenlyte712.model.message.Message;
import com.greenlyte712.model.seller.Seller;
import com.greenlyte712.repository.ConversationRepository;
import com.greenlyte712.repository.LeadQuestionRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ConversationService {

    private ConversationRepository conversationRepository;

    private LeadQuestionRepository leadQuestionRepository;

    public ConversationService(ConversationRepository conversationRepository, LeadQuestionRepository leadQuestionRepository) {
        this.conversationRepository = conversationRepository;
        this.leadQuestionRepository = leadQuestionRepository;
    }

    public List<LeadQuestion> getLeadQuestions(Long sellerId) {

        return leadQuestionRepository.getLeadQuestionBySellerId(sellerId);
    }

    public Conversation initiateConversation(Buyer buyer, Seller seller, String messageContent) {
        Conversation conversation = new Conversation(buyer, seller);
        Message message = new Message(buyer.getId(), "buyer", messageContent);
        conversation.addMessage(message);
        return conversationRepository.save(conversation);
    }

    public void addMessageToConversation(Long conversationId, Long senderId, String senderType, String messageContent) {
        Optional<Conversation> optionalConversation = conversationRepository.findById(conversationId);
        if (optionalConversation.isPresent()) {
            Conversation conversation = optionalConversation.get();
            Message message = new Message(senderId, senderType, messageContent);
            conversation.addMessage(message);
            conversationRepository.save(conversation); // Save the updated conversation
        } else {
            // Handle the case where the conversation is not found
            throw new RuntimeException("Conversation not found");
        }
    }

    public List<Conversation> getConversationsForSeller(Long sellerId) {
        List<Conversation> conversations = conversationRepository.findBySellerIdWithMessages(sellerId);

        return conversations;
    }

    public List<Conversation> getConversationsForBuyer(Long buyerId) {
        List<Conversation> conversations = conversationRepository.findByBuyerIdWithMessages(buyerId);
        return conversations;
    }

    public void deleteConversation(Long conversationId) {
        conversationRepository.deleteById(conversationId);
    }
}