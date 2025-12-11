package com.example.calculatrice.multiplication.service;

import org.springframework.stereotype.Service;

@Service
public class MultiplicationService {

    public Double multiply(Double a, Double b) {
        return a * b;
    }
}
