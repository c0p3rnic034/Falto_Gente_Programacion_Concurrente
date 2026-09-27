package com.skyhell.core;

import com.skyhell.entities.Fuego;
import com.skyhell.entities.Jugador;
import com.skyhell.items.ObjetoAntifuego;
import com.skyhell.world.Escenario;


  //Controlador global que coordina la actualización del juego y la puntuación.
 
public class JuegoManager {

    private int distanciaRecorrida;
    private int puntosPorFuego;
    private int puntuacionTotal;
    private EstadoJuego estado;

    private final Jugador jugador;
    private final Fuego fuegoPerseguidor;
    private final Escenario escenario;

    public JuegoManager() {
        this.escenario = new Escenario(5); // Avión con 5 columnas de ancho
        this.jugador = new Jugador(2, 0);   // Inicia en columna central (2), fila 0
        this.fuegoPerseguidor = new Fuego(2, -2.0f, 0.10f); // Muro detrás del jugador
        this.distanciaRecorrida = 0;
        this.puntosPorFuego = 0;
        this.puntuacionTotal = 0;
        this.estado = EstadoJuego.JUGANDO;
    }

    /**
     * Bucle de actualización principal por fotograma/ciclo.
     */
    public void actualizar() {
        if (estado != EstadoJuego.JUGANDO) return;

        // 1. Avanzar muro de fuego inferior
        fuegoPerseguidor.avanzar();

        // 2. Calcular distancia recorrida (1 metro = 1 punto)
        if (jugador.getGridY() > distanciaRecorrida) {
            distanciaRecorrida = jugador.getGridY();
        }

        // 3. Detectar interacciones en la casilla del jugador
        int x = jugador.getGridX();
        int y = jugador.getGridY();
        int tipoCasilla = escenario.getCasilla(x, y);

        if (tipoCasilla == Escenario.EXTINTOR) {
            ObjetoAntifuego extintor = new ObjetoAntifuego(x, y, 3);
            extintor.alInteractuar(jugador);
            escenario.setCasilla(x, y, Escenario.PASILLO); // Retirar item recolectado
            System.out.println("¡Extintor recogido! Cargas actuales: " + jugador.getCargasExtintor());
        } else if (tipoCasilla == Escenario.FUEGO) {
            // El jugador pisó fuego sin apagarlo
            jugador.setEstaVivo(false);
        }

        // 4. checar condiciones de fin de juego
        verificarEstado();
    }

    
      //Acción manual para apagar la casilla directamente al frente del jugador.
    
    public void accionarExtintorFrontal() {
        int xFrontal = jugador.getGridX();
        int yFrontal = jugador.getGridY() + 1;

        if (escenario.getCasilla(xFrontal, yFrontal) == Escenario.FUEGO) {
            Fuego fuegoCasilla = new Fuego(xFrontal, yFrontal, 0);
            if (jugador.usarExtintor(fuegoCasilla)) {
                escenario.setCasilla(xFrontal, yFrontal, Escenario.PASILLO);
                sumarPuntosExtincion();
                System.out.println("¡Fuego apagado! +10 puntos. Cargas restantes: " + jugador.getCargasExtintor());
            }
        }
    }

    public void sumarPuntosExtincion() {
        this.puntosPorFuego += 10;
    }

    public void verificarEstado() {
        if (!jugador.isEstaVivo() || fuegoPerseguidor.alcanzoAJugador(jugador.getGridY())) {
            this.estado = EstadoJuego.GAME_OVER;
            jugador.setEstaVivo(false);
        }
    }

    public int obtenerPuntuacionTotal() {
        this.puntuacionTotal = distanciaRecorrida + puntosPorFuego;
        return puntuacionTotal;
    }

    // Getters
    public Jugador getJugador() { return jugador; }
    public Escenario getEscenario() { return escenario; }
    public EstadoJuego getEstado() { return estado; }
    public int getDistanciaRecorrida() { return distanciaRecorrida; }
    public int getPuntosPorFuego() { return puntosPorFuego; }
}