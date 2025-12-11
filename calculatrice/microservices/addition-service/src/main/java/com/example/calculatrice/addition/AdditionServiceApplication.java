package com.example.calculatrice.addition;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@EnableDiscoveryClient
@SpringBootApplication
public class AdditionServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(AdditionServiceApplication.class, args);
    }
}

