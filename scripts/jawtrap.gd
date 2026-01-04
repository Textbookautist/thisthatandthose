extends StaticBody2D

var storedSpeed = null
var stoppedEntity = null
var active = false

@onready var bottom = $jaw/bottom
@onready var top = $jaw/top
@onready var left = $jaw/leftSupport
@onready var right = $jaw/rightSupport

func _ready():
	add_to_group("hazard")
	add_to_group("jawtrap")
	rotate(randi_range(-180, 180))

func closeJaws():
	bottom.position.y -= 15
	top.position.y += 15
	
	left.size.y -= 8
	left.position.y -= 8
	right.size.y -= 8
	right.position.y -= 8

func openJaws():
	bottom.position.y += 15
	top.position.y -= 15
	
	left.size.y += 8
	left.position.y += 8
	right.size.y += 8
	right.position.y += 8

func activate(entity):
	active = true
	storedSpeed = entity.speed
	entity.speed = 0
	stoppedEntity = entity
	$stopper.start()
	closeJaws()

func deactivate():
	active = false
	if is_instance_valid(stoppedEntity):
		stoppedEntity.speed = storedSpeed
	stoppedEntity = null
	storedSpeed = null
	openJaws()

func _on_btn_body_entered(body):
	if active:
		return
	if body.is_in_group("player") or body.is_in_group("alive"):
		activate(body)
		body.take_damage(1, "Bit by a jawtrap")


func _on_stopper_timeout():
	deactivate()
