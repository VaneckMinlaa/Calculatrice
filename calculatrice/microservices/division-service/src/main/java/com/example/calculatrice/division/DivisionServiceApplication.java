package com.example.calculatrice.division;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@EnableDiscoveryClient
@SpringBootApplication
public class DivisionServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(DivisionServiceApplication.class, args);
    }
}

