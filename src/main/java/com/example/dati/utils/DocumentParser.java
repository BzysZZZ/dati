package com.example.dati.utils;

import com.example.dati.pojo.Question;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.usermodel.Range;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.logging.Logger;

/**
 * Word文档解析工具类 - 优化版，支持大型文档解析
 */
public class DocumentParser {

    private static final Logger logger = Logger.getLogger(DocumentParser.class.getName());
    private static final int BATCH_SIZE = 50; // 每批处理的题目数量

    /**
     * 解析Word文档
     * @param filePath 文件路径
     * @return 题目列表
     * @throws IOException IO异常
     */
    public static List<Question> parseDocument(String filePath) throws IOException {
        logger.info("开始解析文档: " + filePath);
        List<Question> questions = new ArrayList<>();
        String content = "";

        // 根据文件扩展名选择不同的解析方式
        if (filePath.endsWith(".docx")) {
            content = parseDocx(filePath);
        } else if (filePath.endsWith(".doc")) {
            content = parseDoc(filePath);
        } else {
            throw new IllegalArgumentException("不支持的文件格式，请上传.doc或.docx格式的文档");
        }

        // 解析题目（使用优化的分批处理方式）
        questions = parseQuestions(content);
        logger.info("文档解析完成，共解析出 " + questions.size() + " 道题目");

        return questions;
    }

    /**
     * 解析.docx文件 - 优化版
     * @param filePath 文件路径
     * @return 文件内容
     * @throws IOException IO异常
     */
    private static String parseDocx(String filePath) throws IOException {
        StringBuilder content = new StringBuilder();
        int paragraphCount = 0;
        
        try (FileInputStream fis = new FileInputStream(filePath);
             XWPFDocument document = new XWPFDocument(fis)) {
            
            logger.info("开始读取docx文档内容");
            for (XWPFParagraph paragraph : document.getParagraphs()) {
                String text = paragraph.getText().trim();
                if (!text.isEmpty()) {
                    content.append(text).append("\n");
                }
                paragraphCount++;
                
                // 每处理100段进行一次日志记录
                if (paragraphCount % 100 == 0) {
                    logger.info("已处理 " + paragraphCount + " 段内容");
                }
            }
        }
        
        logger.info("docx文档读取完成，共读取 " + paragraphCount + " 段内容");
        return content.toString();
    }

    /**
     * 解析.doc文件 - 优化版
     * @param filePath 文件路径
     * @return 文件内容
     * @throws IOException IO异常
     */
    private static String parseDoc(String filePath) throws IOException {
        StringBuilder content = new StringBuilder();
        
        try (FileInputStream fis = new FileInputStream(filePath);
             HWPFDocument document = new HWPFDocument(fis)) {
            
            logger.info("开始读取doc文档内容");
            Range range = document.getRange();
            String text = range.text();
            
            // 分段处理大型文档内容
            if (text.length() > 100000) {
                logger.info("文档较大，开始分段处理");
                int chunkSize = 100000;
                for (int i = 0; i < text.length(); i += chunkSize) {
                    int end = Math.min(i + chunkSize, text.length());
                    content.append(text.substring(i, end));
                    logger.info("已处理文档片段: " + i/1024 + "KB - " + end/1024 + "KB");
                }
            } else {
                content.append(text);
            }
        }
        
        logger.info("doc文档读取完成");
        return content.toString();
    }

    /**
     * 解析题目内容 - 优化版，支持大型内容解析
     * @param content 文档内容
     * @return 题目列表
     */
    private static List<Question> parseQuestions(String content) {
        List<Question> questions = new ArrayList<>();
        
        logger.info("开始解析题目内容");

        // 替换空白字符为空格
        content = content.replaceAll("\\s+", " ").trim();
        logger.info("文档预处理完成，长度: " + content.length() + " 字符");

        // 预编译正则表达式，提高性能
        Pattern questionPattern = Pattern.compile("(\\d+)\\.(.*?)(?=答案：|对应条款：)");
        Pattern answerPattern = Pattern.compile("答案：(.*?)(?=\\d+\\.|对应条款：|$)");
        Pattern clausePattern = Pattern.compile("对应条款：(.*?)(?=\\d+\\.|$)");
        Pattern optionPattern = Pattern.compile("([A-Z])\\.([^A-Z]*?)(?=([A-Z])\\.|答案：|对应条款：|$)");

        Matcher questionMatcher = questionPattern.matcher(content);
        int questionCount = 0;
        
        while (questionMatcher.find()) {
            try {
                Question question = new Question();
                
                // 解析题目内容
                String questionContent = questionMatcher.group(2).trim();
                question.setContent(questionContent);

                // 查找答案
                int startIndex = questionMatcher.end();
                Matcher answerMatcher = answerPattern.matcher(content.substring(startIndex));
                if (answerMatcher.find()) {
                    String answer = answerMatcher.group(1).trim();
                    question.setAnswer(answer);
                }

                // 查找对应条款
                Matcher clauseMatcher = clausePattern.matcher(content.substring(startIndex));
                if (clauseMatcher.find()) {
                    String clause = clauseMatcher.group(1).trim();
                    question.setClause(clause);
                }

                // 判断题目类型并设置选项
                Map<String, String> optionsMap = new HashMap<>();
                if (questionContent.contains("正确") && questionContent.contains("错误")) {
                    question.setType("judge"); // 判断题
                    // 为判断题设置默认的正确和错误选项
                    optionsMap.put("A", "正确");
                    optionsMap.put("B", "错误");
                    // 处理答案，确保与选项匹配
                    String answer = question.getAnswer();
                    if (answer != null) {
                        if (answer.contains("√") || answer.contains("正确")) {
                            question.setAnswer("A");
                        } else if (answer.contains("×") || answer.contains("错误")) {
                            question.setAnswer("B");
                        }
                    }
                } else if (questionContent.contains("多选题") || questionContent.contains("多选")) {
                    question.setType("multiple"); // 多选题
                    // 解析选项
                    optionsMap = parseOptions(content.substring(questionMatcher.start(), startIndex), optionPattern);
                    // 多选题答案可能是多个选项，例如 "ABCD" 或 "A,B,C,D"
                    String answer = question.getAnswer();
                    if (answer != null) {
                        // 标准化答案格式，移除空格和逗号，确保是大写字母
                        answer = answer.replaceAll("[\s,]", "").toUpperCase();
                        question.setAnswer(answer);
                    }
                } else {
                    question.setType("single"); // 单选题
                    // 解析选项 - 优化处理方式
                    optionsMap = parseOptions(content.substring(questionMatcher.start(), startIndex), optionPattern);
                }
                
                // 将选项转换为JSON格式
                question.setOptions(convertOptionsToJson(optionsMap));

                questions.add(question);
                questionCount++;
                
                // 每处理指定数量的题目进行一次内存优化
                if (questionCount % BATCH_SIZE == 0) {
                    logger.info("已解析 " + questionCount + " 道题目");
                    // 触发垃圾回收（如果需要）
                    if (questionCount % (BATCH_SIZE * 5) == 0) {
                        System.gc();
                    }
                }
            } catch (Exception e) {
                logger.warning("解析题目时出错: " + e.getMessage() + "，跳过该题目");
                // 记录错误位置，但继续处理其他题目
                continue;
            }
        }

        logger.info("题目解析完成，共解析出 " + questions.size() + " 道题目");
        return questions;
    }
    
    /**
     * 优化的选项解析方法
     */
    private static Map<String, String> parseOptions(String content, Pattern optionPattern) {
        Map<String, String> optionsMap = new HashMap<>();
        Matcher optionMatcher = optionPattern.matcher(content);
        
        while (optionMatcher.find()) {
            String key = optionMatcher.group(1);
            String value = optionMatcher.group(2).trim();
            optionsMap.put(key, value);
        }
        
        return optionsMap;
    }
    
    /**
     * 优化的JSON转换方法
     */
    private static String convertOptionsToJson(Map<String, String> optionsMap) {
        if (optionsMap.isEmpty()) {
            return "{}";
        }
        
        StringBuilder optionsJson = new StringBuilder("{");
        boolean first = true;
        
        for (Map.Entry<String, String> entry : optionsMap.entrySet()) {
            if (!first) {
                optionsJson.append(",");
            }
            optionsJson.append('"').append(entry.getKey()).append('"')
                      .append(':')
                      .append('"').append(escapeJsonString(entry.getValue())).append('"');
            first = false;
        }
        
        optionsJson.append('}');
        return optionsJson.toString();
    }
    
    /**
     * 转义JSON字符串中的特殊字符
     */
    private static String escapeJsonString(String input) {
        if (input == null) return "";
        return input.replace("\"", "\\\"").replace("\\", "\\\\")
                   .replace("\n", "\\n").replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}