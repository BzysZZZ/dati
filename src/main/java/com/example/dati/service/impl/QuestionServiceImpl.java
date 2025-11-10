package com.example.dati.service.impl;

import com.example.dati.mapper.QuestionMapper;
import com.example.dati.pojo.Question;
import com.example.dati.service.QuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 题目服务实现类
 */
@Service
@Transactional
public class QuestionServiceImpl implements QuestionService {

    @Autowired
    private QuestionMapper questionMapper;

    @Override
    public boolean addQuestion(Question question) {
        return questionMapper.addQuestion(question) > 0;
    }

    @Override
    public boolean batchAddQuestions(List<Question> questions) {
        return questionMapper.batchAddQuestions(questions) > 0;
    }

    @Override
    public Question getQuestionById(Integer id) {
        return questionMapper.getQuestionById(id);
    }

    @Override
    public List<Question> getAllQuestions() {
        return questionMapper.getAllQuestions();
    }

    @Override
    public boolean updateQuestion(Question question) {
        return questionMapper.updateQuestion(question) > 0;
    }

    @Override
    public boolean deleteQuestion(Integer id) {
        return questionMapper.deleteQuestion(id) > 0;
    }

    @Override
    public boolean submitAnswer(String userId, Integer questionId, String userAnswer) {
        // 获取题目信息
        Question question = questionMapper.getQuestionById(questionId);
        if (question == null) {
            return false;
        }

        // 判断答案是否正确
        boolean isCorrect = question.getAnswer().equals(userAnswer);

        // 保存用户答题记录
        questionMapper.saveUserAnswer(userId, questionId, userAnswer, isCorrect);

        return isCorrect;
    }

    @Override
    public List<Question> getUserAnswers(String userId) {
        return questionMapper.getUserAnswers(userId);
    }

    @Override
    public int[] getUserAnswerStats(String userId) {
        List<Question> questions = questionMapper.getUserAnswers(userId);
        int totalCount = questions.size();
        int answeredCount = 0;
        int correctCount = 0;

        for (Question question : questions) {
            if (question.getUserAnswer() != null) {
                answeredCount++;
                if (Boolean.TRUE.equals(question.getIsCorrect())) {
                    correctCount++;
                }
            }
        }

        return new int[]{totalCount, answeredCount, correctCount};
    }
    
    @Override
    public void resetUserAnswers(String userId) {
        questionMapper.deleteUserAnswers(userId);
    }
}