extends StaticBody2D

var bulletscene = preload("res://scenes/bullet.tscn")

var sUp = true
var sRight = true
var sLeft = true
var sDown = true

func _ready():
	add_to_group("hazard")
	add_to_group("cannon")
	add_to_group("obstacle")
	
	var sides = [sUp, sRight, sLeft, sDown]
	for s in sides:
		if randi_range(1,3) > 1:
			s = false
	
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
	

func make_bullet(dir, pos):
	var bullet = bulletscene.instantiate()
	bullet.direction = dir
	bullet.parent = self
	add_child(bullet)
	bullet.global_position = pos
	

func getnewtime():
	return randf_range(0.8, 1.6)

func _on_uptimer_timeout():
	make_bullet(Vector2(0, -1), $up.global_position)
	$up/uptimer.wait_time = getnewtime()
	$up/uptimer.start()


func _on_righttimer_timeout():
	make_bullet(Vector2(1, 0), $right.global_position)
	$right/righttimer.wait_time = getnewtime()
	$right/righttimer.start()


func _on_downtimer_timeout():
	make_bullet(Vector2(0, 1), $down.global_position)
	$down/downtimer.wait_time = getnewtime()
	$down/downtimer.start()


func _on_lefttimer_timeout():
	make_bullet(Vector2(-1, 0), $left.global_position)
	$left/lefttimer.wait_time = getnewtime()
	$left/lefttimer.start()
