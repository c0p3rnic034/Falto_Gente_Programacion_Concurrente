package com.skyhell.entities;


public class Fuego {

    private int gridX;
    private float gridY;
    private float velocidadAvance;
    private boolean activo;

    public Fuego(int gridX, float startY, float velocidadAvance) {
        this.gridX = gridX;
        this.gridY = startY;
        this.velocidadAvance = velocidadAvance;
        this.activo = true;
    }

     
    public void avanzar() {

    }

    public void extinguir() {

    }

    public boolean alcanzoAJugador(int jugadorY) {

    }

    public int getGridX() { return gridX; }
    public float getGridY() { return gridY; }
    public boolean getActivo() { return activo; }
    public float getVelocidadAvance() {return velocidadAvance;}
    public void setVelocidadAvance(float velocidadAvance) { this.velocidadAvance = velocidadAvance; }
    public void setActivo(boolean a) {activo=a;}
    public void setGridX(int x) {gridX=x;}
    public void setGridY(int y) {gridY=y;}
}