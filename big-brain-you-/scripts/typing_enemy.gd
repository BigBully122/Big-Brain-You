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
@export var attack_range: float = 100
@export var attack_cooldown: float = 2
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
	prompt_text = PrompList.get_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))

func _physics_process(delta: float) -> void:
	match state:
		State.CHASE:
			move_towards_player()
			if distance_to_player() <= attack_range and not is_attacking:
				state = State.ATTACK
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
		

#----------------------------------------------------------#


@export_category("Colors")
@export_color_no_alpha var typed_col: Color
@export_color_no_alpha var character_on_col: Color
@export_color_no_alpha var normal_col: Color

@onready var prompt = $Label/RichTextLabel
@onready var prompt_text = prompt.text

func get_prompt() -> String: 
	return prompt_text


func set_next_character(next_character_index: int): 
	var text = prompt_text
	
	var typed_col_text = ""
	var character_on_col_text = ""
	var normal_col_text = ""
	
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
		normal_col_text = get_bbcode_color_tag(normal_col) \
		+ text.substr(next_character_index + 1, text.length() - next_character_index - 1) \
		+ get_bbcode_end_color_tag()
	
	prompt.parse_bbcode(set_center_tags(
		typed_col_text + character_on_col_text + normal_col_text
	))

"""
func set_next_character(next_character_index: int): 
	var typed_col_text = get_bbcode_color_tag(typed_col) + prompt_text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var character_on_col_text = get_bbcode_color_tag(character_on_col) + prompt_text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var normal_col_text = ""
	if next_character_index != prompt_text.length(): 
		normal_col_text = get_bbcode_color_tag(normal_col) + prompt_text.substr(next_character_index + 1, prompt_text.length() - next_character_index +1 ) + get_bbcode_end_color_tag()
	prompt.parse_bbcode(set_center_tags(typed_col_text + character_on_col_text + normal_col_text))
	#Do the same CENTER thing to the lable // No not iportanand becuse it does not cange 
"""
func set_center_tags(string_to_center: String): 
	return "[center]" + string_to_center + "[/center]"

func get_bbcode_color_tag(color: Color) -> String: 
	return "[color=#" + color.to_html(false) + "]"

func get_bbcode_end_color_tag() -> String: 
	return "[/color]"
