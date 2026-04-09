extends Node

const FILE_PATH: String = "user://Saved_Settings.json"

var save_data: Dictionary = {
	"player_name": "You",
	"max_typing_score_ever": 0,
	"max_reading_score_ever": 0, 
	"max_addition_score_ever": 0, 
	"max_subtraction_score_ever": 0, 
	"max_multiplication_score_ever": 0, 
	"difficulty_num": 0,
	"music_value": 60,
	"sounds_value": 60,
	"difficulty_type": 1, 
	"user_prompt_text": ""
}

func _ready() -> void:
	_load()

func _save() -> void: 
	var file: FileAccess = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()
	

func _load() -> void: 
	if FileAccess.file_exists(FILE_PATH):
		var file: FileAccess = FileAccess.open(FILE_PATH, FileAccess.READ)
		var data: Dictionary = file.get_var()
		for i in data: 
			if save_data.has(i): 
				save_data[i] = data[i]
		file.close()
