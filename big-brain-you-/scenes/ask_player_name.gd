extends ColorRect

@onready var line_edit_input = $NinePatchRect/VBoxContainer/LineEdit
@onready var sfx_wrong = $WrongSfx


var w_color = Color(1,0.3,0.3)

func _ready() -> void:
	line_edit_input.call_deferred("grab_focus")

func _on_submit_btn_pressed() -> void:
	_on_line_edit_text_submitted()

func _on_line_edit_text_submitted() -> void:
	if line_edit_input.text != "": 
		SavesLoads.save_data.player_name = line_edit_input.text
		SavesLoads._save()
		self.hide()
	else: 
		flash_question_label()
		line_edit_input.call_deferred("grab_focus")

func flash_question_label(): 
	
	sfx_wrong.play()
	
	var tween = create_tween()
	
	tween.tween_property(line_edit_input, "modulate", w_color, 0.1)

	tween.tween_property(line_edit_input, "position:x", line_edit_input.position.x - 10, 0.05)

	tween.tween_property(line_edit_input, "position:x", line_edit_input.position.x + 10, 0.05)

	tween.tween_property(line_edit_input, "position:x", line_edit_input.position.x, 0.05)

	tween.tween_property(line_edit_input, "modulate", Color(1,1,1), 0.3)
