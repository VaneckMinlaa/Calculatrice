package com.example.calculatrice.commons.dto;

import java.io.Serializable;

public class CalculationRequest implements Serializable {
    private static final long serialVersionUID = 1L;

    private double a;
    private double b;

    public CalculationRequest() {
    }

    public CalculationRequest(double a, double b) {
        this.a = a;
        this.b = b;
    }

    public double getA() {
        return a;
    }

    public void setA(double a) {
        this.a = a;
    }

    public double getB() {
        return b;
    }

    public void setB(double b) {
        this.b = b;
    }

    @Override
    public String toString() {
        return "CalculationRequest{" +
                "a=" + a +
                ", b=" + b +
                '}';
    }
}
