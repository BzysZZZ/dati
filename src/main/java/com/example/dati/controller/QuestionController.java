package com.example.dati.controller;

import com.example.dati.pojo.Question;
import com.example.dati.service.QuestionService;
import com.example.dati.utils.DocumentParser;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 题目控制器
 */
@Controller
@RequestMapping("/question")
public class QuestionController {

    @Autowired
    private QuestionService questionService;

    /**
     * 首页，显示题目列表
     * @param model 模型
     * @param session 会话
     * @return 视图名
     */
    @GetMapping("/list")
    public String listQuestions(Model model, HttpSession session) {
        // 获取用户ID（这里简化处理，使用session ID作为用户标识）
        String userId = session.getId();
        
        // 获取所有题目及用户答题记录
        List<Question> questions = questionService.getUserAnswers(userId);
        
        // 统计用户答题情况
        int[] stats = questionService.getUserAnswerStats(userId);
        
        model.addAttribute("questions", questions);
        model.addAttribute("totalCount", stats[0]);
        model.addAttribute("answeredCount", stats[1]);
        model.addAttribute("correctCount", stats[2]);
        
        return "question/list";
    }

    /**
     * 显示题目详情
     * @param id 题目ID
     * @param model 模型
     * @param session 会话
     * @return 视图名
     */
    @GetMapping("/detail/{id}")
    public String questionDetail(@PathVariable("id") Integer id, Model model, HttpSession session) {
        String userId = session.getId();
        
        // 获取题目信息
        Question question = questionService.getQuestionById(id);
        
        // 获取用户答题记录
        List<Question> userAnswers = questionService.getUserAnswers(userId);
        for (Question q : userAnswers) {
            if (q.getId().equals(id)) {
                question.setUserAnswer(q.getUserAnswer());
                question.setIsCorrect(q.getIsCorrect());
                break;
            }
        }
        
        // 解析选项
        try {
            ObjectMapper mapper = new ObjectMapper();
            Map<String, String> options = mapper.readValue(question.getOptions(), Map.class);
            model.addAttribute("options", options);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        model.addAttribute("question", question);
        
        return "question/detail";
    }

    /**
     * 提交答案
     * @param questionId 题目ID
     * @param userAnswer 用户答案
     * @param session 会话
     * @return 结果JSON
     */
    @PostMapping("/submit")
    @ResponseBody
    public Map<String, Object> submitAnswer(@RequestParam("questionId") Integer questionId, 
                                           @RequestParam("userAnswer") String userAnswer, 
                                           HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        String userId = session.getId();
        
        try {
            boolean isCorrect = questionService.submitAnswer(userId, questionId, userAnswer);
            result.put("success", true);
            result.put("isCorrect", isCorrect);
            
            // 获取正确答案
            Question question = questionService.getQuestionById(questionId);
            result.put("correctAnswer", question.getAnswer());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "提交答案失败：" + e.getMessage());
        }
        
        return result;
    }

    /**
     * 显示导入页面
     * @return 视图名
     */
    @GetMapping("/import")
    public String importPage() {
        return "question/import";
    }

    /**
     * 导入题目文件 - 优化版，支持大型文件导入
     * @param file 上传的文件
     * @param model 模型
     * @return 视图名
     */
    @PostMapping("/import")
    public String importQuestions(@RequestParam("file") MultipartFile file, Model model) {
        if (file.isEmpty()) {
            model.addAttribute("message", "请选择要上传的文件");
            return "question/import";
        }
        
        // 检查文件大小
        if (file.getSize() > 50 * 1024 * 1024) { // 50MB
            model.addAttribute("message", "文件过大，请上传小于50MB的文档");
            return "question/import";
        }
        
        // 记录开始时间
        long startTime = System.currentTimeMillis();
        
        try {
            // 生成唯一的文件名
            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
            String filePath = "D:\\temp\\" + fileName;
            File dest = new File(filePath);
            
            // 确保临时目录存在
            if (!dest.getParentFile().exists()) {
                if (!dest.getParentFile().mkdirs()) {
                    model.addAttribute("message", "创建临时目录失败");
                    return "question/import";
                }
            }
            
            // 保存上传的文件
            file.transferTo(dest);
            model.addAttribute("importProgress", "文件上传完成，开始解析...");
            
            // 解析文件
            List<Question> questions = DocumentParser.parseDocument(filePath);
            model.addAttribute("importProgress", "文档解析完成，共解析出 " + questions.size() + " 道题目");
            
            // 分批导入题目
            if (questions.size() > 0) {
                int totalQuestions = questions.size();
                int batchSize = 50; // 每批导入50道题
                int importedCount = 0;
                
                // 分批处理
                for (int i = 0; i < totalQuestions; i += batchSize) {
                    int end = Math.min(i + batchSize, totalQuestions);
                    List<Question> batch = questions.subList(i, end);
                    
                    // 导入批次
                    questionService.batchAddQuestions(batch);
                    importedCount += batch.size();
                    
                    // 更新进度信息
                    int progress = (int) ((double) importedCount / totalQuestions * 100);
                    model.addAttribute("importProgress", "正在保存题目：" + importedCount + "/" + totalQuestions + " (" + progress + "%)");
                }
                
                // 计算耗时
                long endTime = System.currentTimeMillis();
                long duration = (endTime - startTime) / 1000;
                
                model.addAttribute("message", "成功导入 " + importedCount + " 道题目，耗时 " + duration + " 秒");
                model.addAttribute("importSuccess", true);
            } else {
                model.addAttribute("message", "未从文件中解析出题目");
            }
            
            // 确保删除临时文件
            try {
                if (dest.exists() && !dest.delete()) {
                    System.out.println("警告：无法删除临时文件: " + filePath);
                }
            } catch (Exception e) {
                System.out.println("删除临时文件时出错: " + e.getMessage());
            }
            
        } catch (IOException e) {
            model.addAttribute("message", "文件处理失败：" + e.getMessage());
            e.printStackTrace();
        } catch (OutOfMemoryError e) {
            model.addAttribute("message", "内存不足，请尝试更小的文件或增加JVM内存");
            e.printStackTrace();
        } catch (Exception e) {
            model.addAttribute("message", "导入失败：" + e.getMessage());
            e.printStackTrace();
        }
        
        return "question/import";
    }

    /**
     * 显示结果统计页面
     * @param model 模型
     * @param session 会话
     * @return 视图名
     */
    @GetMapping("/stats")
    public String statistics(Model model, HttpSession session) {
        String userId = session.getId();
        
        // 获取统计信息
        int[] stats = questionService.getUserAnswerStats(userId);
        
        model.addAttribute("totalCount", stats[0]);
        model.addAttribute("answeredCount", stats[1]);
        model.addAttribute("correctCount", stats[2]);
        
        // 计算正确率
        double correctRate = stats[1] > 0 ? (double) stats[2] / stats[1] * 100 : 0;
        model.addAttribute("correctRate", String.format("%.2f", correctRate));
        
        return "question/stats";
    }
}