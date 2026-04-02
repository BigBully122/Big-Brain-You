extends CharacterBody2D

@export_category("Stats")
@export var movement_speed : float = 500
var charactre_direction : Vector2

@export var sfx_footsteps : AudioStream
var footstep_frames : Array = [0, 3]

func _physics_process(delta: float) -> void:
	movement_loop()
	
func movement_loop(): 
	charactre_direction.x = Input.get_axis("move_left", "move_right")
	charactre_direction.y = Input.get_axis("move_up", "move_down")
	charactre_direction = charactre_direction.normalized()
	
	# Flip 
	if charactre_direction.x > 0: %sprite.flip_h = false
	elif charactre_direction.x < 0: %sprite.flip_h = true
	
	if charactre_direction: 
		velocity = charactre_direction * movement_speed 
		if %sprite.animation != "player_Run": %sprite.animation = "player_Run"
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if %sprite.animation != "player_Idle": %sprite.animation = "player_Idle"
		
	move_and_slide()

func load_sfx(sfx_to_load): 
	if %sfx_player.stream != sfx_to_load: 
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load




func _on_sprite_frame_changed() -> void:
	if %sprite.animation == "player_Idle": 
		return
	
	load_sfx(sfx_footsteps)
	
	if %sprite.frame in footstep_frames: 
		%sfx_player.play()
