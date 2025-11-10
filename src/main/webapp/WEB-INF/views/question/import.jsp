<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>导入题目 - 党纪题库自测系统</title>
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
        .import-container {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        .file-input {
            display: block;
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #f9f9f9;
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
        .btn-primary {
            background-color: #27ae60;
        }
        .btn-primary:hover {
            background-color: #229954;
        }
        .btn-back {
            background-color: #7f8c8d;
        }
        .btn-back:hover {
            background-color: #6c757d;
        }
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-weight: bold;
        }
        .message-success {
            background-color: #d5f5e3;
            color: #27ae60;
            border-left: 4px solid #27ae60;
        }
        .message-error {
            background-color: #fdedec;
            color: #e74c3c;
            border-left: 4px solid #e74c3c;
        }
        .note {
            background-color: #f8f9fa;
            padding: 15px;
            border-left: 4px solid #f39c12;
            margin: 20px 0;
            border-radius: 0 4px 4px 0;
        }
        .note h3 {
            margin-top: 0;
            color: #d35400;
        }
        .note ul {
            margin-bottom: 0;
            padding-left: 20px;
        }
        .note li {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <h1>导入题目</h1>
    
    <div class="import-container">
        <c:if test="${not empty message}">
            <div class="message ${message.contains('成功') ? 'message-success' : 'message-error'}">
                ${message}
            </div>
        </c:if>
        
        <form action="/question/import" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="file" class="form-label">选择Word文档</label>
                <input type="file" id="file" name="file" class="file-input" accept=".doc,.docx" required>
            </div>
            
            <button type="submit" class="btn btn-primary">导入题目</button>
            <a href="/question/list" class="btn btn-back">返回列表</a>
        </form>
        
        <div class="note">
            <h3>文档格式说明：</h3>
            <ul>
                <li>支持的文件格式：.doc 和 .docx</li>
                <li>题目格式应为：<strong>题号. 题目内容</strong></li>
                <li>选项格式应为：<strong>A. 选项内容</strong>，<strong>B. 选项内容</strong> 等</li>
                <li>答案格式应为：<strong>答案：A</strong></li>
                <li>对应条款格式应为：<strong>对应条款：《XXX》第X条</strong></li>
                <li>判断题请将选项设置为 "A. 正确" 和 "B. 错误"</li>
            </ul>
        </div>
    </div>
    
    <script>
        // 文件选择验证
        document.getElementById('file').addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                const fileType = file.name.split('.').pop().toLowerCase();
                if (fileType !== 'doc' && fileType !== 'docx') {
                    alert('请选择.doc或.docx格式的文档');
                    this.value = '';
                }
            }
        });
    </script>
</body>
</html>