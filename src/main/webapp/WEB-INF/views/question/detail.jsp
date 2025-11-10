<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>题目详情 - 党纪题库自测系统</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        h1 {
            color: #1a5276;
            text-align: center;
            margin-bottom: 30px;
        }
        .question-container {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .question-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        .question-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .question-info {
            font-size: 14px;
            color: #7f8c8d;
        }
        .options {
            margin: 20px 0;
        }
        .option {
            padding: 12px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .option:hover {
            border-color: #3498db;
            background-color: #f8f9fa;
        }
        .option.selected {
            border-color: #3498db;
            background-color: #e8f4fc;
        }
        .option input[type="radio"] {
            margin-right: 10px;
        }
        .option-label {
            cursor: pointer;
            display: inline-block;
            vertical-align: middle;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px 5px 0 0;
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
        .btn-back {
            background-color: #7f8c8d;
        }
        .btn-back:hover {
            background-color: #6c757d;
        }
        .result {
            margin-top: 20px;
            padding: 15px;
            border-radius: 4px;
            display: none;
        }
        .result.correct {
            background-color: #d5f5e3;
            color: #27ae60;
            border-left: 4px solid #27ae60;
        }
        .result.incorrect {
            background-color: #fdedec;
            color: #e74c3c;
            border-left: 4px solid #e74c3c;
        }
        .result-header {
            font-weight: bold;
            margin-bottom: 10px;
        }
        .answer-info {
            font-size: 14px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <h1>题目详情</h1>
    
    <div class="question-container">
        <div class="question-header">
            <div class="question-title">${question.id}. ${question.content}</div>
            <div class="question-info">
                <span>${question.type == 'judge' ? '判断题' : '单选题'}</span>
                <c:if test="${not empty question.clause}">
                    | 对应条款: ${question.clause}
                </c:if>
            </div>
        </div>
        
        <form id="answerForm">
            <input type="hidden" name="questionId" value="${question.id}">
            
            <div class="options">
                <c:forEach items="${options}" var="option" varStatus="status">
                    <div class="option ${question.userAnswer == option.key ? 'selected' : ''}">
                        <input type="radio" name="userAnswer" id="option-${option.key}" 
                               value="${option.key}" ${question.userAnswer == option.key ? 'checked' : ''}>
                        <label for="option-${option.key}" class="option-label">
                            <strong>${option.key}.</strong> ${option.value}
                        </label>
                    </div>
                </c:forEach>
            </div>
            
            <c:if test="${empty question.userAnswer}">
                <button type="submit" class="btn">提交答案</button>
            </c:if>
            <a href="/question/list" class="btn btn-back">返回列表</a>
        </form>
        
        <div id="result" class="result">
            <div class="result-header" id="resultHeader"></div>
            <div class="answer-info" id="answerInfo"></div>
        </div>
    </div>
    
    <script>
        // 选项点击效果
        document.querySelectorAll('.option').forEach(option => {
            option.addEventListener('click', function() {
                const radio = this.querySelector('input[type="radio"]');
                if (!radio.disabled) {
                    radio.checked = true;
                    
                    // 移除其他选项的选中状态
                    document.querySelectorAll('.option').forEach(opt => {
                        opt.classList.remove('selected');
                    });
                    
                    // 添加当前选项的选中状态
                    this.classList.add('selected');
                }
            });
        });
        
        // 表单提交
        document.getElementById('answerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const xhr = new XMLHttpRequest();
            
            xhr.open('POST', '/question/submit');
            xhr.onload = function() {
                if (xhr.status === 200) {
                    const result = JSON.parse(xhr.responseText);
                    const resultElement = document.getElementById('result');
                    const resultHeader = document.getElementById('resultHeader');
                    const answerInfo = document.getElementById('answerInfo');
                    
                    if (result.success) {
                        // 显示结果
                        resultElement.style.display = 'block';
                        
                        if (result.isCorrect) {
                            resultElement.className = 'result correct';
                            resultHeader.textContent = '回答正确！';
                        } else {
                            resultElement.className = 'result incorrect';
                            resultHeader.textContent = '回答错误！';
                        }
                        
                        answerInfo.textContent = '正确答案: ' + result.correctAnswer;
                        
                        // 禁用选项和提交按钮
                        document.querySelectorAll('input[type="radio"]').forEach(radio => {
                            radio.disabled = true;
                        });
                        
                        // 延迟刷新页面，显示结果
                        setTimeout(() => {
                            window.location.href = '/question/list';
                        }, 2000);
                    } else {
                        alert('提交失败: ' + result.message);
                    }
                }
            };
            
            xhr.send(formData);
        });
        
        // 如果已有答案，显示结果
        <c:if test="${not empty question.userAnswer}">
            const resultElement = document.getElementById('result');
            const resultHeader = document.getElementById('resultHeader');
            const answerInfo = document.getElementById('answerInfo');
            
            resultElement.style.display = 'block';
            
            if (${question.isCorrect}) {
                resultElement.className = 'result correct';
                resultHeader.textContent = '回答正确！';
            } else {
                resultElement.className = 'result incorrect';
                resultHeader.textContent = '回答错误！';
            }
            
            answerInfo.textContent = '您的答案: ${question.userAnswer} | 正确答案: ${question.answer}';
            
            // 禁用选项
            document.querySelectorAll('input[type="radio"]').forEach(radio => {
                radio.disabled = true;
            });
        </c:if>
    </script>
</body>
</html>