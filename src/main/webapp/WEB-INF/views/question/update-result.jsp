<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>更新结果 - 党纪题库自测系统</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px;
            background-color: #f5f5f5;
        }
        .result-container {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 30px;
            text-align: center;
        }
        h1 {
            color: #1a5276;
            margin-bottom: 30px;
        }
        .message {
            font-size: 18px;
            color: #27ae60;
            margin: 20px 0;
        }
        .error {
            font-size: 18px;
            color: #e74c3c;
            margin: 20px 0;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 20px 5px 0 0;
            text-decoration: none;
            color: white;
            background-color: #3498db;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }
        .btn:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
    <div class="result-container">
        <h1>判断题格式更新结果</h1>
        
        <c:if test="${not empty message}">
            <div class="message">${message}</div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <div style="margin-top: 30px;">
            <a href="/question/list" class="btn">返回题目列表</a>
            <a href="/question/continue" class="btn">开始答题</a>
        </div>
    </div>
</body>
</html>