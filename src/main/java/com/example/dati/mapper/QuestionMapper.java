package com.example.dati.mapper;

import com.example.dati.pojo.Question;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 题目Mapper接口
 */
public interface QuestionMapper {
    /**
     * 添加题目
     * @param question 题目对象
     * @return 添加结果
     */
    int addQuestion(Question question);

    /**
     * 批量添加题目
     * @param questions 题目列表
     * @return 添加结果
     */
    int batchAddQuestions(@Param("questions") List<Question> questions);

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
    int updateQuestion(Question question);

    /**
     * 删除题目
     * @param id 题目ID
     * @return 删除结果
     */
    int deleteQuestion(Integer id);

    /**
     * 保存用户答题记录
     * @param userId 用户ID
     * @param questionId 题目ID
     * @param userAnswer 用户答案
     * @param isCorrect 是否正确
     * @return 保存结果
     */
    int saveUserAnswer(@Param("userId") String userId, 
                      @Param("questionId") Integer questionId, 
                      @Param("userAnswer") String userAnswer, 
                      @Param("isCorrect") Boolean isCorrect);

    /**
     * 查询用户答题记录
     * @param userId 用户ID
     * @return 答题记录列表
     */
    List<Question> getUserAnswers(@Param("userId") String userId);
    
    /**
     * 删除用户答题记录
     * @param userId 用户ID
     * @return 删除结果
     */
    int deleteUserAnswers(@Param("userId") String userId);
}