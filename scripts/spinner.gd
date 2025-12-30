extends StaticBody2D

var blades = []

var active = true

@onready var root = get_tree().root.get_child(0)
var paused = false

func toggle():
	active = !active

func _ready() -> void:
	root.pauseables.append(self)
	add_to_group("obstacle")
	add_to_group("trap")
	add_to_group("hazard")
	for i in range(3):
		if randi_range(1,3):
			var clone = $spinner/spinner1.duplicate()
			clone.rotation += 90*i
			$spinner.add_child(clone)
	for blade in $spinner.get_children():
		blades.append(blade)
	var pitch = randf_range(0.9,1.1)
	$spinnoise.pitch_scale = pitch
	$spinnoise.play()

func _process(_delta: float) -> void:
	if paused:
		return
	if active != true:
		$CPUParticles2D.emitting = true
		return
	for b in blades:
		b.rotation_degrees -= 15



func _on_damager_body_entered(body: Node2D) -> void:
	if active != true:
		return
	if body.is_in_group("player") or body.is_in_group("alive"):
		body.take_damage(1, "Spinner takedown")


func _on_spinnoise_finished():
	if active:
		$spinnoise.play()
