package com.greenlyte712.controller;

import com.greenlyte712.dto.LeadQuestionResponseDTO;
import com.greenlyte712.model.buyer.Buyer;
import com.greenlyte712.model.conversation.Conversation;
import com.greenlyte712.model.conversation.ConversationInitiationRequest;
import com.greenlyte712.model.lead_question.LeadQuestion;
import com.greenlyte712.model.seller.Seller;
import com.greenlyte712.repository.LeadQuestionRepository;
import com.greenlyte712.security.JwtService;
import com.greenlyte712.security.UserInfo;
import com.greenlyte712.security.UserInfoService;
import com.greenlyte712.service.BuyerService;
import com.greenlyte712.service.ConversationService;
import com.greenlyte712.service.SellerService;
import com.greenlyte712.util.SecurityContextHolderUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/conversations")
public class ConversationController {

    @Autowired
    private ConversationService conversationService;

    @Autowired
    private SellerService sellerService;

    @Autowired
    private BuyerService buyerService;

    @Autowired
    private UserInfoService userInfoService;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private LeadQuestionRepository leadQuestionRepository;

    @Autowired
    private SecurityContextHolderUtil securityContextHolderUtil;

    @GetMapping("/get_lead_questions_from_seller")
    public ResponseEntity<List<LeadQuestionResponseDTO>> getLeadQuestionsFromSeller(Long sellerId) {

        List<LeadQuestion> leadQuestions = conversationService.getLeadQuestions(sellerId);
        List<LeadQuestionResponseDTO> response = leadQuestions.stream().map(question -> new LeadQuestionResponseDTO(question.getId(), question.getQuestion())).collect(Collectors.toList());
        return ResponseEntity.ok(response);
    }

    @PostMapping("/initiate") // allow buyer to initiate a conversation with a specific seller
    public ResponseEntity<Conversation> initiateConversation(@RequestBody ConversationInitiationRequest conversationInitiationRequest, @RequestHeader("Authorization") String token) {

        if (token.startsWith("Bearer ")) {
            token = token.substring(7).trim();
        }

        String userName = jwtService.extractUsername(token);

        Optional<UserInfo> optionalUserInfo = userInfoService.findByUsername(userName);

        if (optionalUserInfo.isPresent()) {

            UserInfo userInfo = optionalUserInfo.get();

            Optional<Buyer> buyerByUserInfo = buyerService.findByUserInfo(userInfo);
            Optional<Seller> sellerById = sellerService.getSellerById(conversationInitiationRequest.getSellerId());

            if (buyerByUserInfo.isPresent() && sellerById.isPresent()) {

                Long buyerId = buyerByUserInfo.get().getId();
                Optional<Buyer> buyerById = buyerService.getBuyerById(buyerId);
                Buyer buyer = buyerById.get();
                Seller seller = sellerById.get();

                // Get the answers to the lead questions
                List<ConversationInitiationRequest.LeadQuestionAnswer> leadQuestionAnswers = conversationInitiationRequest.getLeadQuestionAnswers();

                // Iterate through the lead question answers and fetch the actual question text
                List<String> questionsWithAnswers = leadQuestionAnswers.stream().map(answer -> {
                    // Fetch the LeadQuestion from the repository
                    return leadQuestionRepository.findById(answer.getQuestionId()).map(leadQuestion -> leadQuestion.getQuestion() + ": " + answer.getAnswer()) // Format question with answer
                            .orElse("Unknown question: " + answer.getAnswer()); // Handle missing questions
                }).collect(Collectors.toList());

// Concatenate the questions with answers into a single message
                String questionsAndAnswersString = String.join("<^^^> ", questionsWithAnswers);

// Append to the original message content
                conversationInitiationRequest.setMessageContent(conversationInitiationRequest.getMessageContent() + "<^^^> Here are my answers to your questions:<^^^>" + questionsAndAnswersString);

                // Initiate the conversation
                Conversation conversation = conversationService.initiateConversation(buyer, seller, conversationInitiationRequest.getMessageContent());

                return ResponseEntity.ok(conversation);
            } else {
                throw new RuntimeException("Buyer or seller not found");
            }
        } else {
            throw new RuntimeException("Buyer or seller not found");
        }
    }

    // allow a buyer or seller to contribute to a conversation
    @PostMapping("/{conversationId}/message")
    public ResponseEntity<Void> addMessageToConversation(@PathVariable Long conversationId, @RequestParam String messageContent, @RequestHeader("Authorization") String token) {

        Long senderId = null;
        String senderType = null;

        if (token.startsWith("Bearer ")) {
            token = token.substring(7).trim();
        }

        String userName = jwtService.extractUsername(token);

        Optional<UserInfo> optionalUserInfo = userInfoService.findByUsername(userName);

        if (optionalUserInfo.isPresent()) {

            UserInfo userInfo = optionalUserInfo.get();

            List<String> roles = userInfo.getRoles();

            if (roles.contains("ROLE_SELLER")) {
                Optional<Seller> sellerByUserInfo = sellerService.findByUserInfo(userInfo);
                Seller seller = sellerByUserInfo.get();
                senderId = seller.getId();
                senderType = "seller";
            }

            if (roles.contains("ROLE_BUYER")) {
                Optional<Buyer> buyerByUserInfo = buyerService.findByUserInfo(userInfo);
                Buyer buyer = buyerByUserInfo.get();
                senderId = buyer.getId();
                senderType = "buyer";
            }
        }
        conversationService.addMessageToConversation(conversationId, senderId, senderType, messageContent);

        return ResponseEntity.ok().build();
    }

    // Get all conversations for a Seller
    @GetMapping("/get-all-conversations-for-seller")
    public ResponseEntity<List<Conversation>> getConversationsForSeller() {

        Seller seller = securityContextHolderUtil.getAuthenticatedSellerEntity();
        Long sellerId = seller.getId();

        List<Conversation> conversations = conversationService.getConversationsForSeller(sellerId);
        return ResponseEntity.ok(conversations);
    }

    // Get all conversations for a Buyer
    @GetMapping("/get-all-conversations-for-buyer")
    public ResponseEntity<List<Conversation>> getConversationsForBuyer() {

        Buyer buyer = securityContextHolderUtil.getAuthenticatedBuyerEntity();

        Long buyerId = buyer.getId();

        List<Conversation> conversations = conversationService.getConversationsForBuyer(buyerId);
        return ResponseEntity.ok(conversations);
    }

    @DeleteMapping("/delete-conversation-by-id/{conversationId}")
    public ResponseEntity<Void> deleteConversationById(@PathVariable Long conversationId) {

        conversationService.deleteConversation(conversationId);

        return ResponseEntity.noContent().build();
    }
}