package com.skyhell.items;

import com.skyhell.entities.Jugador;

public class ObjetoAntifuego{
    private int gridX;
    private int gridY;
    private int cargasOtorgadas;
    private boolean recolectado;

    public ObjetoAntifuego(int gridX, int gridY, int cargasOtorgadas){
        this.gridX=gridX;
        this.gridY=gridY;
        this.cargasOtorgadas=cargasOtorgadas;
        this.recolectado=false;
    }

    public void alInteractuar(Jugador j){

    }

    public int getGridX(){return gridX;}
    public int getGridY(){return gridY;}
    public boolean getRecolectado(){return recolectado;}
    public void setGridX(int dx){gridX=dx;}
    public void setGridY(int dy){gridY=dy;}
    public void setRecolectado(boolean rec){Recolectado=rec;}
}
