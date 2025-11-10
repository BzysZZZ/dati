package com.example.dati;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.example.dati.mapper")
public class DatiApplication {

    public static void main(String[] args) {
        SpringApplication.run(DatiApplication.class, args);
    }

}