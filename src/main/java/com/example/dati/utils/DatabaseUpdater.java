package com.example.dati.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Logger;

/**
 * 数据库结构更新工具类
 */
public class DatabaseUpdater {
    private static final Logger logger = Logger.getLogger(DatabaseUpdater.class.getName());
    
    // 数据库连接信息
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/dati?useUnicode=true&characterEncoding=utf8mb4&serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "root";
    
    /**
     * 更新数据库表结构，将clause列长度从100改为500
     */
    public static void updateDatabaseSchema() {
        Connection conn = null;
        Statement stmt = null;
        
        try {
            // 加载驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 建立连接
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            stmt = conn.createStatement();
            
            // 执行修改表结构的SQL语句 - 同时更新answer和clause列
            String sql1 = "ALTER TABLE questions MODIFY COLUMN answer VARCHAR(50) NOT NULL COMMENT '正确答案';";
            String sql2 = "ALTER TABLE questions MODIFY COLUMN clause VARCHAR(1000) COMMENT '对应条款';";
            
            stmt.executeUpdate(sql1);
            stmt.executeUpdate(sql2);
            
            logger.info("数据库表结构更新成功：answer列长度已修改为50，clause列长度已修改为1000");
            System.out.println("数据库表结构更新成功：answer列长度已修改为50，clause列长度已修改为1000");
            
        } catch (Exception e) {
            logger.severe("更新数据库表结构失败：" + e.getMessage());
            e.printStackTrace();
        } finally {
            // 关闭资源
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * 主方法，用于直接运行更新
     */
    public static void main(String[] args) {
        updateDatabaseSchema();
    }
}