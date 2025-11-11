-- 修改用户答题记录表结构（单用户模式）
USE dati;

-- 1. 先创建临时表存储数据
CREATE TABLE IF NOT EXISTS user_answers_temp (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    question_id INT NOT NULL COMMENT '题目ID',
    user_answer VARCHAR(10) COMMENT '用户答案',
    is_correct BOOLEAN COMMENT '是否正确',
    answer_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '答题时间',
    UNIQUE KEY uk_question (question_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户答题记录表临时表';

-- 2. 从旧表复制数据到临时表（保留每个题目的最新答案）
-- 使用子查询找到每个题目的最新答案记录
INSERT INTO user_answers_temp (question_id, user_answer, is_correct, answer_time)
SELECT ua.question_id, ua.user_answer, ua.is_correct, ua.answer_time
FROM user_answers ua
JOIN (
    SELECT question_id, MAX(answer_time) as max_time
    FROM user_answers
    GROUP BY question_id
) latest ON ua.question_id = latest.question_id AND ua.answer_time = latest.max_time;

-- 3. 删除旧表
DROP TABLE IF EXISTS user_answers;

-- 4. 重命名临时表为正式表
ALTER TABLE user_answers_temp RENAME TO user_answers;

-- 5. 添加外键约束
ALTER TABLE user_answers
ADD FOREIGN KEY (question_id) REFERENCES questions(id);

-- 6. 添加注释
ALTER TABLE user_answers
MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
MODIFY COLUMN question_id INT NOT NULL COMMENT '题目ID',
MODIFY COLUMN user_answer VARCHAR(10) COMMENT '用户答案',
MODIFY COLUMN is_correct BOOLEAN COMMENT '是否正确',
MODIFY COLUMN answer_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '答题时间';

-- 7. 添加唯一索引，确保每个题目只有一条记录
ALTER TABLE user_answers
ADD UNIQUE KEY uk_question (question_id);

-- 更新表注释
ALTER TABLE user_answers
COMMENT='用户答题记录表（单用户模式）';