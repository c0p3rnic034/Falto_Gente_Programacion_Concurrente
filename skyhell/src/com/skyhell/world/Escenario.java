package com.skyhell.world;

import java.util.ArrayList;
import java.util.List;


 //Genera la estructura del avión (filas, obstáculos e items). 

public class Escenario {

    private final int anchoGrid;
    private final List<int[]> matrizCasillas;

    // Códigos de casilla:
    // 0 = Pasillo Libre | 1 = Asiento/Obstáculo | 2 = Fuego Estático | 3 = Extintor
    public static final int PASILLO = 0;
    public static final int OBSTACULO = 1;
    public static final int FUEGO = 2;
    public static final int EXTINTOR = 3;

    public Escenario(int anchoGrid) {
        this.anchoGrid = anchoGrid;
        this.matrizCasillas = new ArrayList<>();

        // Generar 10 filas iniciales despejadas para el arranque
        for (int i = 0; i < 10; i++) {
            generarSiguienteFila();
        }
    }

    
     //Crea una nueva fila procedural con obstáculos, fuegos o extintores aleatorios.
     
    public void generarSiguienteFila() {
        int[] nuevaFila = new int[anchoGrid];
        int numFila = matrizCasillas.size();

        // Filas iniciales despejadas
        if (numFila < 3) {
            for (int i = 0; i < anchoGrid; i++) nuevaFila[i] = PASILLO;
        } else {
            for (int i = 0; i < anchoGrid; i++) {
                double rand = Math.random();
                if (rand < 0.15) {
                    nuevaFila[i] = OBSTACULO;
                } else if (rand < 0.22) {
                    nuevaFila[i] = FUEGO;
                } else if (rand < 0.26) {
                    nuevaFila[i] = EXTINTOR;
                } else {
                    nuevaFila[i] = PASILLO;
                }
            }
        }
        matrizCasillas.add(nuevaFila);
    }

    
      //Valida si la casilla de la retícula se puede pisar (no es obstáculo o fuera de mapa).
    
    public boolean esTransitable(int x, int y) {
        if (x < 0 || x >= anchoGrid) return false;

        while (y >= matrizCasillas.size()) {
            generarSiguienteFila();
        }
        return matrizCasillas.get(y)[x] != OBSTACULO;
    }

    public int getCasilla(int x, int y) {
        if (x < 0 || x >= anchoGrid || y < 0) return OBSTACULO;
        while (y >= matrizCasillas.size()) {
            generarSiguienteFila();
        }
        return matrizCasillas.get(y)[x];
    }

    public void setCasilla(int x, int y, int valor) {
        if (x >= 0 && x < anchoGrid && y >= 0 && y < matrizCasillas.size()) {
            matrizCasillas.get(y)[x] = valor;
        }
    }

    public List<int[]> getMatrizCasillas() { return matrizCasillas; }
}
