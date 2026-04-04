extends Node2D

signal answer_submited(right_or_wrong: bool)

# ------------------------Spelar Input-------------------- #

@onready var spawn_timer = $SpawnTimer
@onready var enemy_container = $TypingEnemyContainer
@onready var enemy_spawn_container = $EnemySpawnContainer
var typing_enemy = preload("res://characters/typing_enemy.tscn")
var difficculty: int = 1 

@onready var input_box = $input_box/HBoxContainer/LineEdit 
var ready_to_check: bool = false

var active_enemy = null 
var current_letter_index: int = -1 

func _ready() -> void:
	randomize()
	spawn_timer.start()
	spawn_enemy()
	answer_submited.connect(check_answer)

func _process(delta: float) -> void:
	handle_input_from_box()

func find_new_active_enemy(typed_character: String): 
	for enemy in enemy_container.get_children(): 
		var prompt = enemy.get_prompt()
		var next_character = prompt.substr(0, 1)
		if next_character == typed_character: 
			print("found new enemy that starts with %s " % next_character )
			active_enemy = enemy
			current_letter_index =  1
			active_enemy.set_next_character(current_letter_index)
			return



func handle_input_from_box():
	var text = input_box.text
	
	# Ingen aktiv enemy → försök hitta en
	if active_enemy == null:
		if text.length() > 0:
			find_new_active_enemy(text.substr(0, 1))
		return
	
	var prompt = active_enemy.get_prompt()
	
	# Gå igenom allt som skrivits
	var correct_count := 0
	
	for i in range(min(text.length(), prompt.length())):
		if text[i] == prompt[i]:
			correct_count += 1
		else:
			break  # stoppar vid första fel
	
	current_letter_index = correct_count
	active_enemy.set_next_character(current_letter_index)
	
	# ✅ Klar
	if correct_count == prompt.length(): 
		ready_to_check = true
	else: 
		ready_to_check = false

func _input(event):
	if event.is_action_pressed("Confirm"):
		check_answer()

func check_answer(): 
	if ready_to_check == true: 
		print("done")
		active_enemy.queue_free()
		active_enemy = null
		current_letter_index = -1
		emit_signal("answer_submited", true)
	else: 
		active_enemy = null
		current_letter_index = -1
		emit_signal("answer_submited", false)

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func spawn_enemy(): 
	var enemy_instance = typing_enemy.instantiate()
	var spawns = enemy_spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawns[index].global_position


func _on_difficulty_timer_timeout() -> void:
	difficculty += 1 
	var time_diff_a = 3
	var time_diff_k = 0.02
	var time_diff_min = 2
	Global.emit_signal("difficulty_increased", difficculty) 
	Global.difficulty = difficculty
	spawn_timer.wait_time = time_diff_a * exp(-time_diff_k*difficculty) + time_diff_min
