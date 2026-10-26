class_name ObjetoAntifuego extends Node2D

# ATRIBUTO DEL EXTINTOR
@export_range(0,3) var cargas: int = 3

# ATRIBUTO UML
var cargasOtorgadas: int:
	get:
		return cargas

# POSICIÓN
@export var gridX: int = 0
@export var gridY: int = 0
var recolectado: bool = false

@onready var imagen: Sprite2D = $Sprite2D

const EXTINTOR_LLENO = preload("res://Extintor_Lleno.png")
const EXTINTOR_EN_USO = preload("res://Extintor_EnUso.png")
const EXTINTOR_VACIO = preload("res://Extintor_Vacio.png")

#CONSTRUCTOR
func _init(p_grid_x:int=0, p_grid_y:int=0,p_cargas_otorgadas:int=3) -> void:
	gridX=p_grid_x
	gridY=p_grid_y
	cargas=clampi(p_cargas_otorgadas,0,3)
	recolectado=false
	

func _ready() -> void:
	actualizar_imagen()
	actualizar_posicion_pantalla()

# --- Lógica de Posicionamiento Físico en la Grilla ---
func actualizar_posicion_pantalla() -> void:
	position = Vector2(
		50.0 + (gridX * 26.0) + 13.0,
		32.0 + (gridY * 26.0) + 13.0
	)

func actualizar_imagen() -> void:
	if cargas == 3:
		imagen.texture = EXTINTOR_LLENO
	elif cargas > 0:
		imagen.texture = EXTINTOR_EN_USO
	else:
		imagen.texture = EXTINTOR_VACIO

func consumir_carga() -> bool:
	if cargas > 0:
		cargas -= 1
		actualizar_imagen()
		print("Cargas restante: ", cargas)
		return true
	else:
		print("El extintor está vacío.")
		return false 

func getGridX() -> int:
	return gridX

# Sincronización de setters para la grilla
func setGridX(x: int) -> void:
	gridX = x
	actualizar_posicion_pantalla()

func setGridx(x: int) -> void: # Mantener compatibilidad por si se llama en minúscula
	setGridX(x)

func getGridY() -> int:
	return gridY

func setGridY(y: int) -> void:
	gridY = y
	actualizar_posicion_pantalla()

func isRecolectado() -> bool:
	return recolectado

func setRecolectado(valor: bool) -> void:
	recolectado = valor

func alInteractuar(jugador: Jugador) -> void:
	if recolectado or cargas <= 0:
		return
	if jugador == null:
		return
	if jugador.has_method("recolectar_extintor_escenario"):
		jugador.recolectar_extintor_escenario(self)
		print("Cargas del jugador: ", jugador.getCargasExtintor())
		if cargas == 0:
			setRecolectado(true)
			$Area2D.set_deferred("monitoring", false)
			hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Se detectó colisión con: ", body.name)
	if body is Jugador:
		print("¡Extintor encontrado!")
		alInteractuar(body)
