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
        boolean isCorrect = false;
        String correctAnswer = question.getAnswer();
        
        // 处理用户答案，移除空格和逗号，确保是大写字母
        String normalizedUserAnswer = userAnswer != null ? userAnswer.replaceAll("[\\s,]", "").toUpperCase() : "";
        
        // 根据题目类型判断答案
        if ("multiple".equals(question.getType())) {
            // 多选题：答案必须完全匹配，不考虑顺序
            // 这里假设答案已经标准化为连续的大写字母，如ABCD
            isCorrect = correctAnswer.equals(normalizedUserAnswer);
        } else {
            // 单选题和判断题：直接比较
            isCorrect = correctAnswer.equals(normalizedUserAnswer);
        }

        // 保存用户答题记录
        questionMapper.saveUserAnswer(userId, questionId, normalizedUserAnswer, isCorrect);

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
    
    @Override
    public void updateJudgeQuestions() {
        // 获取所有题目
        List<Question> allQuestions = questionMapper.getAllQuestions();
        
        for (Question question : allQuestions) {
            // 判断是否为判断题（包含"正确"和"错误"关键词）
            if (question.getType().equals("judge") || 
                (question.getContent() != null && 
                 question.getContent().contains("正确") && 
                 question.getContent().contains("错误"))) {
                
                // 设置为判断题类型
                question.setType("judge");
                
                // 更新选项，设置为标准的A/B选项
                String optionsJson = "{\"A\":\"正确\",\"B\":\"错误\"}";
                question.setOptions(optionsJson);
                
                // 更新答案，将√/×转换为A/B
                String answer = question.getAnswer();
                if (answer != null) {
                    if (answer.contains("√") || answer.contains("正确")) {
                        question.setAnswer("A");
                    } else if (answer.contains("×") || answer.contains("错误")) {
                        question.setAnswer("B");
                    }
                }
                
                // 更新题目
                questionMapper.updateQuestion(question);
            }
        }
    }
}