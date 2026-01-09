extends StaticBody2D

@onready var main = get_tree().root.get_child(0)

@onready var turret = $turret
@onready var powerLight = $turret/core/powerIndicator
@onready var bulletScene = preload("res://scenes/bullet.tscn")

@onready var left_shot = $turret/core/leftBarrel/leftMuzzle/leftShot
@onready var right_shot = $turret/core/rightBarrel/rightMuzzle/rightShot

const SPRITE_FORWARD_ANGLE := -PI / 2.0  # the angle (in radians) your barrel points at when rotation = 0


var targets: Array = []
var current_target: Node2D = null

var fire_rate := 0.1
var fire_cooldown := 0.0
var rotation_speed := 6.0
var last_barrel := "right"

var powered := false
var paused := false
var active := false

func _ready():
	add_to_group("turret")
	add_to_group("spectral")
	main.pauseables.append(self)
	main.utilities.append(self)
	

func _process(delta):
	if paused or not powered or not active:
		powerLight.color = Color.RED
		return

	powerLight.color = Color.GREEN

	fire_cooldown -= delta
	if rightMoved > 0:
		rightMoved -= 0.5
		$turret/core/rightBarrel.position.y -= 0.5
	if leftMoved > 0:
		leftMoved -= 0.5
		$turret/core/leftBarrel.position.y -= 0.5
	
	update_target()

	if current_target:
		aim_and_fire(delta)


# -----------------------------
# TARGET SELECTION
# -----------------------------
func update_target():
	# Remove invalid or freed targets
	targets = targets.filter(func(t): return is_instance_valid(t))

	if targets.is_empty():
		current_target = null
		return

	# Pick closest
	current_target = targets[0]
	var closest_dist = global_position.distance_to(current_target.global_position)

	for t in targets:
		var d = global_position.distance_to(t.global_position)
		if d < closest_dist:
			current_target = t
			closest_dist = d


# -----------------------------
# AIMING + FIRING
# -----------------------------
func aim_and_fire(delta):
	var target_pos = current_target.global_position
	var to_target = (target_pos - turret.global_position).normalized()
	var target_angle = to_target.angle()

	# Rotate so that the barrel (sprite forward) points at the target
	var desired_turret_angle = target_angle - SPRITE_FORWARD_ANGLE
	turret.rotation = lerp_angle(turret.rotation, desired_turret_angle, rotation_speed * delta)

	# Compute the angle the barrel is *actually* pointing at
	var barrel_angle = turret.rotation + SPRITE_FORWARD_ANGLE
	var angle_diff = wrapf(barrel_angle - target_angle, -PI, PI)

	# Only fire when barrel is aligned
	if abs(angle_diff) < deg_to_rad(8):
		if fire_cooldown <= 0.0:
			fire_bullet(to_target)
			fire_cooldown = fire_rate



# -----------------------------
# BULLET FIRING
# -----------------------------
var leftMoved = 0
var rightMoved = 0
func fire_bullet(direction: Vector2):
	var bullet = bulletScene.instantiate()
	bullet.direction = direction.normalized()

	var spawn_pos: Vector2
	if last_barrel == "right":
		spawn_pos = left_shot.global_position
		last_barrel = "left"
		leftMoved = 5.0
		$turret/core/leftBarrel.position.y += 5
	else:
		spawn_pos = right_shot.global_position
		last_barrel = "right"
		rightMoved = 5.0
		$turret/core/rightBarrel.position.y += 5
	bullet.damage = 1
	bullet.global_position = spawn_pos
	get_tree().current_scene.add_child(bullet)


# -----------------------------
# DETECTOR SIGNALS
# -----------------------------
func _on_detector_body_entered(body):
	if body.is_in_group("enemy") and body.is_in_group("alive"):
		targets.append(body)

func _on_detector_body_exited(body):
	if body in targets:
		targets.erase(body)
