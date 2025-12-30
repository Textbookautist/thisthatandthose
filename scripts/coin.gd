extends RigidBody2D

var spindirection = 60

func _ready():
	add_to_group("coin")
	if randi_range(1,2) == 1:
		spindirection = 60
	else:
		spindirection = -60
	var newPitch = randf_range(0.9, 1.1)
	$pick.pitch_scale = newPitch
	
	get_tree().root.get_child(0).mapScore += 1

func _process(_delta):
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
			queue_free()
