package com.example.calculatrice.division.service;

import org.springframework.stereotype.Service;

@Service
public class DivisionService {

    public Double divide(Double a, Double b) {
        if (b == 0) {
            throw new IllegalArgumentException("Cannot divide by zero");
        }
        return a / b;
    }
}
