extends Control


func _on_playbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/home_scene_map.tscn")


func _on_quitbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://game_play_scene.tscn")
