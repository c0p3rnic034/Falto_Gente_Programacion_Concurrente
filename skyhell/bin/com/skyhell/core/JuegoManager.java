package com.skyhell.core;

import com.skyhell.entities.Fuego;
import com.skyhell.entities.Jugador;
import com.skyhell.items.ObjetoAntifuego;
import com.skyhell.world.Escenario;

 
public class JuegoManager {

    private int distanciaRecorrida;
    private int puntosPorFuego;
    private int puntuacionTotal;
    private EstadoJuego estado;

    private final Jugador jugador;
    private final Fuego fuegoPerseguidor;
    private final Escenario escenario;

    public JuegoManager() {
        this.escenario = new Escenario(5); 
        this.jugador = new Jugador(2, 0);   
        this.fuegoPerseguidor = new Fuego(2, -2.0f, 0.10f); 
        this.distanciaRecorrida = 0;
        this.puntosPorFuego = 0;
        this.puntuacionTotal = 0;
        this.estado = EstadoJuego.JUGANDO;
    }


    public void actualizar() {
       
    }

    public void accionarExtintorFrontal() {

    }

    public void sumarPuntosExtincion() {

    }

    public void verificarEstado() {
 
    }

    public int obtenerPuntuacionTotal() {

    }


    public Jugador getJugador() { return jugador; }
    public Escenario getEscenario() { return escenario; }
    public EstadoJuego getEstado() { return estado; }
    public int getDistanciaRecorrida() { return distanciaRecorrida; }
    public int getPuntosPorFuego() { return puntosPorFuego; }
    public Jugador setJugador(Jugador j) { jugador=j; }
    public Escenario setEscenario(Escenario e) { escenario=e; }
    public EstadoJuego setEstado(EstadoJuego st) {estado=st; }
    public int setDistanciaRecorrida(int d) {distanciaRecorrida=d; }
    public int setPuntosPorFuego(int p) { puntosPorFuego=p; }
}