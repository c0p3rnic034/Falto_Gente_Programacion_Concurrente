package com.skyhell;

import com.skyhell.core.EstadoJuego;
import com.skyhell.core.JuegoManager;

public class Main {

    public static void main(String[] args) {
        System.out.println("===========================================");
        System.out.println("       SKYHELL - PROTOCOLO ETAPA I          ");
        System.out.println("===========================================\n");

        JuegoManager juego = new JuegoManager();

        System.out.println("Posición inicial del piloto: (" + juego.getJugador().getGridX() + ", " + juego.getJugador().getGridY() + ")");
        System.out.println("Estado inicial: " + juego.getEstado() + "\n");

        // Simular secuencia de movimiento hacia adelante (Arriba = deltaY +1)
        for (int paso = 1; paso <= 5; paso++) {
            System.out.println("--- Paso " + paso + " ---");
            
            // Intentar usar extintor si hay fuego al frente
            juego.accionarExtintorFrontal();

            // Avanzar hacia arriba
            juego.getJugador().mover(0, 1, juego.getEscenario());
            juego.actualizar();

            System.out.println("Posición Piloto: (" + juego.getJugador().getGridX() + ", " + juego.getJugador().getGridY() + ")");
            System.out.println("Metros avanzados: " + juego.getDistanciaRecorrida() + " m");
            System.out.println("Puntos totales acumulados: " + juego.obtenerPuntuacionTotal() + " pts");

            if (juego.getEstado() == EstadoJuego.GAME_OVER) {
                System.out.println("\n¡EL PILOTO HA SIDO ALCANZADO POR EL FUEGO! GAME OVER.");
                break;
            }
        }
    }
}
