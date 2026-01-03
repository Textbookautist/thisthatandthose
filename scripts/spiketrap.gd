extends Node2D

var spikes = []

var hurtyTime = false

func _ready():
	add_to_group("hazard")
	add_to_group("trap")
	for h in $holes.get_children():
		for c in h.get_children():
			spikes.append(c)
			c.visible = false




func activate():
	if cooldown:
		return
	var pitch = randf_range(0.9,1.1)
	$noise.pitch_scale = pitch
	$noise.play()
	$traptimer.start()
	
	
		
	for spike in spikes:
		spike.visible = true
		hurtyTime = true

var cooldown = false
func _on_area_2d_body_entered(body):
	if cooldown:
		return
	if body.is_in_group("player") or body.is_in_group("alive"):
		activate()
		if body in $hurtyTime.get_overlapping_bodies():
			_on_hurty_time_body_entered(body)


func _on_hurty_time_body_entered(body):
	if hurtyTime != true:
		return
	else:
		if body.is_in_group("player") or body.is_in_group("alive"):
			body.take_damage(5, "Stepped into a spiketrap")


func _on_traptimer_timeout():
	cooldown = false
	hurtyTime = false
	for spike in spikes:
		spike.visible = false
