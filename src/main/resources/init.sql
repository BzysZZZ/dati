-- 创建数据库
CREATE DATABASE IF NOT EXISTS dati DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE dati;

-- 创建题目表
CREATE TABLE IF NOT EXISTS questions (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '题目ID',
    content TEXT NOT NULL COMMENT '题目内容',
    options TEXT COMMENT '选项，以JSON格式存储',
    answer VARCHAR(10) NOT NULL COMMENT '正确答案',
    type VARCHAR(10) NOT NULL COMMENT '题目类型：single（单选题）或judge（判断题）',
    clause VARCHAR(500) COMMENT '对应条款',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题目表';

-- 创建用户答题记录表
CREATE TABLE IF NOT EXISTS user_answers (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    user_id VARCHAR(50) NOT NULL COMMENT '用户ID',
    question_id INT NOT NULL COMMENT '题目ID',
    user_answer VARCHAR(10) COMMENT '用户答案',
    is_correct BOOLEAN COMMENT '是否正确',
    answer_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '答题时间',
    FOREIGN KEY (question_id) REFERENCES questions(id),
    UNIQUE KEY uk_user_question (user_id, question_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户答题记录表';

-- 插入一些示例数据
INSERT INTO questions (content, options, answer, type, clause) VALUES
('中国共产党的最高理想和最终目标是实现____。',
 '{"A":"共同富裕","B":"社会主义","C":"共产主义","D":"中华民族伟大复兴"}',
 'C', 'single', '《中国共产党章程》总纲'),
('中国共产党党员必须全心全意为人民服务。',
 '{"A":"正确","B":"错误"}',
 'A', 'judge', '《中国共产党章程》第一章第二条'),
('中国共产党的党徽为____和____组成的图案。',
 '{"A":"镰刀 锤子","B":"镰刀 斧头","C":"锤头 斧头","D":"麦穗 锤子"}',
 'A', 'single', '《中国共产党章程》党徽党旗');