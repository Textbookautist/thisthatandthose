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

var waiting = false
var reloading = true
var status = 0
var hanging = 0
func _process(_delta):
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
