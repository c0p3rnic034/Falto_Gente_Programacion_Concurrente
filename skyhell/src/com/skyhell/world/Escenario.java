package com.skyhell.world;

import java.util.ArrayList;
import java.util.List;



public class Escenario {

    private int anchoGrid;
    private List<int[]> matrizCasillas;

    // 0 = Pasillo Libre | 1 = Asiento/Obstáculo | 2 = Fuego Estático | 3 = Extintor
    private static int PASILLO = 0;
    private static int OBSTACULO = 1;
    private static int FUEGO = 2;
    private static int EXTINTOR = 3;

    public Escenario(int anchoGrid) {
        this.anchoGrid = anchoGrid;
        this.matrizCasillas = new ArrayList<>();

        for (int i = 0; i < 10; i++) {
            generarSiguienteFila();
        }
    }
     
    public void generarSiguienteFila() {

    }

    public boolean esTransitable(int x, int y) {

    }

    public int getCasilla(int x, int y) {

    }

    public void setCasilla(int x, int y, int valor) {

    }

    public int getAnchoGrid() {return anchoGrid;}

    public void setAnchoGrid(int anchoGrid) {this.anchoGrid = anchoGrid;}

    public List<int[]> getMatrizCasillas() {return matrizCasillas;}

    public void setMatrizCasillas(List<int[]> matrizCasillas) {this.matrizCasillas = matrizCasillas;}

    public int getPasillo(){return PASILLO;}
    public int getFuego(){return FUEGO;}
    public int getExtintor(){return EXTINTOR;}
    public int getObstaculo(){return OBSTACULO;}
}
