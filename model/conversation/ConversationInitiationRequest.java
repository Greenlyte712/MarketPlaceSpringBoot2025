package com.greenlyte712.model.conversation;

import java.util.List;

public class ConversationInitiationRequest {

    private Long sellerId;
    private String messageContent;
    //public static class in this class
    private List<LeadQuestionAnswer> leadQuestionAnswers;

    public ConversationInitiationRequest(Long sellerId, String messageContent, List<LeadQuestionAnswer> leadQuestionAnswers) {

        this.sellerId = sellerId;
        this.messageContent = messageContent;
        this.leadQuestionAnswers=leadQuestionAnswers;
    }

    public Long getSellerId() {
        return sellerId;
    }

    public void setSellerId(Long sellerId) {
        this.sellerId = sellerId;
    }

    public String getMessageContent() {
        return messageContent;
    }

    public void setMessageContent(String messageContent) {
        this.messageContent = messageContent;
    }

    public List<LeadQuestionAnswer> getLeadQuestionAnswers() {
        return leadQuestionAnswers;
    }

    public void setLeadQuestionAnswers(List<LeadQuestionAnswer> leadQuestionAnswers) {
        this.leadQuestionAnswers = leadQuestionAnswers;
    }

    public static class LeadQuestionAnswer {
        private Long questionId;
        private String answer;

        public LeadQuestionAnswer(Long questionId, String answer) {
            this.questionId = questionId;
            this.answer = answer;
        }

        public Long getQuestionId() {
            return questionId;
        }

        public void setQuestionId(Long questionId) {
            this.questionId = questionId;
        }

        public String getAnswer() {
            return answer;
        }

        public void setAnswer(String answer) {
            this.answer = answer;
        }
    }



}