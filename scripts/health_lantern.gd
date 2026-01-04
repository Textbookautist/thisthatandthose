extends StaticBody2D

var timeDecrease = 1

func _ready():
	add_to_group("obstacle")
	add_to_group("beneficial")
	if timeDecrease != 0:
		$Timer.wait_time = $Timer.wait_time / timeDecrease
	


func _on_timer_timeout():
	var bodies = $detection.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("player"):
			b.healing(1)
