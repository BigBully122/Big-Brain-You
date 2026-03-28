extends CharacterBody2D

enum State {
	IDLE, 
	CHASE, 
	ATTACK, 
	DEAD
	}

@export_category("Stats")
@export var speed:int = 10 
@export var attack_damage: int = 10 
@export var attack_speed:int = 1.0 
@export var attack_range: int = 80 

@export_category("Related Scenes")
@export var death_packed: PackedScene
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
var state: State = State.CHASE


func _ready() -> void:
	#animation_tree.set_active(true)
	pass
	


func _physics_process(delta: float) -> void: 
	if state == State.DEAD: 
		return 
	if state == State.ATTACK: 
		return
	
	if distance_to_player() <= attack_range: 
		state = State.ATTACK
		attack()
	elif state != State.CHASE:  
		state = State.CHASE


func distance_to_player(): 
	return global_position.direction_to(player.global_position)


func move():
	pass
	

func attack(): 
	var player_pos: Vector2 = player.global_position
	var attack_dir: Vector2 = (player_pos - global_position).normalized()
	# flip the animated sprite 2d named sprite 
	
	await get_tree().create_timer(attack_speed).timeout
	state = State.IDLE



func death():
	var death_scene: Node2D = death_packed.instantiate()
	death_scene.position = global_position + Vector2(0.0, -32.0)
	%Effects.add_child(death_scene)
	queue_free()
