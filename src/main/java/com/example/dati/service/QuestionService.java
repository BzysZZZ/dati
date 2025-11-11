package com.example.dati.service;

import com.example.dati.pojo.Question;

import java.util.List;

/**
 * 题目服务接口
 */
public interface QuestionService {
    /**
     * 添加题目
     * @param question 题目对象
     * @return 添加结果
     */
    boolean addQuestion(Question question);

    /**
     * 批量添加题目
     * @param questions 题目列表
     * @return 添加结果
     */
    boolean batchAddQuestions(List<Question> questions);

    /**
     * 根据ID查询题目
     * @param id 题目ID
     * @return 题目对象
     */
    Question getQuestionById(Integer id);

    /**
     * 查询所有题目
     * @return 题目列表
     */
    List<Question> getAllQuestions();

    /**
     * 更新题目
     * @param question 题目对象
     * @return 更新结果
     */
    boolean updateQuestion(Question question);

    /**
     * 删除题目
     * @param id 题目ID
     * @return 删除结果
     */
    boolean deleteQuestion(Integer id);

    /**
     * 提交用户答案
     * @param userId 用户ID
     * @param questionId 题目ID
     * @param userAnswer 用户答案
     * @return 是否正确
     */
    boolean submitAnswer(String userId, Integer questionId, String userAnswer);

    /**
     * 查询用户答题记录
     * @param userId 用户ID
     * @return 答题记录列表
     */
    List<Question> getUserAnswers(String userId);

    /**
     * 统计用户答题结果
     * @param userId 用户ID
     * @return 结果数组 [总题数, 已答题数, 正确题数]
     */
    int[] getUserAnswerStats(String userId);
    
    /**
     * 重置用户答题记录
     * @param userId 用户ID
     */
    void resetUserAnswers(String userId);
    
    /**
     * 更新判断题格式，确保所有判断题都有标准的选项和答案格式
     */
    void updateJudgeQuestions();
}