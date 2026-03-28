extends Control

signal play_btn_pressed(origin: String)
signal quit_btn_pressed(origin: String)


func _on_playbtn_pressed() -> void:
	play_btn_pressed.emit("home_menu")
	get_tree().change_scene_to_file("res://scenes/home_scene_map.tscn")


func _on_quitbtn_pressed() -> void:
	quit_btn_pressed.emit("home_menu")
	get_tree().change_scene_to_file("res://game_play_scene.tscn")
