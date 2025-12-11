package com.example.calculatrice.subtraction;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@EnableDiscoveryClient
@SpringBootApplication
public class SubtractionServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(SubtractionServiceApplication.class, args);
    }
}

