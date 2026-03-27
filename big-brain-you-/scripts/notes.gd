extends Node


# ---------

@onready var score_label = $VBoxContainer2/ScoreLabel
@onready var wrong_lable = $VBoxContainer3/WrongScore
@onready var timer_lable = $VBoxContainer/timer_lbl
@onready var question_label = $Label        # or $QuestionLabel
@onready var line_edit_input = ""
@onready var timer = $timer_constant
@onready var sfx_correct = $CorrectSfx
@onready var sfx_wrong = $WrongSfx
@onready var sfx_clock = $TickingClockSfx

var score = 0
var right_color = Color(0.2,1,0.2)
var wrong = 0 
var wrong_color = Color(1,0.3,0.3)
var correct_answer_int = 0
var correct_answer_str = ""
var time_left : float
var time_per_question : int = 55
var hardness = 1
var game_type = 4  # 1=add,2=sub,3=mul,4=typing

var text = ("var hans första. Hela byn var täckt av små glittrande blå, gula, röda och vita lyktor. De hängde
från alla träd, buskar, hustak och staket. Byn var verkligen pyntad för fest. Byborna sjöng,
skrattade och dansade runt sprakande, värmande brasor. Över alltihop gnistrade tusentals stjärnor på den svarta natthimlen. De firade att det var årets mörkaste natt. Efter den här natten
blev varje dag ljusare och ljusare och snart skulle våren vara här.
Men det var fortfarande vinter, mörkt och bitande kallt. Snön låg i drivor runt husen och
istapparna hängde från taken, men Jin frös inte. Värmen från bybornas glada fest gjorde att
han kände sig alldeles varm inombords. På det lilla torget hördes skratt och sång, byborna
visste hur man roade sig.
Jin hade den bästa utkiksplatsen av alla, i toppen på det stora trädet mitt i byn. Härifrån
kunde han se allt som hände på torget, alla färgglada dekorationer och glittriga girlanger. Eftersom det var mitt i vintern fanns det inga löv som dolde honom för nyfikna blickar, men han
var inte orolig. Hittills hade ingen människa någonsin sett en ande och Jin var en livs levande
ande. En sån där ande som hade magiska krafter och som hjälpte byborna med alla möjliga
sysslor. Problemet var att Jin inte fått sina krafter än. Han var bara ett år gammal och väntade
ivrigt på att hans krafter skulle avslöja sig. En ny ande visste aldrig vilken sorts magiska krafter han eller hon skulle få. Det brukade visa sig helt plötsligt när de passerat ett års ålder. Från
en stund till en annan kunde de trolla fram vatten i byns brunn eller blåsa vind i fiskarnas
segel, beroende på vilken elementmagi de fått.
Jin hoppades på att han skulle bli en vattenande. Han hade sett hur viktigt det var att det
fanns vatten i byns brunnar och hur glada byborna blivit när det regnade på deras åkrar. Han
kunde också tänka sig att bli en vind eller jordande. De var också omtyckta av byns invånare.
Vindanden var nyttig på flera sätt, både för att föra fiskarna ut på havet men också för att driva mjölnarnas vindkvarnar. Jordanden var lika omtyckt, de såg till att åkern var lätt att plöja
och så och att skörden växte bra.
Det fanns bara ett element som Jin absolut inte ville vara och det var en eldande.
Han hade själv sett hur farligt elden var och vilka skador som den kunde skapa. För några
månader sedan hade elden nästan bränt ner byn. Byborna hade lyckats släcka bränderna som") 

var cleaned = text.to_lower().replace(",", " ").replace(".", " ").replace("!", " ").replace(":", " ")

func _ready():
	randomize()
	line_edit_input.call_deferred("grab_focus")
	#sfx_clock.volume_db = -80
	start_game()

func _input(event):
	if event.is_action_pressed("enter"):
		_on_enter_btn_pressed()

func start_game():
	score = 0
	score_label.text = "0"
	wrong_lable.text = "0"
	new_question()

func new_question():
	timer_lable.modulate = Color(1,1,1)
	sfx_clock.stop()
	
	line_edit_input.call_deferred("grab_focus")
	start_timer()
	line_edit_input.text = ""
	
	if game_type == 4:
		# Typing mode: choose a random word
		var words = cleaned.split(" ", false)
		
		while true:
			var word = words[randi() % words.size()]
			
			if "å" not in word:
				correct_answer_str = word
				break

		correct_answer_str = words[randi() % words.size()]
		question_label.text = correct_answer_str
		return
	# Otherwise, math generation:
	var a = 0; var b = 0
	if hardness == 1:
		a = randi_range(1,10); b = randi_range(1,10)
	elif hardness == 2:
		a = randi_range(5,20); b = randi_range(5,20)
	else:
		a = randi_range(10,50); b = randi_range(10,50)
	match game_type:
		1:  # addition
			correct_answer_int = a + b
			question_label.text = "%s + %s" % [a, b]
		2:  # subtraction (ensure non-negative)
			if b > a:
				var c = a
				a = b 
				b = c 
			correct_answer_int = a - b
			question_label.text = "%s - %s" % [a, b]
		3:  # multiplication
			if hardness <= 2:
				a = randi_range(1,10); b = randi_range(1,10)
			correct_answer_int = a * b
			question_label.text = "%s × %s" % [a, b]

func start_timer():
	time_left = time_per_question
	timer_lable.text = str(int(time_left))

	timer.start()

func _on_timer_constant_timeout():
	var threshold = float(time_per_question / 2.5)
	
	time_left -= 1
	
	if time_left <= threshold:
		sfx_clock.play()
		update_clock_volume(threshold)
		timer_lable.modulate = Color(1,0.3,0.3)
	else:
		timer_lable.modulate = Color(1,1,1)
		timer_lable.text = str(int(time_left))
	
	timer_lable.text = str(int(time_left))
	
	if time_left <= 0:
		timer.stop()
		wrong += 1
		wrong_lable.text = str(wrong)
		flash_question_label(wrong_color)
		sfx_clock.stop()
		new_question()

func update_clock_volume(threshold):
	var progress = 1.0 - (timer.time_left / threshold)
	
	# interpolate volume from quiet → loud
	var min_vol = -40
	var max_vol = 14
	
	sfx_clock.volume_db = lerp(min_vol, max_vol, progress)


func _on_enter_btn_pressed():
	check_answer()
	line_edit_input.call_deferred("grab_focus")

func check_answer():
	if line_edit_input.text == "":
		return
	if game_type == 4:
		# Check typing answer (string)
		#var player_text = line_edit_input.text.strip(" ")
		var player_text = line_edit_input.text
		if player_text == correct_answer_str:
			score += 1
			score_label.text = str(score)
			flash_question_label(right_color)
			new_question()
		else:
			wrong += 1
			wrong_lable.text = str(wrong)
			flash_question_label(wrong_color)
			line_edit_input.text = ""
		return
	# Math answer mode
	var player_answer = int(line_edit_input.text)
	if player_answer == correct_answer_int:
		score += 1
		score_label.text = str(score)   # update score display【26†L9281-L9284】
		flash_question_label(right_color)
		# Adaptive difficulty: increase hardness every 5 points
		if score > 0 and score % 5 == 0:
			hardness = clamp(hardness + 1, 1, 3)
		new_question()
	else:
		wrong += 1
		wrong_lable.text = str(wrong)
		flash_question_label(wrong_color)
		line_edit_input.text = ""
	

func flash_question_label(color): 
	
	if color == right_color: 
		sfx_correct.play()
	elif color == wrong_color: 
		sfx_wrong.play()
	
	var tween = create_tween()

	# green color
	tween.tween_property(question_label, "modulate", color, 0.1)

	# shake left
	tween.tween_property(question_label, "position:x", question_label.position.x - 10, 0.05)

	# shake right
	tween.tween_property(question_label, "position:x", question_label.position.x + 10, 0.05)

	# back to center
	tween.tween_property(question_label, "position:x", question_label.position.x, 0.05)

	# back to white
	tween.tween_property(question_label, "modulate", Color(1,1,1), 0.3)


func _on_skip_pressed() -> void:
		new_question()
		wrong += 1
		wrong_lable.text = str(wrong)
		flash_question_label(wrong_color)
		line_edit_input.text = ""
