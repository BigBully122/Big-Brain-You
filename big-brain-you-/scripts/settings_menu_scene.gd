extends Control

@onready var player_name_edit = $NinePatchRect/ScrollContainer/VBoxContainer/player_name_edit/LineEdit
@onready var music_spin_box = $NinePatchRect/ScrollContainer/VBoxContainer/music/SpinBox
@onready var sounds_spin_box = $NinePatchRect/ScrollContainer/VBoxContainer/sounds/SpinBox
@onready var voices_options = $NinePatchRect/ScrollContainer/VBoxContainer/voices/OptionButton
var Voices: Array[Dictionary] = DisplayServer.tts_get_voices()
@onready var difficulty_options_btn = $NinePatchRect/ScrollContainer/VBoxContainer/game_difficulty/OptionButton
@onready var user_prompt_text_edit = $NinePatchRect/ScrollContainer/VBoxContainer/custom_text_edit/TextEdit



@onready var hardens_lbl_container = $NinePatchRect/ScrollContainer/VBoxContainer/hardness
@onready var hardens_menu_container = $NinePatchRect/ScrollContainer/VBoxContainer/game_difficulty
@onready var custom_text_lbl_container = $NinePatchRect/ScrollContainer/VBoxContainer/custom_text_lbl
@onready var custom_text_edit_container = $NinePatchRect/ScrollContainer/VBoxContainer/custom_text_edit


func _ready() -> void:
	hardens_lbl_container.hide()
	hardens_menu_container.hide()
	custom_text_lbl_container.hide()
	custom_text_edit_container.hide()
	
	for voice in Voices: 
		voices_options.add_item(voice["name"])
		
	
	_on_reset_btn_pressed()
	
	SavesLoads.save_data.difficulty_num = 0
	SavesLoads._save()


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
	SavesLoads.save_data.player_name = player_name_edit.text
	SavesLoads.save_data.music_value = music_spin_box.value
	SavesLoads.save_data.sounds_value = sounds_spin_box.value
	SavesLoads.save_data.voices_type = voices_options.get_selected_id()
	SavesLoads.save_data.difficulty_type = difficulty_options_btn.selected
	SavesLoads.save_data.user_prompt_text = user_prompt_text_edit.text
	
	SavesLoads._save()


func _on_reset_btn_pressed() -> void:
	SavesLoads._load()
	
	player_name_edit.text = SavesLoads.save_data.player_name 
	music_spin_box.value = SavesLoads.save_data.music_value
	sounds_spin_box.value = SavesLoads.save_data.sounds_value
	voices_options.select(SavesLoads.save_data.voices_type)
	difficulty_options_btn.select(SavesLoads.save_data.difficulty_type)
	user_prompt_text_edit.text = SavesLoads.save_data.user_prompt_text 


func _on_reset_to_original_btn_pressed() -> void:
	SavesLoads.save_data.music_value = 60
	SavesLoads.save_data.sounds_value = 60
	SavesLoads.save_data.voices_type = 0
	SavesLoads.save_data.difficulty_type = 1
	SavesLoads.save_data.user_prompt_text = ""
	
	SavesLoads._save()
	
	_on_reset_btn_pressed()
