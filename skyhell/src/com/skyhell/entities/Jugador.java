package com.skyhell.entities;

import com.skyhell.world.Escenario;

 
public class Jugador {

    private int gridX;
    private int gridY;
    private int cargasExtintor;
    private boolean estaVivo;

    public Jugador(int startX, int startY) {
        this.gridX = startX;
        this.gridY = startY;
        this.cargasExtintor = 0;
        this.estaVivo = true;
    }

     
    public void mover(int deltaX, int deltaY, Escenario escenario) {

    }

    
     
    public boolean usarExtintor(Fuego fuegoObjetivo) {

    }

     
    public void recogerExtintor(int cargas) {

    }

    public int getGridX() { return gridX; }
    public int getGridY() { return gridY; }
    public int getCargasExtintor() { return cargasExtintor; }
    public boolean getEstaVivo() { return estaVivo; }
    public void setEstaVivo(boolean estaVivo) { this.estaVivo = estaVivo; }
    public void setGridX(int x) { gridX=x; }
    public void setGridY(int y) { gridY=y; }
    public void setCargasExtintor(int c) {cargasExtintor=c;}
}