package com.example.calculatrice.addition.controller;

import com.example.calculatrice.commons.dto.CalculationRequest;
import com.example.calculatrice.commons.dto.CalculationResponse;
import com.example.calculatrice.addition.service.AdditionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/add")
public class AdditionController {

    @Autowired
    private AdditionService additionService;

    @PostMapping
    public ResponseEntity<CalculationResponse> add(@RequestBody CalculationRequest request) {
        try {
            Double result = additionService.add(request.getA(), request.getB());
            CalculationResponse response = new CalculationResponse(result, null, "ADDITION");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            CalculationResponse errorResponse = new CalculationResponse(null, "Error: " + e.getMessage(), "ADDITION");
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
}

