extends CharacterBody2D


@onready var data: Resource = load("res://files/savedata.tres")
var points = 0
var primeColor = null
var selectedColor = null
var ownedColors = []


var goingUp = false
var goingDown = false
var goingRight = false
var goingLeft = false

func updatePoints():
	data = load("res://files/savedata.tres")
	points = data.collectedPoints
	ownedColors = data.ownedColors

func _ready():
	add_to_group("player")
	primeColor = data.primeColor
	if data.selectedColor == null:
		selectedColor = primeColor
	else:
		selectedColor = data.selectedColor

	ownedColors = data.ownedColors
	points = data.collectedPoints
	$base.color = selectedColor
	$Camera2D/Label.text = "Points collected: "+str(data.collectedPoints)

var speed = 60
func _physics_process(_delta: float) -> void:
	if lockedInPlace:
		return
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
	if Input.is_action_pressed("space"):
		if sprinting:
			movement = movement*10
		else:
			movement = movement*30
	velocity = movement
	
	#print(str(velocity))
	move_and_slide()

var lockedInPlace = false
func _process(_delta):
	
	if lockedInPlace:
		return
	
	$Camera2D/Label.text = "Collected points: "+str(points)
	
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

func changeColor(c):
	$base.color = c
	data.selectedColor = c
	ResourceSaver.save(data, "res://files/savedata.tres")
