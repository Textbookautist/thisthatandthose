extends RigidBody2D

var spindirection = 0

func _ready():
	add_to_group("coin")
	if randi_range(1,2) == 1:
		spindirection = 1
	else:
		spindirection = -1

func _process(_delta):
	$RigidBody2D.angular_velocity = spindirection
	
	var detection = $detector.get_overlapping_bodies()
	detection.erase(self)
	for e in detection:
		if e.is_in_group("player"):
			e.score += 1
			queue_free()
