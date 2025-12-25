extends RigidBody2D


var direction = Vector2(1, 0)
var speed = 400
var damage = 2

var parent = null

func _ready():
	add_to_group("bullet")
	add_to_group("hazard")

func destroy():
	queue_free()


var prevCoordinates
func _process(_delta):
	if global_position == prevCoordinates:
		destroy()
	prevCoordinates = global_position

func _physics_process(_delta):
	linear_velocity = direction*speed


func _on_detector_body_entered(body):
	if body == self or body == parent:
		return
	if body.is_in_group("player") or body.is_in_group("alive"):
		body.take_damage(damage)
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


func _on_lifetimer_timeout():
	destroy()
