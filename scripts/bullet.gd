extends RigidBody2D


var direction = Vector2(1, 0)
var speed = 18000
var damage = 2

@onready var root = get_tree().root.get_child(0)
var paused = false

var parent = null

var speedDecrease = 1.0

func _ready():
	root.pauseables.append(self)
	if root.paused:
		paused = true
	add_to_group("bullet")
	add_to_group("hazard")
	var newPitch = randf_range(0.9, 1.1)
	$hit.pitch_scale = newPitch
	speed = speed*speedDecrease

func destroy():
	var aud = $hit.duplicate()
	aud.connect("finished", Callable(aud, "queue_free"))
	add_sibling(aud)
	aud.play()
	queue_free()


var prevCoordinates
func _process(_delta):
	
	$ColorRect.rotation_degrees += 1*_delta
	$ColorRect2.rotation_degrees += 1*_delta
	if paused:
		return

	if global_position == prevCoordinates:
		destroy()
	prevCoordinates = global_position

func _physics_process(_delta):
	
	if paused:
		return
	linear_velocity = direction*speed*_delta


func _on_detector_body_entered(body):
	if body == self or body == parent:
		return
	if body.is_in_group("player") or body.is_in_group("alive"):
		body.take_damage(damage, "Hit by a bullet")
		destroy()
	elif body.is_in_group("obstacle"):
		destroy()
	elif body.is_in_group("bullet"):
		body.destroy()
		destroy()
	elif body.is_in_group("bomb"):
		if body.phase != 0:
			return
		body.trigger()
		destroy()
	else:
		destroy()

func take_damage(_amount):
	destroy()

func _on_lifetimer_timeout():
	destroy()
