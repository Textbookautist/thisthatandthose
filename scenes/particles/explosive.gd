extends CPUParticles2D

func _ready():
	pass

var rotations = 0
func _process(_delta):
	rotations += 1
	if rotations < 5 and rotations > 8:
		return
	if emitting != true:
		emitting = true
		

func _on_finished():
	queue_free()
