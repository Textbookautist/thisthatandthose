extends StaticBody2D

var timeDecrease = 1

@onready var hpScene = preload("res://scenes/health.tscn")

func _ready():
	add_to_group("obstacle")
	add_to_group("beneficial")
	if timeDecrease != 0:
		$Timer.wait_time = $Timer.wait_time / timeDecrease
	

func destroyObstacle():
	$CollisionShape2D.disabled = true
	var list = [$detection, $Timer, $CPUParticles2D, $CollisionShape2D]
	while list.size() != 0:
		list[0].queue_free()
		list.erase(list[0])
	$ColorRect.size.y = 2
	$ColorRect.rotation_degrees += randi_range(-10,10)
	$ColorRect.position.y = 0
	$ColorRect/ColorRect.position.x += randi_range(-10, 10)
	$ColorRect/ColorRect.rotation_degrees += randi_range(-20, 20)
	$ColorRect.z_index = 0
	$ColorRect/ColorRect.z_index = 0
	$ColorRect/ColorRect2.z_index = 0
	$ColorRect/ColorRect2.rotation_degrees += randi_range(-20, 20)
	$ColorRect/ColorRect2.position.y -= randi_range(3, 7)
	
	var hp = hpScene.instantiate()
	hp.global_position = global_position
	get_tree().root.get_child(0).add_child(hp)

func _on_timer_timeout():
	var bodies = $detection.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("player"):
			b.healing(1)
