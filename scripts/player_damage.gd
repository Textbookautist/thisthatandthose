extends CPUParticles2D

var dead = false
func _ready():
	if dead:
		amount = 24
	gravity = Vector2(0,-10)
	emitting = true


func _process(_delta):
	gravity.y += 5.0
	modulate.a -= 0.01

func _on_finished():
	queue_free()
