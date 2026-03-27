extends Node

@export var home_manu_packed: PackedScene

func _ready() -> void:
	load_home_manu("game_start")
	

func load_home_manu(origen: String) -> void: 
	var home_menu: Control = home_manu_packed.instantiate()
	add_child(home_menu)
	

func settings_open(): 
	pass
	

func quit_game(_origin: String): 
	get_tree().quit()
