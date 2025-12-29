extends StaticBody2D


func _ready():
	add_to_group("obstacle")
	add_to_group("terrain")

func destroyObstacle():
	var p = $particles.duplicate()
	add_sibling(p)
	p.connect("finished", Callable(p, "queue_free"))
	p.emitting = true
	queue_free()
