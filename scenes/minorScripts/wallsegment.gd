extends StaticBody2D

@onready var parent = get_parent()

func destroyObstacle():
	var p = $particles.duplicate()
	p.connect("finished", Callable(p, "queue_free"))
	parent.add_sibling(p)
	p.emitting = true
	var c = $crack.duplicate()
	c.connect("finished", Callable(c, "queue_free"))
	get_parent().add_sibling(c)
	c.play()
	parent.remove(self)
	queue_free()

func _on_detection_body_entered(body):
	var globpos = global_position
	if body.is_in_group("player"):
		if body.velocity.x > 0 and (body.global_position.x < globpos.x):
			destroyObstacle()
		elif  body.velocity.x < 0 and (body.global_position.x > globpos.x):
			destroyObstacle()
		elif body.velocity.y > 0 and (body.global_position.y < globpos.y):
			destroyObstacle()
		elif body.velocity.y < 0 and (body.global_position.y > globpos.y):
			destroyObstacle()
