extends StaticBody2D


func _ready():
	add_to_group("obstacle")
	add_to_group("terrain")

func destroyObstacle():
	queue_free()
