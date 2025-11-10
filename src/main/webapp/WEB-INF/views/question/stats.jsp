<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>答题统计 - 党纪题库自测系统</title>
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
        .stats-container {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .stats-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .stats-header h2 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .stats-cards {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }
        .stat-card {
            flex: 1;
            min-width: 180px;
            margin: 10px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 5px;
            text-align: center;
            border-top: 3px solid #3498db;
        }
        .stat-card.total {
            border-top-color: #3498db;
        }
        .stat-card.answered {
            border-top-color: #27ae60;
        }
        .stat-card.correct {
            border-top-color: #f39c12;
        }
        .stat-value {
            font-size: 36px;
            font-weight: bold;
            margin: 10px 0;
        }
        .stat-label {
            font-size: 16px;
            color: #7f8c8d;
        }
        .progress-container {
            margin: 20px 0;
        }
        .progress-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-weight: bold;
        }
        .progress-bar {
            height: 20px;
            background-color: #ecf0f1;
            border-radius: 10px;
            overflow: hidden;
            position: relative;
        }
        .progress-fill {
            height: 100%;
            background-color: #3498db;
            border-radius: 10px;
            transition: width 1s ease;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-top: 20px;
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
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }
        .empty-state h3 {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <h1>答题统计</h1>
    
    <div class="stats-container">
        <c:if test="${totalCount > 0}">
            <div class="stats-header">
                <h2>您的答题情况</h2>
                <p>以下是您的答题统计数据，继续努力！</p>
            </div>
            
            <div class="stats-cards">
                <div class="stat-card total">
                    <div class="stat-label">总题数</div>
                    <div class="stat-value">${totalCount}</div>
                </div>
                <div class="stat-card answered">
                    <div class="stat-label">已答题数</div>
                    <div class="stat-value">${answeredCount}</div>
                </div>
                <div class="stat-card correct">
                    <div class="stat-label">正确题数</div>
                    <div class="stat-value">${correctCount}</div>
                </div>
            </div>
            
            <div class="progress-container">
                <div class="progress-header">
                    <span>答题进度</span>
                    <span>${answeredCount}/${totalCount} (${answeredCount * 100 / totalCount}%)</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: ${answeredCount * 100 / totalCount}%"></div>
                </div>
            </div>
            
            <div class="progress-container">
                <div class="progress-header">
                    <span>正确率</span>
                    <span>${correctRate}%</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: ${correctRate}%; background-color: #27ae60;"></div>
                </div>
            </div>
            
            <div style="text-align: center;">
                <a href="/question/list" class="btn">继续答题</a>
            </div>
        </c:if>
        
        <c:if test="${totalCount == 0}">
            <div class="empty-state">
                <h3>暂无题目数据</h3>
                <p>请先导入题目文件，然后开始答题</p>
                <a href="/question/import" class="btn">导入题目</a>
            </div>
        </c:if>
    </div>
    
    <script>
        // 添加页面加载动画效果
        window.onload = function() {
            setTimeout(function() {
                document.querySelectorAll('.progress-fill').forEach(function(fill) {
                    const width = fill.style.width;
                    fill.style.width = '0';
                    setTimeout(function() {
                        fill.style.width = width;
                    }, 100);
                });
            }, 100);
        };
    </script>
</body>
</html>