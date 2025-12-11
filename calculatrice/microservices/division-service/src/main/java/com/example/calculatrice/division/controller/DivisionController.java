package com.example.calculatrice.division.controller;

import com.example.calculatrice.commons.dto.CalculationRequest;
import com.example.calculatrice.commons.dto.CalculationResponse;
import com.example.calculatrice.division.service.DivisionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/divide")
public class DivisionController {

    @Autowired
    private DivisionService divisionService;

    @PostMapping
    public ResponseEntity<CalculationResponse> divide(@RequestBody CalculationRequest request) {
        try {
            Double result = divisionService.divide(request.getA(), request.getB());
            CalculationResponse response = new CalculationResponse(result, null, "DIVISION");
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            CalculationResponse errorResponse = new CalculationResponse(null, "Error: " + e.getMessage(), "DIVISION");
            return ResponseEntity.badRequest().body(errorResponse);
        } catch (Exception e) {
            CalculationResponse errorResponse = new CalculationResponse(null, "Error: " + e.getMessage(), "DIVISION");
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
}

