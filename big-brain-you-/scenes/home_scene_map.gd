extends Node2D


@onready var typing_screen = $CanvasLayer/GameOverScreen

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	typing_screen.hide()

func _on_wrighting_chrc_area_body_entered(body: Node2D) -> void:
	typing_screen.show()


func _on_typing_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_play_scene.tscn")


func _on_typing_exit_btn_pressed() -> void:
	typing_screen.hide()
