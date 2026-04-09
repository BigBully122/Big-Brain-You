extends CharacterBody2D

enum State {
	IDLE,
	CHASE,
	ATTACK
}

@export_category("Stats")
var speed: float
@export var attack_damage: int = 10
@export var attack_times: int = 1
@export var attack_range: float = 150
@export var attack_cooldown: float = 2
var attack_frame: Array = [1, 2]

@export_category("Related Scenes")
@export var death_packed: PackedScene

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var sprite: AnimatedSprite2D = %sprite   

var state: State = State.CHASE
var direction: Vector2
var is_attacking: bool = false

func _ready() -> void:
	sprite.animation = "enemy_Run"
	sprite.play()
	prompt_text = PrompList.get_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))
	
	#Global.difficulty_increased.connect(handle_difficulty_increase)
	
	handle_difficulty_increase(Global.difficulty)

func _physics_process(delta: float) -> void:
	if Global.player_dead: 
		state = State.IDLE
	match state:
		State.CHASE:
			move_towards_player()
			if distance_to_player() <= attack_range and not is_attacking:
				start_attack()
			
			elif sprite.animation != "enemy_Run":
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

func handle_difficulty_increase(new_difficulty: int): 
	var speed_max = -200
	var speed_a = 10 # Blir hastigheten i början (speed_max - speed_a)
	var speed_k = 0.02
	speed = -(speed_a * exp(-speed_k * new_difficulty) + speed_max)


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
	await get_tree().create_timer(attack_times).timeout
	
	
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


func _on_sprite_frame_changed() -> void:
	if sprite.animation == "enemy_Attack": 
		if sprite.frame in attack_frame: 
			Global.player_health -= 5

#----------------------------------------------------------#


@export_category("Colors")
@export_color_no_alpha var typed_col: Color
@export_color_no_alpha var character_on_col: Color
@export_color_no_alpha var left_to_type_col: Color
@export_color_no_alpha var normal_col: Color

@onready var prompt = $Label/RichTextLabel
@onready var prompt_text = prompt.text

func get_prompt() -> String: 
	return prompt_text


func set_next_character(next_character_index: int): 
	var text = prompt_text
	
	if next_character_index == 0:
		prompt.parse_bbcode(set_center_tags(
			get_bbcode_color_tag(normal_col) + text + get_bbcode_end_color_tag()
		))
		return
	
	var typed_col_text = ""
	var character_on_col_text = ""
	var left_to_type_col_text = ""
	
	# 1. Typed text
	if next_character_index > 0:
		typed_col_text = get_bbcode_color_tag(typed_col) \
		+ text.substr(0, next_character_index) \
		+ get_bbcode_end_color_tag()
	
	# 2. Current character (VIKTIG FIX)
	if next_character_index < text.length():
		character_on_col_text = get_bbcode_color_tag(character_on_col) \
		+ text.substr(next_character_index, 1) \
		+ get_bbcode_end_color_tag()
	
	# 3. Remaining text (FIXAD LENGTH)
	if next_character_index < text.length() - 1:
		left_to_type_col_text = get_bbcode_color_tag(left_to_type_col) \
		+ text.substr(next_character_index + 1, text.length() - next_character_index - 1) \
		+ get_bbcode_end_color_tag()
	
	for i in range(next_character_index):
		if i >= text.length():
			break
	
	prompt.parse_bbcode(set_center_tags(
		typed_col_text + character_on_col_text + left_to_type_col_text
	))


func set_center_tags(string_to_center: String): 
	return "[center]" + string_to_center + "[/center]"

func get_bbcode_color_tag(color: Color) -> String: 
	return "[color=#" + color.to_html(false) + "]"

func get_bbcode_end_color_tag() -> String: 
	return "[/color]"
