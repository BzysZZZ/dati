<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>党纪题库自测系统 - 题目列表</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        h1 {
            color: #1a5276;
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .stats {
            background-color: #e8f4f8;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #3498db;
        }
        .btn {
            display: inline-block;
            padding: 8px 16px;
            margin: 5px;
            text-decoration: none;
            color: white;
            background-color: #3498db;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .btn-import {
            background-color: #27ae60;
        }
        .btn-import:hover {
            background-color: #229954;
        }
        .btn-stats {
            background-color: #f39c12;
        }
        .btn-stats:hover {
            background-color: #e67e22;
        }
        .question-list {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 20px;
        }
        .question-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .question-item:last-child {
            border-bottom: none;
        }
        .question-content {
            flex: 1;
        }
        .question-info {
            margin-top: 5px;
            font-size: 14px;
            color: #7f8c8d;
        }
        .question-status {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-unanswered {
            background-color: #ecf0f1;
            color: #7f8c8d;
        }
        .status-correct {
            background-color: #d5f5e3;
            color: #27ae60;
        }
        .status-incorrect {
            background-color: #fdedec;
            color: #e74c3c;
        }
    </style>
</head>
<body>
    <h1>党纪题库自测系统</h1>
    
    <div class="header">
        <div class="stats">
            <strong>总题数:</strong> ${totalCount} | 
            <strong>已答题数:</strong> ${answeredCount} | 
            <strong>正确题数:</strong> ${correctCount}
        </div>
        <div>
            <a href="/question/import" class="btn btn-import">导入题目</a>
            <a href="/question/stats" class="btn btn-stats">查看统计</a>
        </div>
    </div>
    
    <div class="question-list">
        <c:if test="${empty questions}">
            <p style="text-align: center; color: #7f8c8d;">暂无题目，请先导入题目文件</p>
        </c:if>
        
        <c:forEach items="${questions}" var="question">
            <div class="question-item">
                <div class="question-content">
                    <h3>${question.id}. ${question.content}</h3>
                    <div class="question-info">
                        <span>${question.type == 'judge' ? '判断题' : '单选题'}</span>
                        <c:if test="${not empty question.clause}">
                            | 对应条款: ${question.clause}
                        </c:if>
                    </div>
                </div>
                <div>
                    <c:choose>
                        <c:when test="${empty question.userAnswer}">
                            <span class="question-status status-unanswered">未作答</span>
                        </c:when>
                        <c:when test="${question.isCorrect}">
                            <span class="question-status status-correct">正确</span>
                        </c:when>
                        <c:otherwise>
                            <span class="question-status status-incorrect">错误</span>
                        </c:otherwise>
                    </c:choose>
                    <a href="/question/detail/${question.id}" class="btn">答题</a>
                </div>
            </div>
        </c:forEach>
    </div>
</body>
</html>