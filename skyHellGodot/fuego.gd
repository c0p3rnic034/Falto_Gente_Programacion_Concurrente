class_name Fuego
extends Area2D

# --- Constantes de Desplazamiento Visual (Grid) ---
# Sincronizadas con las medidas de Escenario y Jugador
const TILE_SIZE_X: int = 26
const TILE_SIZE_Y: int = 26
const OFFSET_X: int = 50
const OFFSET_Y: int = 32

# --- Atributos Base UML ---
@export var gridX: int = 0
@export var gridY: int = 0
@export var velocidadAvance: float = 2.0 # Tiempo en segundos (Lento)
var activo: bool = true

@onready var timer_propagacion: Timer = $TimerPropagacion

func _ready() -> void:
	# Sincroniza el tiempo del nodo Timer con la variable para controlar la velocidad
	if timer_propagacion:
		timer_propagacion.wait_time = velocidadAvance
		
	actualizar_posicion_pantalla()

# --- Lógica de Posicionamiento Físico ---
func actualizar_posicion_pantalla() -> void:
	# Centrado exacto alineado con el Jugador y el Escenario
	position = Vector2(
		OFFSET_X + (gridX * TILE_SIZE_X) + (TILE_SIZE_X / 2.0),
		OFFSET_Y + (gridY * TILE_SIZE_Y) + (TILE_SIZE_Y / 2.0)
	)

# --- Lógica de Propagación (Expansión) ---
func _on_timer_propagacion_timeout() -> void:
	expandir_fuego()

func expandir_fuego() -> void:
	if not activo:
		return
	
	# Direcciones posibles: abajo, arriba, derecha, izquierda
	var direcciones = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
	
	# Elige una dirección al azar para propagarse
	var direccion_aleatoria = direcciones[randi() % direcciones.size()]
	
	var nuevo_x: int = gridX + int(direccion_aleatoria.x)
	var nuevo_y: int = gridY + int(direccion_aleatoria.y)
	
	# Valida que el fuego no se expanda fuera del avión (Límites: X 0-5, Y 0-6)
	if nuevo_x >= 0 and nuevo_x <= 5 and nuevo_y >= 0 and nuevo_y <= 6:
		# Crea una nueva instancia de la escena del fuego
		var escena_fuego = load("res://Fuego.tscn")
		if escena_fuego:
			var nuevo_fuego = escena_fuego.instantiate()
			# Le asigna la nueva posición en la cuadrícula
			nuevo_fuego.gridX = nuevo_x
			nuevo_fuego.gridY = nuevo_y
			nuevo_fuego.velocidadAvance = self.velocidadAvance
			
			# Añade el nuevo fuego al mismo contenedor (Escenario o CapaEntidades)
			get_parent().add_child(nuevo_fuego)

# --- Interacción con el Extintor ---
func extinguir() -> void:
	activo = false
	if timer_propagacion:
		timer_propagacion.stop()
	
	# Desactiva colisiones instantáneamente para evitar dañar al jugador al morir
	set_deferred("monitoring", false) 
	queue_free() # Elimina el fuego del escenario

# --- Daño al Jugador ---
func _on_body_entered(body: Node2D) -> void:
	# El body detectado debe ser el Jugador y tener el método recibir_dano
	if activo and body is Jugador:
		if body.has_method("recibir_dano"):
			body.recibir_dano(20.0) 
			print("El jugador se quemó. Salud actual: ", body.salud_oxigeno)

# --- Getters y Setters requeridos por Escenario/UML ---
func getGridX() -> int:
	return gridX

func setGridX(x: int) -> void:
	gridX = x
	actualizar_posicion_pantalla()

func getGridY() -> int:
	return gridY

# El escenario llama a este método para empujar el fuego hacia abajo con el scroll
func setGridY(y: int) -> void:
	gridY = y
	actualizar_posicion_pantalla()
	
	# Eliminar el fuego si el scroll lo empuja fuera de la pantalla (más allá de Y=6)
	if gridY > 6:
		queue_free()

func getActivo() -> bool:
	return activo

func setActivo(p_activo: bool) -> void:
	activo = p_activo

func getVelocidadAvance() -> float:
	return velocidadAvance

func setVelocidadAvance(vel: float) -> void:
	velocidadAvance = vel
	if timer_propagacion:
		timer_propagacion.wait_time = velocidadAvance
