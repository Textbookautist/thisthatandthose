extends RigidBody2D

var speed = 2400

@onready var root = get_tree().root.get_child(0)
var paused = false
func _ready():
	root.pauseables.append(self)
	add_to_group("hazard")
	var newPitch = randf_range(0.9,1.1)
	$shot.pitch_scale = newPitch

func _process(_delta):
	if paused:
		return
	var pos = global_position
	var pos2 = null
	var _distance = null
	if player != null:
		pos2 = player.global_position
		_distance = pos.distance_to(pos2)
		
	if _distance != null and _distance < 4.0:
		speed = 5*60
	else:
		speed = randi_range(30,40)*60
	
	if pos2 != null and seesPlayer:
		var direction = (pos2 - pos).normalized()
		linear_velocity = direction*speed*_delta

var player = null
var seesPlayer = false
func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		player = body
		seesPlayer = true


func _on_detection_body_exited(body):
	if body.is_in_group("player"):
		if player == null:
			player = body
		seesPlayer = false


func _on_shooty_body_entered(body):
	if body == player:
		$shooty/Timer.start()
		var rects = $reticle.get_children()
		for r in rects:
			r.color = Color("red")
		var corners = $corners.get_children()
		for c in corners:
			c.color = Color("red")


func _on_shooty_body_exited(body):
	if body == player:
		$shooty/Timer.stop()
		var rects = $reticle.get_children()
		for r in rects:
			r.color = Color("white")
		var corners = $corners.get_children()
		for c in corners:
			c.color = Color("white")


func _on_timer_timeout():
	var bodies = $shooty.get_overlapping_bodies()
	for b in bodies:
		if b == player:
			var s = $shot.duplicate()
			s.connect("finished", Callable(s, "queue_free"))
			add_sibling(s)
			s.play()
			b.take_damage(5, "Sniper takedown")
			queue_free()
