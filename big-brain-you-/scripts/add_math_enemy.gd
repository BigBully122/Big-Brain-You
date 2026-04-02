extends CharacterBody2D

enum State {
	IDLE,
	CHASE,
	ATTACK
}

@export_category("Stats")
@export var speed: float = 350
@export var attack_damage: int = 10
@export var attack_times: int = 1
@export var attack_range: float = 40
@export var attack_cooldown: float = 5
var attack_frame: Array = [2]

@export_category("Related Scenes")
@export var death_packed: PackedScene

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var sprite: AnimatedSprite2D = %sprite   # 🔥 Viktigt

var state: State = State.CHASE
var direction: Vector2
var is_attacking: bool = false

func _ready() -> void:
	sprite.animation = "enemy_Run"
	sprite.play()

func _physics_process(delta: float) -> void:
	match state:
		State.CHASE:
			move_towards_player()
			if distance_to_player() <= attack_range and not is_attacking:
				state = State.ATTACK
				start_attack()
			
			if sprite.animation != "enemy_Run":
				sprite.animation = "enemy_Run"
				sprite.play()

		State.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, speed)
			if sprite.animation != "enemy_Idle":
				sprite.animation = "enemy_Idle"
				sprite.play()

		State.ATTACK:
			if sprite.animation != "enemy_Attack":
				sprite.animation = "enemy_Attack"
				sprite.play()

	move_and_slide()


func move_towards_player():
	direction = (player.global_position - global_position).normalized()

	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true

	velocity = direction * speed

	state = State.CHASE


func distance_to_player() -> float:
	return global_position.distance_to(player.global_position)


func start_attack():
	is_attacking = true
	velocity = Vector2.ZERO

	state = State.ATTACK

	attack_sequence()


func attack_sequence():
	# Vänta tills attacken "går av"
	await get_tree().create_timer(attack_times).timeout

	# → IDLE
	state = State.IDLE
	sprite.animation = "enemy_Idle"
	sprite.play()

	# Cooldown
	await get_tree().create_timer(attack_cooldown).timeout

	# Tillbaka till CHASE
	state = State.CHASE

	is_attacking = false


func death():
	var death_scene: Node2D = death_packed.instantiate()
	death_scene.position = global_position + Vector2(0, -32)
	%Effects.add_child(death_scene)
	queue_free()


func _on_sprite_animation_changed() -> void:
	if sprite.animation == "enemy_Attack": 
		print("animation active")
		Global.player_health -= 10
		#The code below does not work!!
		if sprite.frame in attack_frame: 
			Global.player_health -= 10
			print("Attack")
			pass
		
	
