extends Node2D

signal answer_submited(right_or_wrong: bool)
signal player_health_changed(change_value)


# ------------------------Spelar Input-------------------- #

@onready var spawn_timer = $SpawnTimer
@onready var difficculty_timer = $difficultyTimer
@onready var enemy_container = $TypingEnemyContainer
@onready var enemy_spawn_container = $EnemySpawnContainer
@onready var player = $player_game_play
var typing_enemy = preload("res://characters/typing_enemy.tscn")

@onready var input_box = $input_box/game_play_ui/HBoxContainer/LineEdit
var ready_to_check: bool = false

@onready var game_play_ui = $input_box/game_play_ui
@onready var game_over_screen = $input_box/game_over_screen
@onready var pause_screen = $input_box/paused_screen

var active_enemy = null 
var current_letter_index: int = -1 

var lockal_player_health = 100

func _ready() -> void:
	Global.player_health = 100 
	Global.player_dead = false
	SavesLoads._load()
	Global.difficulty = SavesLoads.save_data.difficulty_num
	randomize()
	spawn_timer.start()
	answer_submited.connect(check_answer)
	_on_difficulty_timer_timeout()
	difficculty_timer.start()
	player_health_changed.connect(on_player_health_changed)
	print(Global.player_health)
	pause_screen.hide()
	game_over_screen.hide()
	game_play_ui.show()

func _process(delta: float) -> void:
	if (Global.player_health <= 0): 
		game_over_maniger()
	
	var health_diffrense = lockal_player_health - Global.player_health
	if health_diffrense: 
		on_player_health_changed(health_diffrense)
		lockal_player_health = Global.player_health
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
	
	if active_enemy == null:
		if text.length() > 0:
			find_new_active_enemy(text.substr(0, 1))
		return
	
	var prompt = active_enemy.get_prompt()
	
	
	var correct_count := 0
	
	for i in range(min(text.length(), prompt.length())):
		if text[i] == prompt[i]:
			correct_count += 1
		else:
			break  
	
	current_letter_index = correct_count
	active_enemy.set_next_character(current_letter_index)
	
	if correct_count == prompt.length(): 
		ready_to_check = true
	else: 
		ready_to_check = false

func _input(event):
	if input_box.text.length() == 0:
		active_enemy = null
		current_letter_index = -1

	if event.is_action_pressed("Confirm"):
		if input_box.text.length() == 0:
			return
		check_answer()

func check_answer(): 
	if active_enemy == null:
		emit_signal("answer_submited", false)
		return
	
	if ready_to_check == true: 
		active_enemy.queue_free()
		emit_signal("answer_submited", true)
	else: 
		emit_signal("answer_submited", false)
	
	active_enemy.set_next_character(0)
	active_enemy = null
	current_letter_index = -1


func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func spawn_enemy(): 
	var enemy_instance = typing_enemy.instantiate()
	var spawns = enemy_spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_instance.global_position = spawns[index].global_position
	enemy_container.add_child(enemy_instance)


func _on_difficulty_timer_timeout() -> void:
	Global.difficulty += 1 
	var time_diff_a = 5
	var time_diff_k = 0.02
	var time_diff_min = 2
	#Global.emit_signal("difficulty_increased", difficculty) 
	spawn_timer.wait_time = time_diff_a * exp(-time_diff_k*Global.difficulty) + time_diff_min

func on_player_health_changed(change_value): 
	Global.player_health -= change_value

	var camera = $Camera2D
	camera.offset = Vector2.ZERO
	
	var magnitude = clamp(abs(change_value) * 3.0, 3.0, 20.0)
	
	var duration = 0.2
	var shakes = 4
	
	var tween = create_tween()
	
	for i in range(shakes):
		var offset = Vector2(
			randf_range(-magnitude, magnitude),
			randf_range(-magnitude, magnitude)
		)
		tween.tween_property(camera, "offset", offset, duration / (shakes * 2))
	
	tween.tween_property(camera, "offset", Vector2.ZERO, duration / 2)
	
	if change_value > 0:
		var blink_tween = create_tween()
		
		blink_tween.tween_property(player, "modulate", Color(1,1,1), 0.05)
	
		blink_tween.tween_property(player, "modulate", Color(1,0.2,0.2), 0.1)
		
		blink_tween.tween_property(player, "modulate", Color(1,1,1), 0.2)
	
	if change_value > 0:
		Engine.time_scale = 0.9
		await get_tree().create_timer(0.05).timeout
		Engine.time_scale = 1.0


func game_over_maniger(): 
	
	game_play_ui.hide()
	game_over_screen.show()
	spawn_timer.stop()
	difficculty_timer.stop()
	Global.player_dead = true
	SavesLoads.save_data.difficulty_num = Global.difficulty
	SavesLoads._save()


func _on_pause_btn_pressed() -> void:
	game_play_ui.hide()
	pause_screen.show()
	get_tree().paused = true 
	SavesLoads.save_data.difficulty_num = Global.difficulty
	SavesLoads._save()
	


func _on_un_pause_btn_pressed() -> void:
	game_play_ui.show()
	pause_screen.hide()
	input_box.call_deferred("grab_focus")
	get_tree().paused = false
