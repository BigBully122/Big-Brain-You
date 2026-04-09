extends Node2D


@onready var typing_screen = $CanvasLayer/typing_game_panel_screen
@onready var player = $player

func _ready() -> void:
	pass

func _on_wrighting_chrc_area_body_entered(body: Node2D) -> void:
	if body == player: 
		Global.player_movment_off = true
		typing_screen.show()


func _on_typing_start_btn_pressed() -> void:
	Global.player_movment_off = false
	get_tree().change_scene_to_file("res://scenes/game_play_scene.tscn")


func _on_typing_exit_btn_pressed() -> void:
	Global.player_movment_off = false
	typing_screen.hide()
