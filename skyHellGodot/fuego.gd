class_name Fuego extends Node2D

signal extinguido

@export var intervalo_propagacion: float = 1.5
@export_range(0.0, 1.5) var probabilidad_propagacion: float = 0.5
@export var columnas: int = 16
@export var filas: int = 15

const TAMANO_CASILLA := 16
const DIRECCIONES: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

# Registro compartido de casillas en llamas (una sola llama por casilla)
static var celdas_en_llamas: Dictionary = {}

var celda: Vector2i
var activo: bool = true
var _escena: PackedScene

func _ready() -> void:
	celda = _a_celda(position)
	if _celda_ocupada(celda):
		queue_free()
		return
	celdas_en_llamas[celda] = self
	position = _centro_de(celda)
	if scene_file_path != "":
		_escena = load(scene_file_path) as PackedScene
	var timer := Timer.new()
	timer.wait_time = intervalo_propagacion
	timer.timeout.connect(propagar)
	add_child(timer)
	timer.start()

func _exit_tree() -> void:
	if celdas_en_llamas.get(celda) == self:
		celdas_en_llamas.erase(celda)

# Mismo nombre que en Java: un paso de avance del fuego
func avanzar() -> void:
	propagar()

func propagar() -> void:
	if not activo:
		return
	if _apagado_por_extintor():
		return
	var libres: Array[Vector2i] = []
	for d in DIRECCIONES:
		var vecina: Vector2i = celda + d
		if _es_permitida(vecina):
			libres.append(vecina)
	for v in libres:
		if randf() <= probabilidad_propagacion:
			_encender(v)

func extinguir() -> void:
	if not activo:
		return
	activo = false
	extinguido.emit()
	queue_free()

func ocupa_celda(c: Vector2i) -> bool:
	return activo and c == celda

func _apagado_por_extintor() -> bool:
	var padre := get_parent()
	if padre == null:
		return false
	for nodo in padre.get_children():
		if nodo is ObjetoAntifuego and nodo.cargas > 0:
			var c := _a_celda(nodo.position)
			if absi(c.x - celda.x) + absi(c.y - celda.y) <= 1:
				if nodo.consumir_carga():
					extinguir()
					return true
	return false

func _encender(c: Vector2i) -> void:
	if not _es_permitida(c):
		return
	var copia: Fuego
	if _escena != null:
		copia = _escena.instantiate() as Fuego
	else:
		copia = duplicate() as Fuego
	copia.intervalo_propagacion = intervalo_propagacion
	copia.probabilidad_propagacion = probabilidad_propagacion
	copia.columnas = columnas
	copia.filas = filas
	copia.position = _centro_de(c)
	get_parent().add_child(copia)

func _es_permitida(c: Vector2i) -> bool:
	if c.x < 0 or c.y < 0 or c.x >= columnas or c.y >= filas:
		return false
	if _celda_ocupada(c):
		return false
	for o in get_tree().get_nodes_in_group("obstaculo"):
		if o is Node2D and _a_celda(o.position) == c:
			return false
	return true

func _celda_ocupada(c: Vector2i) -> bool:
	return celdas_en_llamas.has(c) \
		and is_instance_valid(celdas_en_llamas[c]) \
		and celdas_en_llamas[c] != self

func _a_celda(p: Vector2) -> Vector2i:
	return Vector2i(floori(p.x / TAMANO_CASILLA), floori(p.y / TAMANO_CASILLA))

func _centro_de(c: Vector2i) -> Vector2:
	return Vector2(c * TAMANO_CASILLA) + Vector2.ONE * (TAMANO_CASILLA / 2.0)
