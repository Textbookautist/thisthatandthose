extends StaticBody2D

@onready var pommel = $pommel

func _ready():
	add_to_group("hazard")

func slam():
	pommel.position.y = 0
	pommel.modulate.a = 1.0
	$CollisionShape2D.disabled = false
	$pommel/CollisionShape2D.disabled = false
	var list = $detector.get_overlapping_bodies()
	for entity in list:
		if entity.is_in_group("player") or entity.is_in_group("alive"):
			entity.take_damage(8, "Pommeler crush")
	$particles.emitting = true
	waiting = true
	$noise.play()

func checkplayer():
	if is_instance_valid(player) == false:
		return
	else:
		var distance = global_position.distance_to(player.global_position)
		if distance > 1500:
			paused = true
		else:
			if player.paused != true:
				paused = false

var waiting = false
var reloading = true
var status = 0
var hanging = 0
var paused = false
func _process(_delta):
	checkplayer()
	if paused:
		return
	if reloading:
		$pommel.position.y -= 60 * _delta
		$pommel.modulate.a -= 0.60 * _delta
		$CollisionShape2D.disabled = true
		$pommel/CollisionShape2D.disabled = true
	else:
		if waiting != true:
			slam()
	if waiting != true:
		status += 60 * _delta
		if status > 500:
			status = 0
			reloading = false
	else:
		hanging += 60  * _delta
		if hanging > 500:
			hanging = 0
			waiting = false
			reloading = true

var player = null
func _on_playerfinder_timeout():
	player = get_tree().root.get_child(0).find_child("player")
