extends CharacterBody2D

var damaged = preload("res://scenes/player_damage.tscn")

var dev = false

var root = null

func _ready() -> void:
	add_to_group("player")
	$background.visible = true
	if maxhp == null:
		maxhp = hp
	root = get_tree().root.get_child(0)

func healing(amount):
	hp += amount
	if hp > maxhp:
		hp = maxhp

func die():
	var cam = Camera2D.new()
	cam.zoom = Vector2(2, 2)
	cam.global_position = global_position
	add_sibling(cam)

	var timeri = Timer.new()
	timeri.wait_time = 1.0
	timeri.connect("timeout", Callable(get_tree(), "reload_current_scene"))
	cam.add_child(timeri)
	timeri.start()

	# SAFELY reparent after the current frame
	$background.call_deferred("reparent", cam)

	# SAFELY free after the current frame
	call_deferred("queue_free")


#gameplay statistics
var score = 0
var lastscore = 0
var maxhp = null
var hp = 10
var lasthp = 10
var invulnerable = false

func invulnerability(state):
	invulnerable = state

var goingUp = false
var goingDown = false
var goingRight = false
var goingLeft = false

var speed = 60
func _physics_process(_delta: float) -> void:
	var sprinting = false
	var movement = Vector2(0,0)
	if goingUp:
		movement.y = -1*speed
	if goingDown:
		movement.y = speed
	if goingRight:
		movement.x = speed
	if goingLeft:
		movement.x = -1*speed
	if Input.is_action_pressed("shift"):
		movement = movement*2
		sprinting = true
	if Input.is_action_pressed("space") and dashCooldown == false:
		if sprinting:
			movement = movement*10
		else:
			movement = movement*50
		dashCooldown = true
		$dashtimer.start()
	velocity = movement
	
	#print(str(velocity))
	move_and_slide()

var timer = 0
func _process(_delta: float) -> void:
	checkCollapse()
	timer += 1
	if timer >= 1000:
		print(str(global_position))
		timer = 0
	
	if Input.is_action_just_pressed("ui_home"):
		trigger_victory()
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("w"):
		goingUp = true
	else:
		goingUp = false
	
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("s"):
		goingDown = true
	else:
		goingDown = false
	
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("a"):
		goingLeft = true
	else:
		goingLeft = false
	
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("d"):
		goingRight = true
	else:
		goingRight = false
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("ui_end"):
		dev = !dev
		print("Devmode: ", str(dev))
	
	if dev and speed == 60:
		speed = 200
		$CollisionShape2D.disabled = true
	elif speed == 200:
		speed = 60
		$CollisionShape2D.disabled = false
	
	if hp > lasthp:
		var difference = hp - lasthp
		var notif = (load("res://scenes/notification.tscn")).instantiate()
		notif.notificationType = "health"
		notif.content = "+" + str(difference)
		add_child(notif)
		lasthp = hp
	elif hp < lasthp:
		var difference = lasthp - hp
		var notif = (load("res://scenes/notification.tscn")).instantiate()
		notif.notificationType = "healthbad"
		notif.content = "-"+str(difference)
		add_child(notif)
		lasthp = hp
	
	if score > lastscore:
		var difference = score-lastscore
		var notif = (load("res://scenes/notification.tscn")).instantiate()
		notif.content = "+" + str(difference)
		add_child(notif)
		lastscore = score
		if score == root.mapScore:
			trigger_victory()
	if score == 0:
		$Camera2D/splitter/Score.visible = false
	else:
		$Camera2D/splitter/Score.visible = true
		$Camera2D/splitter/Score/Label.text = str(score) + "/"+str(root.mapScore)
	if true:
		$Camera2D/splitter/HP/Label.text = str(hp)+"/"+str(maxhp)
		$Camera2D/infobox.size.x = $Camera2D/splitter.size.x+6
		$Camera2D/infobox.size.y = $Camera2D/splitter.size.y+8

var dashCooldown = false
func _on_dashtimer_timeout():
	dashCooldown = false

var checksDone = 0
func checkCollapse():
	if checksDone > 100:
		var value = Engine.get_frames_per_second()
		if value < 10:
			get_tree().quit()
	else:
		checksDone += 1

func take_damage(amount):
	if invulnerable:
		return
	hp -= amount
	var dead = false
	if hp <= 0:
		dead = true
	var particle = damaged.instantiate()
	particle.dead = dead
	particle.global_position = global_position
	add_sibling(particle)
	if dead:
		die()

var vicTriggered = false
func trigger_victory():
	if vicTriggered:
		return
	else:
		vicTriggered = true
	$background.color = Color("yellow")
	var beam = (load("res://scenes/victorybeam.tscn")).instantiate()
	add_child(beam)
