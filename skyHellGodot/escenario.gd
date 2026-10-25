extends Node2D

const TILE_SIZE_X: int = 26
const TILE_SIZE_Y: int = 32
const OFFSET_X: int = 50
const OFFSET_Y: int = 32

@onready var piso_pasillo: TextureRect = $PISO
@onready var capa_entidades: Node2D = $capadeentidades

@export var velocidad_avance: float = 12.0 # Velocidad de avance (px/s)
var scroll_pixel_y: float = 0.0

func _ready() -> void:
	if piso_pasillo:
		piso_pasillo.position = Vector2(OFFSET_X, OFFSET_Y)
		piso_pasillo.size = Vector2(156, 224) # 6 columnas * 26px = 156px
		piso_pasillo.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED

func _process(delta: float) -> void:
	if piso_pasillo == null or capa_entidades == null:
		return

	# Avanza el acumulador en píxeles reales
	scroll_pixel_y += velocidad_avance * delta

	# Mueve sincrónicamente la capa del personaje
	capa_entidades.position.y = scroll_pixel_y

	# Mueve la textura del Shader a la misma velocidad
	if piso_pasillo.material:
		piso_pasillo.material.set_shader_parameter("offset_y", scroll_pixel_y / float(TILE_SIZE_Y))

	# Reinicio del acumulador al completar 1 celda vertical (32px)
	if scroll_pixel_y >= TILE_SIZE_Y:
		scroll_pixel_y -= TILE_SIZE_Y
		capa_entidades.position.y = scroll_pixel_y
		_empujar_entidades_abajo()

func _empujar_entidades_abajo() -> void:
	for entidad in capa_entidades.get_children():
		if entidad.has_method("getGridY") and entidad.has_method("setGridY"):
			entidad.setGridY(entidad.getGridY() + 1)
