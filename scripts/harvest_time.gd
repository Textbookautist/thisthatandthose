extends Timer

@onready var scene = preload("res://scenes/harvester.tscn")
var pos

func _ready():
	var waitTime = randf_range(25.0, 45.0)
	wait_time = waitTime
	start()

func _on_timeout():
	var harvester = scene.instantiate()
	add_sibling(harvester)
	harvester.global_position = pos
	queue_free()
