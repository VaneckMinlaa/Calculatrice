package com.example.calculatrice.commons.dto;

import java.io.Serializable;

public class CalculationResponse implements Serializable {
    private static final long serialVersionUID = 1L;

    private Double result;
    private String error;
    private String operationType;

    public CalculationResponse() {
    }

    public CalculationResponse(Double result, String error) {
        this.result = result;
        this.error = error;
    }

    public CalculationResponse(Double result, String error, String operationType) {
        this.result = result;
        this.error = error;
        this.operationType = operationType;
    }

    public Double getResult() {
        return result;
    }

    public void setResult(Double result) {
        this.result = result;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public String getOperationType() {
        return operationType;
    }

    public void setOperationType(String operationType) {
        this.operationType = operationType;
    }

    @Override
    public String toString() {
        return "CalculationResponse{" +
                "result=" + result +
                ", error='" + error + '\'' +
                ", operationType='" + operationType + '\'' +
                '}';
    }
}
