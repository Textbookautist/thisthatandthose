extends CharacterBody2D

var player = null
var playerLastSeen = null

var deadnimation = preload("res://scenes/particles/explosive.tscn")
@onready var root = get_tree().root.get_child(0)

var invulnerable = false
var hp = 4

func invulnerability(state):
	invulnerable = state

func die():
	var explosive = deadnimation.instantiate()
	explosive.amount = 12
	explosive.global_position = global_position
	
	add_sibling.call_deferred(explosive)
	queue_free()

func take_damage(amount, _source=null):
	if invulnerable:
		return
	hp -= amount
	if hp <= 0:
		die()

func _ready():
	root.pauseables.append(self)
	add_to_group("enemy")
	add_to_group("hazard")
	add_to_group("alive")
	
var checktime = 0
var gLeft = false
var gRight = false
var gUp = false
var gDown = false

func checkGs():
	var dir = velocity.normalized()

	# Look up
	if dir.y < -0.5:
		$ColorRect/left_eye.visible = false
		$ColorRect/right_eye.visible = false
		return

	# Look down
	if dir.y > 0.5:
		$ColorRect/left_eye.visible = true
		$ColorRect/right_eye.visible = true

		# Down-left
		if dir.x < -0.5:
			$ColorRect/right_eye.visible = false
			$ColorRect/left_eye.visible = true
			return

		# Down-right
		if dir.x > 0.5:
			$ColorRect/right_eye.visible = true
			$ColorRect/left_eye.visible = false
			return

		return

	# Neutral (not up/down)
	$ColorRect/left_eye.visible = true
	$ColorRect/right_eye.visible = true

	
var tiles = []
var curTiles = []
var teleporting = false
func safeMove(tile, mode):
	#if lifetime < 10:
		#return
	match mode:
		1:
			curTiles.append(tile)
			teleporting = false
		-1:
			curTiles.erase(tile)
	
	if curTiles.size() == 0:
		if teleporting:
			teleporting = false
			return
		take_damage(10)

var paused = false
func _process(_delta):
	if paused:
		return
	if collisionCooldown:
		$CollisionShape2D.disabled = true
	else:
		if $CollisionShape2D.disabled:
			$CollisionShape2D.disabled = false
	
	checkGs()
	
	
	
	if damageCooldown > 0:
		damageCooldown -= 1
		if damageCooldown <= 0:
			checkIfDamager()
	checktime += 1
	if checktime >= 10:
		if player != null:
			if player in $detection.get_overlapping_bodies():
				aggro = true
				playerLastSeen = player.global_position
			else:
				aggro = false
		checktime = 0

var speed = 55
var aggro = false
var patroltimer = 0
var patroldirection = Vector2(0,0)
func _physics_process(_delta):
	if paused:
		return
	
	var pos = global_position
	var pos2 = patroldirection
	
	if aggro:
		patroltimer = 0
		pos2 = playerLastSeen
		patroldirection = pos2
		if pos.distance_to(pos2) <= 2.0:
			return
	else:
		patroltimer += 1
		if patroltimer >= 32:
			patroltimer = 0
			var randx = pos.x + (randf_range(-10.0, 10.0))
			var randy = pos.y + (randf_range(-10.0, 10.0))
			pos2 = Vector2(randx, randy)
			patroldirection = pos2
		
	
	
	var direction = (pos2 - pos).normalized()
	if aggro:
		velocity = direction*speed
	else:
		velocity = direction*(speed*0.2)
	if pos.distance_to(patroldirection) < 1.0:
		velocity = Vector2.ZERO

	move_and_slide()

func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		if player == null:
			$shout.visible = true
			$shout/Timer.start()
		player = body
		playerLastSeen = player.global_position


func _on_detection_body_exited(body):
	if body == player:
		aggro = true
		playerLastSeen = player.global_position

func checkIfDamager():
	var things = $damager.get_overlapping_bodies()
	for t in things:
		if t.is_in_group("player"):
			_on_damager_body_entered(t)


var damageCooldown = 0
func _on_damager_body_entered(body):
	if damageCooldown > 0:
		return
	if body == player:
		player.take_damage(1, "Hit by an enemy")
		damageCooldown = 100
		collisionCooldown = true
		$CollisionShape2D/collisionTimer.start()


func _on_timer_timeout():
	$shout.visible = false

var collisionCooldown = false
func _on_collision_timer_timeout():
	collisionCooldown = false
