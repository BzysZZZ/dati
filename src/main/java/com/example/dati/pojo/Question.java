package com.example.dati.pojo;

import java.io.Serializable;

/**
 * 题目实体类
 */
public class Question implements Serializable {
    private Integer id;         // 题目ID
    private String content;     // 题目内容
    private String options;     // 选项，以JSON格式存储
    private String answer;      // 正确答案
    private String type;        // 题目类型：single（单选题）、judge（判断题）或multiple（多选题）
    private String clause;      // 对应条款
    private String userId;      // 用户ID，用于区分不同用户的答题记录
    private String userAnswer;  // 用户答案
    private Boolean isCorrect;  // 是否正确

    // getter和setter方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getOptions() {
        return options;
    }

    public void setOptions(String options) {
        this.options = options;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getClause() {
        return clause;
    }

    public void setClause(String clause) {
        this.clause = clause;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserAnswer() {
        return userAnswer;
    }

    public void setUserAnswer(String userAnswer) {
        this.userAnswer = userAnswer;
    }

    public Boolean getIsCorrect() {
        return isCorrect;
    }

    public void setIsCorrect(Boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    @Override
    public String toString() {
        return "Question{" +
                "id=" + id +
                ", content='" + content + '\'' +
                ", options='" + options + '\'' +
                ", answer='" + answer + '\'' +
                ", type='" + type + '\'' +
                ", clause='" + clause + '\'' +
                ", userId='" + userId + '\'' +
                ", userAnswer='" + userAnswer + '\'' +
                ", isCorrect=" + isCorrect +
                '}';
    }
}