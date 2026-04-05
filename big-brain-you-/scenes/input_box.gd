extends CanvasLayer

@onready var line_edit_input = $HBoxContainer/LineEdit
@onready var right_lbl = $HBoxContainer/right_lbl
@onready var wrong_lbl = $HBoxContainer/wrong_lbl
@onready var sfx_correct = $CorrectSfx  
@onready var sfx_wrong = $WrongSfx 

var score = 0
var rights_ans = 0
var wrong_ans = 0 

var right_color = Color(0.2,1,0.2)
var wrong_color = Color(1,0.3,0.3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_edit_input.call_deferred("grab_focus")
	right_lbl.text = "0"
	wrong_lbl.text = "0"


func _on_line_edit_focus_exited() -> void:
	line_edit_input.call_deferred("grab_focus")


func new_qwestion(): 
	line_edit_input.call_deferred("grab_focus")
	line_edit_input.text = ""


func _on_game_play_scene_answer_submited(right_or_wrong: bool) -> void:
	if line_edit_input.text == "":
		return
	else: 
		new_qwestion()
		
		if right_or_wrong: 
			rights_ans += 1
			right_lbl.text = str(rights_ans)
			flash_question_label(right_color)
		else: 
			wrong_ans += 1
			wrong_lbl.text = str(wrong_ans)
			flash_question_label(wrong_color)
	


func flash_question_label(color): 
	
	if color == right_color: 
		sfx_correct.play()
	elif color == wrong_color: 
		sfx_wrong.play()
	
	var tween = create_tween()

	# green color
	tween.tween_property(line_edit_input, "modulate", color, 0.1)

	# shake left
	tween.tween_property(line_edit_input, "position:x", line_edit_input.position.x - 10, 0.05)

	# shake right
	tween.tween_property(line_edit_input, "position:x", line_edit_input.position.x + 10, 0.05)

	# back to center
	tween.tween_property(line_edit_input, "position:x", line_edit_input.position.x, 0.05)

	# back to white
	tween.tween_property(line_edit_input, "modulate", Color(1,1,1), 0.3)
	
	

func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_play_scene.tscn")

func _on_home_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/home_scene_map.tscn")

func _on_quit_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/home_menu.tscn")


func _on_line_edit_text_changed(new_text: String) -> void:
	var filtered := ""
	
	for c in new_text:
		if c.is_valid_int() or c.is_valid_float():
			filtered += c
		elif c.is_subsequence_of("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZåäöÅÄÖ"):
			filtered += c
	
	# 🔴 Uppdatera bara om något faktiskt ändrats (viktigt)
	if filtered != new_text:
		line_edit_input.text = filtered
		line_edit_input.set_caret_column(filtered.length())
