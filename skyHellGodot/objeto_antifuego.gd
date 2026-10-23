class_name ObjetoAntifuego extends Node2D

@export_range(0,3) var cargas: int=3

@onready var imagen: Sprite2D=$Sprite2D

const EXTINTOR_LLENO =preload("res://Extintor_Lleno.png")
const EXTINTOR_EN_USO =preload("res://Extintor_EnUso.png")
const EXTINTOR_VACIO =preload("res://Extintor_Vacio.png")

func _ready() -> void:
	actualizar_imagen()
	
func actualizar_imagen() -> void:
	if cargas ==3:
		imagen.texture =EXTINTOR_LLENO
	elif cargas>0:
		imagen.texture=EXTINTOR_EN_USO
	else:
		imagen.texture=EXTINTOR_VACIO

func consumir_carga() -> bool:
	if cargas>0:
		cargas-=1
		actualizar_imagen()
		print("Cargas restante: ",cargas)
		return true
	else:
		print("El extintor está vacío.")
		return false 

#FUNCIÓN PARA PROBAR LOS CAMBIOS DEL EXTINTOR CON EL TECLADO (USANDO BARRA ESPACIADORA)  
#func _unhandled_key_input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.pressed and not event.echo and event.keycode == KEY_SPACE:
			#consumir_carga()
