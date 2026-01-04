extends RigidBody2D

var spindirection = 60
var collectDistanceBonus = null
var pos = null

func _ready():
	pos = global_position
	add_to_group("resource")
	add_to_group("coin")
	if randi_range(1,2) == 1:
		spindirection = 60
	else:
		spindirection = -60
	var newPitch = randf_range(0.9, 1.1)
	$pick.pitch_scale = newPitch
	
	get_tree().root.get_child(0).mapScore += 1

func destroy():
	$RigidBody2D.queue_free()
	queue_free()


func _process(_delta):
	global_position = pos
	$RigidBody2D.angular_velocity = spindirection * _delta
	
	var detection = $detector.get_overlapping_bodies()
	detection.erase(self)
	for e in detection:
		if e.is_in_group("player"):
			var aud = $pick.duplicate()
			aud.connect("finished", Callable(aud, "queue_free"))
			add_sibling(aud)
			aud.play()
			e.score += 1
			destroy()


func _on_detector_timer_timeout():
	$detector/detectorTimer.queue_free()

	if collectDistanceBonus != null:
		var new_radius = 10 + (collectDistanceBonus * 2)

		var new_shape := CircleShape2D.new()
		new_shape.radius = new_radius

		$detector/CollisionShape2D.shape = new_shape

		print("New radius: ", new_radius)
