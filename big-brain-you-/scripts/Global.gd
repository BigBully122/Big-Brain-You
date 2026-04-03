extends Node

var difficulty = 1

signal difficulty_increased(new_difficulty)



var player_health: float = 100
var old_health: float

func _process(delta: float) -> void:
	if player_health != old_health: 
		print(player_health)
		old_health = player_health
