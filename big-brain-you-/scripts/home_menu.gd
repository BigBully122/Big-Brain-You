extends Control

signal play_btn_pressed(origin: String)
signal quit_btn_pressed(origin: String)

@onready var game_header = $game_header
@onready var ask_player_name_contener = $ask_player_name

func _ready() -> void:
	ask_player_name_contener.hide()
	if SavesLoads.save_data.player_name == "": 
		ask_player_name_contener.show()
		
	else: 
		game_header.text = "Big Brean %s" %SavesLoads.save_data.player_name

func _on_ask_player_name_visibility_changed() -> void:
	game_header.text = "Big Barin %s" % SavesLoads.save_data.player_name


func _on_playbtn_pressed() -> void:
	play_btn_pressed.emit("home_menu")
	get_tree().change_scene_to_file("res://scenes/home_scene_map.tscn")


func _on_quitbtn_pressed() -> void:
	get_tree().quit()


func _on_settings_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_menu_scene.tscn")
