class_name Jugador
extends CharacterBody2D

signal puntos_obtenidos(cantidad: int)
signal jugador_murio()
signal intentar_apagar_fuego(col: int, fila: int)

const TILE_SIZE: float = 26.0
const OFFSET_X: float = 50.0
const OFFSET_Y: float = 32.0
const TIEMPO_SALTO: float = 0.08

# Delimitación rígida de la cuadrícula estática 6x7
const MIN_COL: int = 0
const MAX_COL: int = 5
const MIN_FILA: int = 0
const MAX_FILA: int = 6

var grid_x: int = 2
var grid_y: int = 5
var _saltando: bool = false
var _esta_vivo: bool = true

# Variable de salud/oxígeno (Compatibilidad con Fuego)
var salud_oxigeno: float = 100.0

# Variable de cargas (Compatibilidad con ObjetoAntifuego)
var cargas_extintor: int = 0

func _ready() -> void:
	grid_x = 2
	grid_y = 5
	position = calcular_posicion_local(grid_x, grid_y)

func _input(event: InputEvent) -> void:
	if not _esta_vivo or _saltando:
		return

	# Movimiento por casillas
	if event.is_action_pressed("ui_up"):
		intentar_salto(-1, 0)
	elif event.is_action_pressed("ui_down"):
		intentar_salto(1, 0)
	elif event.is_action_pressed("ui_left"):
		intentar_salto(0, -1)
	elif event.is_action_pressed("ui_right"):
		intentar_salto(0, 1)
	# Acción de apagar fuego (Barra Espaciadora / Enter)
	elif event.is_action_pressed("ui_accept"):
		usar_extintor()

func intentar_salto(delta_fila: int, delta_col: int) -> void:
	var nueva_col: int = grid_x + delta_col
	var nueva_fila: int = grid_y + delta_fila

	if nueva_col < MIN_COL or nueva_col > MAX_COL:
		return
	if nueva_fila < MIN_FILA or nueva_fila > MAX_FILA:
		return

	grid_x = nueva_col
	grid_y = nueva_fila

	_saltando = true
	var destino: Vector2 = calcular_posicion_local(grid_x, grid_y)

	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "position", destino, TIEMPO_SALTO)
	tween.parallel().tween_property(self, "scale", Vector2(1.15, 1.15), TIEMPO_SALTO * 0.5)
	tween.chain().tween_property(self, "scale", Vector2(1.0, 1.0), TIEMPO_SALTO * 0.5)

	await tween.finished
	_saltando = false

func calcular_posicion_local(col: int, fila: int) -> Vector2:
	var px: float = OFFSET_X + (col * TILE_SIZE) + (TILE_SIZE / 2.0)
	var py: float = OFFSET_Y + (fila * TILE_SIZE) + (TILE_SIZE / 2.0)
	return Vector2(px, py)

# --- Métodos del Extintor y Disparo ---
func usar_extintor() -> void:
	if cargas_extintor > 0:
		intentar_apagar_fuego.emit(grid_x, grid_y)
	else:
		print("¡No tienes cargas de extintor!")

func consumir_una_carga() -> void:
	if cargas_extintor > 0:
		cargas_extintor -= 1
		print("Carga usada. Cargas restantes del jugador: ", cargas_extintor)

func getCargasExtintor() -> int:
	return cargas_extintor

func recolectar_extintor_escenario(extintor: ObjetoAntifuego) -> void:
	if extintor:
		cargas_extintor += extintor.cargas
		extintor.cargas = 0
		extintor.actualizar_imagen()
		print("¡Cargas obtenidas! Cargas totales del jugador: ", cargas_extintor)

# --- Métodos de Daño y Muerte ---
func recibir_dano(cantidad: float) -> void:
	if not _esta_vivo:
		return
	
	salud_oxigeno -= cantidad
	print("El jugador se quemó. Salud actual: ", salud_oxigeno)
	
	if salud_oxigeno <= 0.0:
		morir
func morir() -> void:
	if not _esta_vivo:
		return
	
	_esta_vivo = false
	if has_signal("jugador_murio"):
		jugador_murio.emit()
	print("JUGADOR MUERTO")

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
