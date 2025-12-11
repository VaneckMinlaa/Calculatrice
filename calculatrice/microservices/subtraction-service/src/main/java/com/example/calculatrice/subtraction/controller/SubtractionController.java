package com.example.calculatrice.subtraction.controller;

import com.example.calculatrice.commons.dto.CalculationRequest;
import com.example.calculatrice.commons.dto.CalculationResponse;
import com.example.calculatrice.subtraction.service.SubtractionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/subtract")
public class SubtractionController {

    @Autowired
    private SubtractionService subtractionService;

    @PostMapping
    public ResponseEntity<CalculationResponse> subtract(@RequestBody CalculationRequest request) {
        try {
            Double result = subtractionService.subtract(request.getA(), request.getB());
            CalculationResponse response = new CalculationResponse(result, null, "SUBTRACTION");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            CalculationResponse errorResponse = new CalculationResponse(null, "Error: " + e.getMessage(),
                    "SUBTRACTION");
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
}

