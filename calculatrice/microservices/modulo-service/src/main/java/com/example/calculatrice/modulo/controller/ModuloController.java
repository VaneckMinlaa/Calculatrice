package com.example.calculatrice.modulo.controller;

import com.example.calculatrice.commons.dto.CalculationRequest;
import com.example.calculatrice.commons.dto.CalculationResponse;
import com.example.calculatrice.modulo.service.ModuloService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/modulo")
public class ModuloController {

    @Autowired
    private ModuloService moduloService;

    @PostMapping
    public ResponseEntity<CalculationResponse> modulo(@RequestBody CalculationRequest request) {
        try {
            Double result = moduloService.modulo(request.getA(), request.getB());
            CalculationResponse response = new CalculationResponse(result, null, "MODULO");
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            CalculationResponse errorResponse = new CalculationResponse(null, "Error: " + e.getMessage(), "MODULO");
            return ResponseEntity.badRequest().body(errorResponse);
        } catch (Exception e) {
            CalculationResponse errorResponse = new CalculationResponse(null, "Error: " + e.getMessage(), "MODULO");
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
}

