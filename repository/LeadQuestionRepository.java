package com.greenlyte712.repository;

import com.greenlyte712.model.lead_question.LeadQuestion;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LeadQuestionRepository extends JpaRepository<LeadQuestion, Long> {
    List<LeadQuestion> getLeadQuestionBySellerId(Long sellerId);
}