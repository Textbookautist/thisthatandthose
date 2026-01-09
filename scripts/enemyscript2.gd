extends CharacterBody2D

var player: Node2D = null
var playerLastSeen: Vector2 = Vector2.ZERO

@onready var deadnimation = preload("res://scenes/particles/explosive.tscn")
@onready var root = get_tree().root.get_child(0)

var invulnerable: bool = false
var hp: int = 4

# --- PAUSE / AGGRO / MOVEMENT STATE ---
var paused: bool = false
var aggro: bool = false
var speed: float = 45.0

var patrol_target: Vector2 = Vector2.ZERO

# timers for throttling expensive checks
var t_player_check: float = 0.0
var t_detection_check: float = 0.0
var t_patrol_pick: float = 0.0

# lifetime & collisions
var lifetime: float = 0.0
var collisionCooldown: bool = false
var damageCooldown: float = 0.0

# tile safety
var curTiles: Array = []
var teleporting: bool = false

# -----------------------------
# CORE LIFECYCLE
# -----------------------------
func _ready():
	root.pauseables.append(self)
	add_to_group("enemy")
	add_to_group("hazard")
	add_to_group("alive")
	add_to_group("grayscale")

	# try to grab the player initially (you also have _on_playerfinder_timeout)
	player = root.find_child("player")
	
	global_position.x += randi_range(-10,10)
	global_position.y += randi_range(-10,10)

func invulnerability(state: bool):
	invulnerable = state

func die():
	call_deferred("queue_free")

func take_damage(amount: int, _source = null):
	if invulnerable:
		return

	var explosive = deadnimation.instantiate()
	explosive.amount = 12
	add_sibling.call_deferred(explosive)
	explosive.global_position = global_position
	explosive.emitting = true

	hp -= amount
	if hp <= 0:
		die()

# -----------------------------
# TILE SAFETY
# -----------------------------
func safeMove(tile, mode: int):
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

# -----------------------------
# PER-FRAME LOGIC (LIGHT)
# -----------------------------
func _process(delta: float):
	# lifetime / collision enabling
	if lifetime < 15.0:
		lifetime += delta
	else:
		if $CollisionShape2D.disabled:
			$CollisionShape2D.disabled = false
		if collisionCooldown:
			$CollisionShape2D.disabled = true
		else:
			if $CollisionShape2D.disabled:
				$CollisionShape2D.disabled = false

	# damage cooldown
	if damageCooldown > 0.0:
		damageCooldown -= delta
		if damageCooldown <= 0.0:
			checkIfDamager()

	# eyes
	update_eyes()

	# throttled checks
	t_player_check -= delta
	if t_player_check <= 0.0:
		t_player_check = 0.25
		checkplayer()

	t_detection_check -= delta
	if t_detection_check <= 0.0:
		t_detection_check = 0.1
		update_aggro_state()

	# patrol choosing only when not aggro
	if not aggro:
		t_patrol_pick -= delta
		if t_patrol_pick <= 0.0:
			t_patrol_pick = 0.5
			pick_new_patrol_point()

# -----------------------------
# MOVEMENT / PHYSICS
# -----------------------------
func _physics_process(_delta: float):
	if paused:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var target: Vector2

	if aggro and playerLastSeen != Vector2.ZERO:
		target = playerLastSeen
	else:
		target = patrol_target

	var dir: Vector2 = target - global_position

	if dir.length() < 2.0:
		velocity = Vector2.ZERO
	else:
		var move_speed: float = speed if aggro else speed * 0.25
		velocity = dir.normalized() * move_speed

	move_and_slide()

# -----------------------------
# PLAYER / AGGRO LOGIC
# -----------------------------
func checkplayer():
	if not is_instance_valid(player):
		return

	var distance: float = global_position.distance_to(player.global_position)

	# far away → pause AI and movement
	if distance > 1500.0:
		paused = true
	else:
		if not player.paused:
			paused = false

func update_aggro_state():
	if not is_instance_valid(player):
		aggro = false
		return

	var bodies = $detection.get_overlapping_bodies()
	if player in bodies:
		aggro = true
		playerLastSeen = player.global_position
	# else: keep current aggro; they'll keep moving to last seen

func pick_new_patrol_point():
	var pos: Vector2 = global_position
	patrol_target = pos + Vector2(
		randf_range(-10.0, 10.0),
		randf_range(-10.0, 10.0)
	)

# -----------------------------
# VISUALS (EYES)
# -----------------------------
func update_eyes():
	var dir: Vector2 = velocity.normalized()

	# Up
	if dir.y < -0.5:
		$ColorRect/left_eye.visible = false
		$ColorRect/right_eye.visible = false
		return

	# Down
	if dir.y > 0.5:
		$ColorRect/left_eye.visible = true
		$ColorRect/right_eye.visible = true
		if dir.x < -0.5:
			$ColorRect/right_eye.visible = false
		elif dir.x > 0.5:
			$ColorRect/left_eye.visible = false
		return

	# Neutral
	$ColorRect/left_eye.visible = true
	$ColorRect/right_eye.visible = true

# -----------------------------
# DAMAGE AREA
# -----------------------------
func checkIfDamager():
	var things = $damager.get_overlapping_bodies()
	for t in things:
		if t.is_in_group("player"):
			_on_damager_body_entered(t)

func _on_damager_body_entered(body):
	if damageCooldown > 0.0:
		return
	if body == player:
		player.take_damage(1, "Hit by an enemy")
		damageCooldown = 1.6    # ~100 frames at 60fps, but time-based
		collisionCooldown = true
		$CollisionShape2D/collisionTimer.start()

# -----------------------------
# DETECTION SIGNALS
# -----------------------------
func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		if player == null:
			$shout.visible = true
			$shout/Timer.start()
		player = body
		playerLastSeen = player.global_position
		aggro = true

func _on_detection_body_exited(body):
	if body == player:
		# keep aggro, but stop getting fresh positions
		playerLastSeen = player.global_position

# -----------------------------
# UI / TIMERS
# -----------------------------
func _on_timer_timeout():
	$shout.visible = false

func _on_collision_timer_timeout():
	collisionCooldown = false

func _on_playerfinder_timeout():
	player = root.find_child("player")
