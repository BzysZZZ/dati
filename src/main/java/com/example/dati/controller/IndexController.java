package com.example.dati.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 首页控制器
 */
@Controller
public class IndexController {

    /**
     * 访问根路径时重定向到题目列表
     * @return 重定向地址
     */
    @GetMapping("/")
    public String index() {
        return "redirect:/question/list";
    }
}