extends Line2D

var update_chance := 0.50   # 15% chance per frame

var paused = false

@onready var parent = get_parent().get_parent()
@onready var this = self

var handType = "unknown"

var wander_target: Vector2
var wander_speed := 40.0
var wander_radius := 60.0
var wander_timer := 0.0
var wander_interval := 1.5

var root_wander_target: Vector2
var root_wander_speed := 20.0
var root_wander_timer := 0.0
var root_wander_interval := 2.0




func _ready():
	get_tree().root.get_child(0).pauseables.append(self)
	add_to_group("titan")
	add_to_group("harvester")
	add_to_group("enemy")
	
	if parent.global_position.y > global_position.y:
		handType = "bottom"
	else:
		handType = "top"
	
	if parent.global_position.x > global_position.x:
		handType = handType+"right"
	else:
		handType = handType+"left"
	
	print(handType)

func _rotate_toward(target_pos: Vector2, delta):
	var desired_angle = (target_pos - global_position).angle()
	rotation = lerp_angle(rotation, desired_angle, delta * 2.0)


func _update_root_wander(delta):
	root_wander_timer -= delta
	if root_wander_timer <= 0:
		_pick_root_wander_target()
		root_wander_timer = root_wander_interval

	# Smooth rotation toward target
	_rotate_toward(root_wander_target, delta)

	# Move root toward target
	var dir = (root_wander_target - global_position)
	if dir.length() > 1:
		global_position += dir.normalized() * root_wander_speed * delta



func _pick_root_wander_target():
	var offset = Vector2.ZERO

	match handType:
		"topleft":
			offset = Vector2(
				randf_range(-60, -20),
				randf_range(-60, -20)
			)
		"topright":
			offset = Vector2(
				randf_range(20, 60),
				randf_range(-60, -20)
			)
		"bottomleft":
			offset = Vector2(
				randf_range(-60, -20),
				randf_range(20, 60)
			)
		"bottomright":
			offset = Vector2(
				randf_range(20, 60),
				randf_range(20, 60)
			)

	root_wander_target = parent.global_position + offset




func _process(delta):
	if paused:
		return
	if randf() > update_chance:
		return
	_update_root_wander(delta)
	_update_wander(delta)
	_update_child_attachment()
	
	# your other logic here...

func _update_wander(delta):
	wander_timer -= delta
	if wander_timer <= 0:
		_pick_new_wander_target()
		wander_timer = wander_interval

	# Move endhand toward the target
	var dir = (wander_target - $endhand.global_position)
	if dir.length() > 1:
		$endhand.global_position += dir.normalized() * wander_speed * delta


func _pick_new_wander_target():
	var offset = Vector2.ZERO

	match handType:
		"topleft":
			offset = Vector2(
				randf_range(-wander_radius, -10),
				randf_range(-wander_radius, -10)
			)
		"topright":
			offset = Vector2(
				randf_range(10, wander_radius),
				randf_range(-wander_radius, -10)
			)
		"bottomleft":
			offset = Vector2(
				randf_range(-wander_radius, -10),
				randf_range(10, wander_radius)
			)
		"bottomright":
			offset = Vector2(
				randf_range(10, wander_radius),
				randf_range(10, wander_radius)
			)

	wander_target = parent.global_position + offset


func _update_child_attachment():
	# 1. Get parent tip in global space
	var parent_tip_global = to_global(points[1])

	# 2. Convert that global position into the child's local space
	var child_local_pos = $endhand.to_local(parent_tip_global)

	# 3. Attach child base to parent tip
	$endhand.points[0] = child_local_pos


func get_nearest_resource():
	if parent.resourcesFound.is_empty():
		return null

	var nearest = null
	var best_dist = INF

	for r in parent.resourcesFound:
		if r == null or !r.is_inside_tree():
			continue

		var d = global_position.distance_to(r.global_position)
		if d < best_dist:
			best_dist = d
			nearest = r

	return nearest


@onready var root = get_tree().root.get_child(0)
func consumeObject(item):
	if item.is_in_group("coin"):
		root.mapScore -= 1
		item.destroy()
	elif item.is_in_group("hp") and item.is_in_group("resource"):
		item.destroy()
	parent.unregister_resource(item)



func _on_detector_body_entered(body):
	if body.is_in_group("resource") and body not in parent.resourcesFound:
		parent.register_resource(body)


func _on_eat_body_entered(body):
	if body in parent.resourcesFound:
		consumeObject(body)
	elif body.is_in_group("player"):
		body.take_damage(5, "Annihilated by a harvester")
		


func _on_starttimer_timeout():
	$endhand/detector.monitoring = true
	$endhand/eat.monitoring = true
	$starttimer.queue_free()
