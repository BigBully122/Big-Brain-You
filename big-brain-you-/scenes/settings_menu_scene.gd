extends Control

@onready var music_value = $NinePatchRect/ScrollContainer/VBoxContainer/music/SpinBox
@onready var sound_value = $NinePatchRect/ScrollContainer/VBoxContainer/sounds/SpinBox
@onready var difficulty_type = $NinePatchRect/ScrollContainer/VBoxContainer/game_difficulty/OptionButton



@onready var hardens_lbl_container = $NinePatchRect/ScrollContainer/VBoxContainer/hardness
@onready var hardens_menu_container = $NinePatchRect/ScrollContainer/VBoxContainer/game_difficulty
@onready var custom_text_lbl_container = $NinePatchRect/ScrollContainer/VBoxContainer/custom_text_lbl
@onready var custom_text_edit_container = $NinePatchRect/ScrollContainer/VBoxContainer/custom_text_edit

func _ready() -> void:
	hardens_lbl_container.hide()
	hardens_menu_container.hide()
	custom_text_lbl_container.hide()
	custom_text_edit_container.hide()


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on: 
		hardens_lbl_container.show()
		hardens_menu_container.show()
		custom_text_lbl_container.show()
		custom_text_edit_container.show()
	else: 
		hardens_lbl_container.hide()
		hardens_menu_container.hide()
		custom_text_lbl_container.hide()
		custom_text_edit_container.hide()


func _on_close_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/home_menu.tscn")


func _on_save_btn_pressed() -> void:
	pass # Replace with function body.


func _on_reset_btn_pressed() -> void:
	pass # Replace with function body.


func _on_reset_to_original_btn_pressed() -> void:
	pass # Replace with function body.
