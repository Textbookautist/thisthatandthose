extends CharacterBody2D


var dev = false

func _ready() -> void:
	add_to_group("player")
	
	

#gameplay statistics
var score = 0
var hp = 10


var goingUp = false
var goingDown = false
var goingRight = false
var goingLeft = false

var speed = 60
func _physics_process(_delta: float) -> void:
	var movement = Vector2(0,0)
	if goingUp:
		movement.y = -1*speed
	if goingDown:
		movement.y = speed
	if goingRight:
		movement.x = speed
	if goingLeft:
		movement.x = -1*speed
	
	velocity = movement
	#print(str(velocity))
	move_and_slide()

var timer = 0
func _process(_delta: float) -> void:
	timer += 1
	if timer >= 1000:
		print(str(global_position))
		timer = 0
	if Input.is_action_pressed("ui_up"):
		goingUp = true
	else:
		goingUp = false
	
	if Input.is_action_pressed("ui_down"):
		goingDown = true
	else:
		goingDown = false
	
	if Input.is_action_pressed("ui_left"):
		goingLeft = true
	else:
		goingLeft = false
	
	if Input.is_action_pressed("ui_right"):
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
	
	
