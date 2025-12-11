package com.example.calculatrice.addition.service;

import org.springframework.stereotype.Service;

@Service
public class AdditionService {

    public Double add(Double a, Double b) {
        return a + b;
    }
}
