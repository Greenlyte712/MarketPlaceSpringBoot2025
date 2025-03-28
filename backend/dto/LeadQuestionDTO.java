package com.greenlyte712.dto;

public class LeadQuestionDTO {

    private Long id;
    private String question;

    public LeadQuestionDTO(Long id, String question) {
        this.id = id;
        this.question = question;
    }

    public LeadQuestionDTO() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }
}