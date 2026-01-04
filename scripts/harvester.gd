extends CharacterBody2D

var paused = false

@onready var root = get_tree().root.get_child(0)

@onready var mainHand = $leftHand/tophand

var resourcesFound: Array = []

func get_tendrils():
	return get_tree().get_nodes_in_group("harvester")

func get_nearest_resource():
	if resourcesFound.is_empty():
		return null

	var nearest = null
	var best_dist = INF

	for r in resourcesFound:
		if r == null or !r.is_inside_tree():
			continue

		var d = global_position.distance_to(r.global_position)
		if d < best_dist:
			best_dist = d
			nearest = r

	return nearest

func get_closest_tendril_to(resource):
	var tendrils = get_tendrils()
	if tendrils.is_empty():
		return null

	var best = null
	var best_dist = INF

	for t in tendrils:
		var d = t.global_position.distance_to(resource.global_position)
		if d < best_dist:
			best_dist = d
			best = t

	return best

func _physics_process(delta):
	if paused:
		return
	var target = get_nearest_resource()
	if target:
		var dir = (target.global_position - global_position).normalized()
		velocity = dir * 40.0 * delta*60
	else:
		velocity = Vector2.ZERO
	
	if self_modulate.a < 0.9:
		$mouth.monitoring = false
	else:
		$mouth.monitoring = true
	
	if self_modulate.a < 1.0:
		self_modulate.a += 0.01 * delta * 60

	move_and_slide()

func register_resource(body):
	if body not in resourcesFound:
		resourcesFound.append(body)

func unregister_resource(body):
	resourcesFound.erase(body)


func _ready():
	root.pauseables.append(self)
	add_to_group("enemy")
	add_to_group("harvesterEnemy")
	add_to_group("titan")
	get_tendrils()
	toggleCollision()

var colliding = false
func toggleCollision():
	colliding = !colliding
	$bigcol.disabled = colliding
	$topcol.disabled = colliding
	$colright.disabled = colliding
	$colleft.disabled = colliding


func _on_mouth_body_entered(body):
	if body.is_in_group("resource"):
		mainHand.consumeObject(body)
	elif body.is_in_group("player"):
		body.take_damage(10, "Consumed by harvester")


@onready var noisetimer1 = $noise/noisetimer1
@onready var noisetimer2 = $noise2/noisetimer2
func playnoise1():
	var pitch = randf_range(0.8,1.2)
	$noise.pitch_scale = pitch
	$noise.play()
	noisetimer1.start()

func _on_noisetimer_1_timeout():
	playnoise1()


func _on_noisetimer_2_timeout():
	var waitingTime = randf_range(1.8, 3.5)
	noisetimer2.wait_time = waitingTime
	noisetimer2.start()
	var pitch = randf_range(0.5, 1.1)
	$noise2.pitch_scale = pitch
	$noise2.play()
