extends StaticBody2D

var datapath = "user://files/savedata.tres"
@onready var data = load(datapath)

var testing = false

func _ready():
	if testing != true:
		$test_timer.queue_free()
		$Camera2D.queue_free()
	add_to_group("obstacle")
	add_to_group("chest")
	var randR = randi_range(0,255)
	var randG = randi_range(0,255)
	var randB = randi_range(0,255)
	$loot/color.color = Color8(randR, randG, randB, 0)

var opened = false
func open():
	if opened:
		return
	$lid/CollisionShape2D.disabled = false
	$left_particle.emitting = true
	$right_particle.emitting = true
	opened = true
	$PinJoint2D.queue_free()
	var randx = randf_range(-0.8, 0.8)
	var randy = randf_range(-20.0, -10.0)
	var randspin = randf_range(-1.0, 1.0)
	$lid.linear_velocity += Vector2(randx, randy)
	$lid.angular_velocity += randspin

func _physics_process(_delta):
	pass

var spinning = false
var spinphase = 0
var raised = 0
var ending = false
func _process(_delta):
	if opened:
		spinphase += 1
		spinning = true
	
	if opened:
		$lid.modulate.a -= 0.01
	
	if opened and spinning:
		if raised < 300:
			$loot.position.y -= 0.1
		if raised > 100:
			$loot/color.color.a += 0.01
			$loot.z_index = 2
		raised += 1
		if spinphase > 400 and ending == false:
			ending = true
			$loot/color/CPUParticles2D.color = $loot/color.color
			$loot/color/CPUParticles2D.emitting = true
			$killtimer.start()
			var colordata = data.ownedColors
			var newColor = $loot/color.color
			var convertedColor = Color8(int(newColor.r * 255), int(newColor.g * 255), int(newColor.b * 255))
			colordata.append(convertedColor)
			colordata.sort()
			data.ownedColors = colordata
			ResourceSaver.save(data, datapath)
	
func _on_detector_body_entered(body):
	if body.is_in_group("player"):
		if body.sprinting:
			call_deferred("open")


func _on_test_timer_timeout():
	call_deferred("open")


func _on_killtimer_timeout():
	queue_free()
