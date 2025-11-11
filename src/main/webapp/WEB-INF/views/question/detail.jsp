<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        h1 {
            color: #1a5276;
            text-align: center;
            margin-bottom: 30px;
        }
        .content-wrapper {
            display: flex;
            gap: 20px;
        }
        .question-container {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 30px;
            flex: 1;
        }
        .question-nav {
            width: 200px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 20px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        .nav-title {
            font-weight: bold;
            margin-bottom: 15px;
            color: #1a5276;
        }
        .nav-dots {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 8px;
        }
        .nav-dot {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #ecf0f1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            color: #7f8c8d;
            border: 2px solid transparent;
        }
        .nav-dot:hover {
            background-color: #3498db;
            color: white;
        }
        .nav-dot.current {
            background-color: #3498db;
            color: white;
            border-color: #2980b9;
        }
        .nav-dot.correct {
            background-color: #27ae60;
            color: white;
        }
        .nav-dot.incorrect {
            background-color: #e74c3c;
            color: white;
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
    
    <div class="content-wrapper">
        <div class="question-container">
        <div class="question-header">
            <div class="question-title">${question.id}. ${question.content}</div>
            <div class="question-info">
                <span>${question.type == 'judge' ? '判断题' : (question.type == 'multiple' ? '多选题' : '单选题')}</span>
                <c:if test="${not empty question.clause}">
                    | 对应条款: ${question.clause}
                </c:if>
            </div>
        </div>
        
        <form id="answerForm">
            <input type="hidden" name="questionId" value="${question.id}">
            
            <div class="options">
                <c:forEach items="${options}" var="option" varStatus="status">
                    <div class="option ${question.type == 'multiple' ? (fn:contains(question.userAnswer, option.key) ? 'selected' : '') : (question.userAnswer == option.key ? 'selected' : '')}">
                        <c:choose>
                            <c:when test="${question.type == 'multiple'}">
                                <input type="checkbox" name="userAnswers" id="option-${option.key}" 
                                       value="${option.key}" ${fn:contains(question.userAnswer, option.key) ? 'checked' : ''}>
                            </c:when>
                            <c:otherwise>
                                <input type="radio" name="userAnswer" id="option-${option.key}" 
                                       value="${option.key}" ${question.userAnswer == option.key ? 'checked' : ''}>
                            </c:otherwise>
                        </c:choose>
                        <label for="option-${option.key}" class="option-label">
                            <c:set var="optionText" value="${option.value}" />
                            <c:if test="${fn:startsWith(optionText, option.key) and fn:endsWith(fn:substring(optionText, 0, 2), '.')}">
                                ${fn:substring(optionText, 2, fn:length(optionText))}
                            </c:if>
                            <c:if test="${not (fn:startsWith(optionText, option.key) and fn:endsWith(fn:substring(optionText, 0, 2), '.'))}">
                                ${optionText}
                            </c:if>
                        </label>
                    </div>
                </c:forEach>
            </div>
            
            <!-- 导航按钮组 -->
            <div style="display: flex; gap: 10px; align-items: center;">
                <a id="prevQuestion" href="#" class="btn">上一题</a>
                
                <c:if test="${empty question.userAnswer}">
                    <button type="submit" class="btn">提交答案</button>
                </c:if>
                
                <a id="nextQuestion" href="#" class="btn">下一题</a>
                <a href="/question/list" class="btn btn-back">返回列表</a>
            </div>
        </form>
        
        <div id="result" class="result">
            <div class="result-header" id="resultHeader"></div>
            <div class="answer-info" id="answerInfo"></div>
        </div>
        </div>
        
        <div class="question-nav">
            <div class="nav-title">题目导航</div>
            <div class="nav-dots">
                <c:forEach items="${questions}" var="q">
                    <a href="/question/detail/${q.id}" 
                       class="nav-dot 
                              ${q.id == question.id ? 'current' : ''} 
                              ${not empty q.userAnswer ? (q.isCorrect ? 'correct' : 'incorrect') : ''}">
                        ${q.id}
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>
    
    <script>
        // 选项点击效果
        document.querySelectorAll('.option').forEach(option => {
            option.addEventListener('click', function(e) {
                const input = this.querySelector('input[type="radio"], input[type="checkbox"]');
                if (!input.disabled) {
                    // 阻止事件冒泡，避免标签点击和div点击冲突
                    if (e.target !== input && e.target.tagName !== 'LABEL') {
                        input.checked = !input.checked;
                    }
                    
                    if (input.type === 'radio') {
                        // 单选题：移除其他选项的选中状态
                        document.querySelectorAll('.option').forEach(opt => {
                            opt.classList.remove('selected');
                        });
                        // 添加当前选项的选中状态
                        this.classList.add('selected');
                    } else {
                        // 多选题：切换当前选项的选中状态
                        this.classList.toggle('selected', input.checked);
                    }
                }
            });
        });
        
        // 表单提交
        document.getElementById('answerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 判断是否为多选题
            const isMultipleChoice = '${question.type}' === 'multiple';
            const formData = new FormData();
            formData.append('questionId', document.querySelector('input[name="questionId"]').value);
            
            if (isMultipleChoice) {
                // 多选题：收集所有选中的选项
                const selectedOptions = [];
                document.querySelectorAll('input[name="userAnswers"]:checked').forEach(checkbox => {
                    selectedOptions.push(checkbox.value);
                });
                
                // 按字母顺序排序并拼接成字符串
                selectedOptions.sort();
                formData.append('userAnswer', selectedOptions.join(''));
                
                // 检查是否至少选择了一个选项
                if (selectedOptions.length === 0) {
                    alert('请至少选择一个选项');
                    return;
                }
            } else {
                // 单选题和判断题：直接获取选中的值
                const userAnswer = document.querySelector('input[name="userAnswer"]:checked');
                if (!userAnswer) {
                    alert('请选择一个选项');
                    return;
                }
                formData.append('userAnswer', userAnswer.value);
            }
            
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
                        document.querySelectorAll('input[type="radio"], input[type="checkbox"]').forEach(input => {
                            input.disabled = true;
                        });
                        
                        // 不需要自动重定向，让用户可以查看结果并自行决定下一步操作
                    } else {
                        alert('提交失败: ' + result.message);
                    }
                }
            };
            
            xhr.send(formData);
        });
        
        // 如果已有答案，显示结果
        <c:if test="${not empty question.userAnswer}">
            <script>
            const resultElement = document.getElementById('result');
            const resultHeader = document.getElementById('resultHeader');
            const answerInfo = document.getElementById('answerInfo');
            
            resultElement.style.display = 'block';
            
            if (<c:out value="${question.isCorrect}" />) {
                resultElement.className = 'result correct';
                resultHeader.textContent = '回答正确！';
            } else {
                resultElement.className = 'result incorrect';
                resultHeader.textContent = '回答错误！';
            }
            
            answerInfo.textContent = '您的答案: <c:out value="${question.userAnswer}" /> | 正确答案: <c:out value="${question.answer}" />';
            
            // 禁用选项
            document.querySelectorAll('input[type="radio"], input[type="checkbox"]').forEach(input => {
                input.disabled = true;
            });
            </script>
        </c:if>
        
        // 上一题和下一题功能
        document.addEventListener('DOMContentLoaded', function() {
            // 获取所有题目的ID
            const questionIds = [];
            <c:forEach items="${questions}" var="q">
                questionIds.push(${q.id});
            </c:forEach>
            
            // 找到当前题目的索引
            const currentQuestionId = ${question.id};
            const currentIndex = questionIds.indexOf(currentQuestionId);
            
            // 设置上一题和下一题链接
            const prevBtn = document.getElementById('prevQuestion');
            const nextBtn = document.getElementById('nextQuestion');
            
            // 如果没有上一题，禁用上一题按钮
            if (currentIndex <= 0) {
                prevBtn.href = '#';
                prevBtn.style.backgroundColor = '#bdc3c7';
                prevBtn.style.cursor = 'not-allowed';
                prevBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                });
            } else {
                prevBtn.href = '/question/detail/' + questionIds[currentIndex - 1];
            }
            
            // 如果没有下一题，禁用下一题按钮
            if (currentIndex >= questionIds.length - 1) {
                nextBtn.href = '#';
                nextBtn.style.backgroundColor = '#bdc3c7';
                nextBtn.style.cursor = 'not-allowed';
                nextBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                });
            } else {
                nextBtn.href = '/question/detail/' + questionIds[currentIndex + 1];
            }
        });
    </script>
</body>
</html>