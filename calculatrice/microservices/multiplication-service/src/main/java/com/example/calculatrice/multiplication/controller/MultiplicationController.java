package com.example.calculatrice.multiplication.controller;

import com.example.calculatrice.commons.dto.CalculationRequest;
import com.example.calculatrice.commons.dto.CalculationResponse;
import com.example.calculatrice.multiplication.service.MultiplicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/multiply")
public class MultiplicationController {

    @Autowired
    private MultiplicationService multiplicationService;

    @PostMapping
    public ResponseEntity<CalculationResponse> multiply(@RequestBody CalculationRequest request) {
        try {
            Double result = multiplicationService.multiply(request.getA(), request.getB());
            CalculationResponse response = new CalculationResponse(result, null, "MULTIPLICATION");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            CalculationResponse errorResponse = new CalculationResponse(null, "Error: " + e.getMessage(),
                    "MULTIPLICATION");
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
}

