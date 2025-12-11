package com.example.calculatrice.modulo.service;

import org.springframework.stereotype.Service;

@Service
public class ModuloService {

    public Double modulo(Double a, Double b) {
        if (b == 0) {
            throw new IllegalArgumentException("Cannot perform modulo by zero");
        }
        return a % b;
    }
}
