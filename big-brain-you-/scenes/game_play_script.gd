extends Node2D

# ------------------------Spelar Input-------------------- #

@onready var enemy_container = $TypingEnemyContainer

var active_enemy = null 
var current_letter_index: int = -1 

func find_new_active_enemy(typed_character: String): 
	for enemy in enemy_container.get_children(): 
		var prompt = enemy.get_prompt()
		var next_character = prompt.substr(0, 1)
		if next_character == typed_character: 
			print("found new enemy that starts with %s " % next_character )
			active_enemy = enemy
			current_letter_index =  1

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed(): 
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		if active_enemy == null: 
			find_new_active_enemy(key_typed)
		else: 
			var prompt = active_enemy.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1 )
			if key_typed == next_character: 
				print("enemy fully typed %s" % key_typed)
				current_letter_index += 1 
				if current_letter_index == prompt.length(): 
					print("done ")
					current_letter_index = -1 
					active_enemy.queue_free()
					# PLAY DEATH ANIMATION!!!!!!!!!!
					active_enemy = null
			else: 
				print("wrong typed %s insted of %s" % [key_typed, next_character])
				
