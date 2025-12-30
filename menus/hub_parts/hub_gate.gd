extends StaticBody2D

var playScene = "res://scenes/main_2.tscn"

var active = true

func toggle():
	active = !active

func _do_teleport():
	get_tree().change_scene_to_file(playScene)

func teleport():
	call_deferred("_do_teleport")

func _process(_delta):
	if active != true:
		$enter/CPUParticles2D.emitting = false
	else:
		$enter/CPUParticles2D.emitting = true

func _on_enter_body_entered(body):
	if active != true:
		return
	if body.is_in_group("player"):
		teleport()
