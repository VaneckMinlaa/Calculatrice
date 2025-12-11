package com.example.calculatrice.subtraction.service;

import org.springframework.stereotype.Service;

@Service
public class SubtractionService {

    public Double subtract(Double a, Double b) {
        return a - b;
    }
}
