extends CharacterBody2D

var color = null

# Movement tuning
var wander_speed = 40.0
var wander_change_interval = 1.5
var wander_timer = 0.0
var wander_direction = Vector2.ZERO

# Circling tuning
var circle_center := Vector2.ZERO
var circle_radius := 40.0
var circle_angle := 0.0
var circle_speed := 1.5   # radians per second

var state = 0
var states = ["wandering", "idling", "circling", "standing", "chatting"]

func _ready():
	add_to_group("alive")
	add_to_group("colorhost")
	$base.color = color

	# Start wandering by default
	state = states.find("wandering")
	_pick_new_wander_direction()


func _physics_process(delta):
	match states[state]:
		"wandering":
			_do_wandering(delta)
		"circling":
			_do_circling(delta)
		_:
			velocity = Vector2.ZERO
	
	move_and_slide()

func _do_wandering(delta):
	wander_timer -= delta

	# Pick a new direction occasionally
	if wander_timer <= 0:
		_pick_new_wander_direction()

	velocity = wander_direction * wander_speed

func _pick_new_wander_direction():
	wander_timer = wander_change_interval + randf_range(-0.5, 0.5)
	wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _do_circling(delta):
	circle_angle += circle_speed * delta

	var offset = Vector2(
		cos(circle_angle),
		sin(circle_angle)
	) * circle_radius

	var target_pos = circle_center + offset
	var direction = (target_pos - global_position).normalized()

	velocity = direction * wander_speed
