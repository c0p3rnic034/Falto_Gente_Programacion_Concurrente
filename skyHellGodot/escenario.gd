extends Node2D

# --- Variables Exportadas (Inspector) ---
@export var escena_fuego: PackedScene
@export var escena_objeto_antifuego: PackedScene

# --- Constantes de la Cuadrícula Estática (6x7) ---
const TILE_SIZE: float = 26.0
const OFFSET_X: float = 50.0
const OFFSET_Y: float = 32.0
const ALTO_PASILLO: float = 182.0

# --- Referencias a Nodos ---
@onready var piso_pasillo: TextureRect = $PISO
@onready var pared_izq: TextureRect = $PARED_IZQ
@onready var pared_der: TextureRect = $PARED_DER
@onready var capa_entidades: Node2D = $capadeentidades

func _ready() -> void:
	# 1. Configuración visual de fondos
	_configurar_fondo(piso_pasillo, Vector2(OFFSET_X, OFFSET_Y), Vector2(156, ALTO_PASILLO))
	_configurar_fondo(pared_izq, Vector2(0, OFFSET_Y), Vector2(50, ALTO_PASILLO))
	_configurar_fondo(pared_der, Vector2(206, OFFSET_Y), Vector2(50, ALTO_PASILLO))

	# 2. Posición estática de capa de entidades
	if capa_entidades:
		capa_entidades.position = Vector2.ZERO
	_fijar_shader_offset(0.0)

	# 3. Instanciar objetos de prueba
	crear_fuego_en(2, 3)          # Fuego en Columna 2, Fila 3
	crear_extintor_en(2, 4)       # Extintor en Columna 2, Fila 4

	# 4. Conectar señal de apagar fuego desde el Jugador
	var jugador = capa_entidades.get_node_or_null("Jugador")
	if not jugador:
		jugador = get_node_or_null("Jugador")
		
	if jugador and jugador.has_signal("intentar_apagar_fuego"):
		if not jugador.intentar_apagar_fuego.is_connected(_on_jugador_intentar_apagar_fuego):
			jugador.intentar_apagar_fuego.connect(_on_jugador_intentar_apagar_fuego)

func _configurar_fondo(nodo: TextureRect, pos: Vector2, tam: Vector2) -> void:
	if nodo:
		nodo.position = pos
		nodo.size = tam
		nodo.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED

func _fijar_shader_offset(val: float) -> void:
	if piso_pasillo and piso_pasillo.material:
		piso_pasillo.material.set_shader_parameter("offset_y", val)
	if pared_izq and pared_izq.material:
		pared_izq.material.set_shader_parameter("offset_y", val)
	if pared_der and pared_der.material:
		pared_der.material.set_shader_parameter("offset_y", val)

func grid_a_posicion_local(col: int, fila: int) -> Vector2:
	var px: float = OFFSET_X + (col * TILE_SIZE) + (TILE_SIZE / 2.0)
	var py: float = OFFSET_Y + (fila * TILE_SIZE) + (TILE_SIZE / 2.0)
	return Vector2(px, py)

func instanciar_objeto_en_grid(escena_objeto: PackedScene, col: int, fila: int) -> Node2D:
	if escena_objeto == null or capa_entidades == null:
		return null
	var instancia = escena_objeto.instantiate()
	instancia.position = grid_a_posicion_local(col, fila)
	capa_entidades.add_child(instancia)
	return instancia

# --- Funciones Auxiliares de Creación ---
func crear_fuego_en(col: int, fila: int) -> void:
	if escena_fuego:
		var fuego = instanciar_objeto_en_grid(escena_fuego, col, fila) as Fuego
		if fuego:
			fuego.setGridX(col)
			fuego.setGridY(fila)

func crear_extintor_en(col: int, fila: int) -> void:
	if escena_objeto_antifuego:
		var extintor = instanciar_objeto_en_grid(escena_objeto_antifuego, col, fila) as ObjetoAntifuego
		if extintor:
			extintor.setGridX(col)
			extintor.setGridY(fila)

# --- Lógica de Extinción de Fuego ---
func apagar_fuego_en(col: int, fila: int) -> bool:
	if capa_entidades == null:
		return false
		
	for nodo in capa_entidades.get_children():
		if nodo is Fuego:
			if nodo.getGridX() == col and nodo.getGridY() == fila:
				nodo.queue_free()
				print("¡Fuego extinguido en (", col, ", ", fila, ")!")
				return true
	return false

func _on_jugador_intentar_apagar_fuego(col: int, fila: int) -> void:
	var jugador = capa_entidades.get_node_or_null("Jugador")
	if not jugador:
		jugador = get_node_or_null("Jugador")

	if apagar_fuego_en(col, fila):
		if jugador and jugador.has_method("consumir_una_carga"):
			jugador.consumir_una_carga()
	else:
		print("No hay fuego en la casilla (", col, ", ", fila, ") para apagar.")
