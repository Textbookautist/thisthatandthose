extends CharacterBody2D


var dev = false

func _ready() -> void:
	add_to_group("player")
	
	if dev:
		$CollisionShape2D.disabled = true
		speed = 600
		add_to_group("admin")

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
