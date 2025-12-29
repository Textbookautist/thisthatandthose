extends StaticBody2D


@onready var root = get_tree().root.get_child(0)
var paused = false
var particle = preload("res://scenes/particles/explosive.tscn")

var phase = 0

func _ready():
	root.pauseables.append(self)
	add_to_group("hazard")
	add_to_group("explosive")
	add_to_group("bomb")
	var newpitch = randf_range(0.9, 1.1)
	$boom.pitch_scale = newpitch


func _on_detector_body_entered(body):
	if phase != 0:
		return
	if body.is_in_group("player") or body.is_in_group("alive"):
		phase = 1
		$last0/last1/last2/last3/last4/last5/last6/last7.color = Color("yellow")
		$boomtimer.start()

func trigger():
	phase = 1
	$last0/last1/last2/last3/last4/last5/last6/last7.color = Color("yellow")
	$boomtimer.start()

func explode():
	var parent = get_parent()
	var boom = $boom.duplicate()
	parent.add_child(boom)
	boom.connect("finished", Callable(boom, "queue_free"))
	boom.play()
	var playable = particle.instantiate()
	add_sibling(playable)
	var things = $detector.get_overlapping_bodies()
	for t in things:
		if t.is_in_group("player") or t.is_in_group("alive"):
			var dist = global_position.distance_to(t.global_position)
			var damage = 10 - int(dist/10)
			t.take_damage(damage)
		if t.is_in_group("bomb"):
			if t.phase == 0:
				t.trigger()
		if t.is_in_group("hazard"):
			if "active" in t:
				if t.active:
					t.toggle()
		if "destroyObstacle" in t:
			t.destroyObstacle()
	queue_free()

func _on_boomtimer_timeout():
	if paused:
		return
	$detector/CollisionShape2D2/ColorRect.color.a += 0.02
	match phase:
		1:
			$last0/last1/last2/last3/last4/last5/last6/last7.queue_free()
			$last0/last1/last2/last3/last4/last5/last6.color = Color("yellow")
			phase = 2
			return
		2:
			$last0/last1/last2/last3/last4/last5/last6.queue_free()
			$last0/last1/last2/last3/last4/last5.color = Color("yellow")
			phase = 3
			return
		3:
			$last0/last1/last2/last3/last4/last5.queue_free()
			$last0/last1/last2/last3/last4.color = Color("yellow")
			phase = 4
			return
		4:
			$last0/last1/last2/last3/last4.queue_free()
			$last0/last1/last2/last3.color = Color("yellow")
			phase = 5
			return
		5:
			$last0/last1/last2/last3.queue_free()
			$last0/last1/last2.color = Color("yellow")
			phase = 6
			return
		6:
			$last0/last1/last2.queue_free()
			$last0/last1.color = Color("yellow")
			phase = 7
			return
		7:
			$last0/last1.queue_free()
			$last0.color = Color("yellow")
			phase = 8
			return
		8:
			$last0.queue_free()
			$boomtimer.queue_free()
			explode()
