# 党纪题库自测系统

## 项目简介

因为周三就要做纪律处分条例的考试了，支部只发了一个350题的题库。

150页的word啊得看看到啥时候。。。

不如做个答题系统事半功倍

## 技术栈

- **后端框架**：Spring + SpringMVC + MyBatis
- **前端技术**：HTML5 + CSS3 + JavaScript + JSP + JSTL
- **数据库**：MySQL 8.0
- **文档处理**：Apache POI 5.2.3（用于解析Word文档）
- **构建工具**：Maven

## 系统功能

1. **题库导入**：支持从Word文档（.doc/.docx）导入题目
2. **题目浏览**：查看所有题目列表和详情
3. **在线答题**：支持单选题和判断题的答题功能
4. **结果统计**：统计答题进度和正确率
5. **答题记录**：保存用户答题记录和结果

## 项目结构

```
src/
├── main/
│   ├── java/com/example/dati/
│   │   ├── controller/     # 控制器层
│   │   ├── mapper/         # MyBatis映射接口
│   │   ├── pojo/           # 实体类
│   │   ├── service/        # 业务逻辑层
│   │   │   └── impl/       # 业务逻辑实现
│   │   └── utils/          # 工具类
│   ├── resources/          # 资源文件
│   │   ├── mapper/         # MyBatis映射XML
│   │   ├── init.sql        # 数据库初始化脚本
│   │   └── jdbc.properties # 数据库配置
│   └── webapp/
│       └── WEB-INF/
│           ├── views/      # JSP视图
│           │   └── question/ # 题目相关视图
│           ├── applicationContext.xml # Spring配置
│           ├── spring-mvc.xml        # SpringMVC配置
│           └── web.xml               # Web应用配置
└── pom.xml                 # Maven项目配置
```

## 环境要求

- JDK 1.8+
- Maven 3.6+
- MySQL 8.0+
- Tomcat 9.0+

## 数据库配置

1. 创建数据库：`CREATE DATABASE dati CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
2. 执行初始化脚本：`src/main/resources/init.sql`
3. 配置数据库连接（修改`jdbc.properties`文件）

## 构建与运行

### 构建项目

```bash
mvn clean package
```

### 部署到Tomcat

1. 将生成的`dati.war`文件复制到Tomcat的`webapps`目录
2. 启动Tomcat服务器
3. 访问 `http://localhost:8080/dati`

## 使用说明

### 导入题目

1. 点击"导入题目"按钮
2. 选择符合格式要求的Word文档
3. 点击"导入题目"提交

### Word文档格式要求

- 题目格式：`题号. 题目内容`
- 选项格式：`A. 选项内容`，`B. 选项内容`等
- 答案格式：`答案：A` 或 判断题的 `答案：√`/`答案：×`
- 对应条款格式：`对应条款：《XXX》第X条`
- 判断题内容应包含"正确"和"错误"关键词

### 判断题格式更新

系统提供了自动更新判断题格式的功能，可以将数据库中的判断题答案从√/×符号转换为A/B格式，并为所有判断题添加标准选项：

1. 访问 `http://localhost:8800/question/update-judge`
2. 系统会自动更新所有判断题的格式
3. 查看更新结果页面的反馈信息
4. 更新完成后，所有判断题将显示正确的选项（A. 正确，B. 错误）

### 在线答题

1. 在题目列表中点击"答题"按钮
2. 选择答案并点击"提交答案"
3. 系统显示答题结果并自动跳转
4. 对于判断题，选择A表示正确，选择B表示错误

### 查看统计

1. 点击"查看统计"按钮
2. 查看答题进度和正确率统计

## 注意事项

1. 确保MySQL数据库已安装并正常运行
2. 导入的Word文档必须符合指定格式要求
3. 系统使用Session ID作为用户标识，刷新浏览器可能导致用户信息重置

## 扩展与维护

- 如需添加新题型，修改Question实体类和相应的视图文件
- 如需修改数据库连接信息，更新jdbc.properties文件
- 如需调整页面样式，修改对应的JSP文件
