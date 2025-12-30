extends StaticBody2D

var bulletscene = preload("res://scenes/bullet.tscn")

@onready var root = get_tree().root.get_child(0)
var paused = false

var sUp = true
var sRight = true
var sLeft = true
var sDown = true

var active = true

func toggle():
	active = !active

func _ready():
	root.pauseables.append(self)
	add_to_group("hazard")
	add_to_group("cannon")
	add_to_group("obstacle")
	
	if randi_range(1,3) == 1:
		sUp = false
	if randi_range(1,3) == 1:
		sRight = false
	if randi_range(1,3) == 1:
		sDown = false
	if randi_range(1,3) == 1:
		sLeft = false
	
	
	if sUp == false:
		$up.queue_free()
	else:
		$up/uptimer.wait_time = randf_range(0.8, 1.6)
		$up/uptimer.start()
	if sRight == false:
		$right.queue_free()
	else:
		$right/righttimer.wait_time = randf_range(0.8, 1.6)
		$right/righttimer.start()
	if sLeft == false:
		$left.queue_free()
	else:
		$left/lefttimer.wait_time = randf_range(0.8, 1.6)
		$left/lefttimer.start()
	if sDown == false:
		$down.queue_free()
	else:
		$down/downtimer.wait_time = randf_range(0.8, 1.6)
		$down/downtimer.start()
	
	if sUp == false and sRight == false and sLeft == false and sDown == false:
		queue_free()

func _process(_delta):
	if paused:
		return
	if active != true:
		$CPUParticles2D.emitting = true
		if sUp:
			$up/uptimer.stop()
		if sLeft:
			$left/lefttimer.stop()
		if sRight:
			$right/righttimer.stop()
		if sDown:
			$down/downtimer.stop()
		return
	else:
		$CPUParticles2D.emitting = false
		if sUp:
			if $up/uptimer.is_stopped():
				$up/uptimer.start()
		if sLeft:
			if $left/lefttimer.is_stopped():
				$left/lefttimer.start()
		if sRight:
			if $right/righttimer.is_stopped():
				$right/righttimer.start()
		if sDown:
			if $down/downtimer.is_stopped():
				$down/downtimer.start()
			

func make_bullet(dir, pos):
	if paused:
		return
	var bullet = bulletscene.instantiate()
	bullet.direction = dir
	bullet.parent = self
	add_child(bullet)
	bullet.global_position = pos
	

func shootNoise():
	if paused:
		return
	var shot = $shot.duplicate()
	var pitch = randf_range(0.9, 1.1)
	shot.pitch_scale = pitch
	shot.connect("finished", Callable(shot, "queue_free"))
	shot.global_position = global_position
	add_sibling(shot)
	shot.play()

func getnewtime():
	return randf_range(0.8, 1.6)

func _on_uptimer_timeout():
	shootNoise()
	make_bullet(Vector2(0, -1), $up.global_position)
	$up/uptimer.wait_time = getnewtime()
	$up/uptimer.start()


func _on_righttimer_timeout():
	
	shootNoise()
	make_bullet(Vector2(1, 0), $right.global_position)
	$right/righttimer.wait_time = getnewtime()
	$right/righttimer.start()


func _on_downtimer_timeout():
	shootNoise()
	make_bullet(Vector2(0, 1), $down.global_position)
	$down/downtimer.wait_time = getnewtime()
	$down/downtimer.start()


func _on_lefttimer_timeout():
	shootNoise()
	make_bullet(Vector2(-1, 0), $left.global_position)
	$left/lefttimer.wait_time = getnewtime()
	$left/lefttimer.start()
