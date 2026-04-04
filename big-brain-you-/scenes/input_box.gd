extends CanvasLayer

@onready var line_edit_input = $HBoxContainer/LineEdit
@onready var right_lbl = $HBoxContainer/right_lbl
@onready var wrong_lbl = $HBoxContainer/wrong_lable
@onready var sfx_correct = $CorrectSfx  
@onready var sfx_wrong = $WrongSfx 

var rights_ans = 0
var wrong_ans = 0 

var score = 0
var right_color = Color(0.2,1,0.2)
var wrong = 0 
var wrong_color = Color(1,0.3,0.3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_edit_input.call_deferred("grab_focus")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_line_edit_focus_exited() -> void:
	line_edit_input.call_deferred("grab_focus")

func new_qwestion(): 
	line_edit_input.text = ""
	line_edit_input.call_deferred("grab_focus")

func _input(event):
	if event.is_action_pressed("Confirm"):
		check_answer()
	
func check_answer():
	var player_text = line_edit_input.text
	if player_text == "":
		return
	else: 
		new_qwestion()
		
		if player_text == "yes": 
			rights_ans += 1
			right_lbl = str(wrong_ans)
			flash_question_label(right_color)
		else: 
			wrong_ans += 1
			wrong_lbl = str(wrong_ans)
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
