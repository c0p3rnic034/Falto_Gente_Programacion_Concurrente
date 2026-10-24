class_name Jugador
extends CharacterBody2D

# --- Señales de Sistema y Puntuación ---
signal puntos_obtenidos(cantidad: int)
signal jugador_murio()

# --- Constantes de Desplazamiento Visual (Grid 256x240) ---
# OFFSET_X ajustado a 50px para centrar 6 columnas de 26px (156px jugables)
const OFFSET_X: int = 50
const OFFSET_Y: int = 32

# --- Atributos Base UML ---
var _grid_x: int = 2
var _grid_y: int = 5
var _cargas_extintor: int = 0
var _esta_vivo: bool = true

# --- Configuración Visual y del Escenario ---
# Ancho de casilla corregido a 26px (alto se mantiene en 32px)
@export var tamano_celda: Vector2 = Vector2(26, 32)
@export var escenario: Node

# --- Atributos de Salud y Estamina ---
@export var salud_oxigeno: float = 100.0
@export var estamina: float = 100.0


# --- Constructor e Inicialización ---
func _init(start_x: int = 2, start_y: int = 5) -> void:
	_grid_x = start_x
	_grid_y = start_y
	_cargas_extintor = 0
	_esta_vivo = true


func _ready() -> void:
	if escenario == null:
		escenario = get_tree().current_scene
	actualizar_posicion_pantalla()


# --- Bucle de Actualización e Input ---
func _process(_delta: float) -> void:
	if not _esta_vivo:
		return
	_procesar_entrada()


## Captura las pulsaciones de teclado en el fotograma exacto
func _procesar_entrada() -> void:
	if Input.is_action_just_pressed("ui_up"):
		mover(0, -1)
	elif Input.is_action_just_pressed("ui_down"):
		mover(0, 1)
	elif Input.is_action_just_pressed("ui_left"):
		mover(-1, 0)
	elif Input.is_action_just_pressed("ui_right"):
		mover(1, 0)


func mover(delta_x: int, delta_y: int, p_escenario: Object = null) -> void:
	if not _esta_vivo:
		return
	
	var nuevo_x: int = _grid_x + delta_x
	var nuevo_y: int = _grid_y + delta_y
	
	# Permite exactamente 6 columnas (0 a 5) y 7 filas (0 a 6)
	if nuevo_x < 0 or nuevo_x > 5 or nuevo_y < 0 or nuevo_y > 6:
		return
	
	var objetivo_escenario = p_escenario if p_escenario != null else escenario
	
	if objetivo_escenario != null and objetivo_escenario.has_method("esTransitable"):
		if not objetivo_escenario.esTransitable(nuevo_x, nuevo_y):
			return # Celda bloqueada por obstáculo
			
	_grid_x = nuevo_x
	_grid_y = nuevo_y
	actualizar_posicion_pantalla()


func actualizar_posicion_pantalla() -> void:
	var objetivo_escenario = escenario
	if objetivo_escenario != null and objetivo_escenario.has_method("grid_a_pixel"):
		position = objetivo_escenario.grid_a_pixel(_grid_x, _grid_y)
	else:
		# Centrado exacto: Offset_X (50px) + (Columna * 26px) + 13px
		position = Vector2(
			OFFSET_X + (_grid_x * tamano_celda.x) + (tamano_celda.x / 2.0),
			OFFSET_Y + (_grid_y * tamano_celda.y) + (tamano_celda.y / 2.0)
		)


func usarExtintor(fuego_objetivo: Object) -> bool:
	if not _esta_vivo or _cargas_extintor <= 0:
		return false
	
	if fuego_objetivo != null and fuego_objetivo.has_method("extinguir"):
		fuego_objetivo.extinguir()
		_cargas_extintor -= 1
		puntos_obtenidos.emit(10)
		return true
		
	return false


## Recoge cargas para el extintor de incendios
func recogerExtintor(cargas: int) -> void:
	if _esta_vivo and cargas > 0:
		_cargas_extintor += cargas


## Aplica daño al jugador reduciendo la barra de salud/oxígeno
func recibir_dano(cantidad: float) -> void:
	if not _esta_vivo:
		return
		
	salud_oxigeno -= cantidad
	if salud_oxigeno <= 0.0:
		salud_oxigeno = 0.0
		_esta_vivo = false
		jugador_murio.emit()


func recolectar_extintor_escenario(extintor: ObjetoAntifuego) -> void:
	if extintor == null:
		return
		
	var cargas_recolectadas: int = 0
	while extintor.cargas > 0:
		if extintor.consumir_carga():
			cargas_recolectadas += 1
			
	if cargas_recolectadas > 0:
		recogerExtintor(cargas_recolectadas)


# --- Getters y Setters Requeridos por el UML ---

func getGridX() -> int:
	return _grid_x

func setGridX(x: int) -> void:
	_grid_x = x
	actualizar_posicion_pantalla()

func getGridY() -> int:
	return _grid_y

func setGridY(y: int) -> void:
	_grid_y = y
	if _grid_y > 6:
		_grid_y = 6
	actualizar_posicion_pantalla()

func getCargasExtintor() -> int:
	return _cargas_extintor

func setCargasExtintor(c: int) -> void:
	_cargas_extintor = c

func getEstaVivo() -> bool:
	return _esta_vivo

func setEstaVivo(p_esta_vivo: bool) -> void:
	_esta_vivo = p_esta_vivo
