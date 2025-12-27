extends StaticBody2D


func _ready():
	add_to_group("obstacle")
	add_to_group("beneficial")
	


func _on_timer_timeout():
	var bodies = $detection.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("player"):
			b.healing(1)
