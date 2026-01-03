extends RigidBody2D


func _ready() -> void:
	add_to_group("resource")
	add_to_group("hp")

func _process(_delta: float) -> void:
	$spinme.rotation_degrees += 60*_delta

func destroy():
	$spinme.queue_free()
	queue_free()

func _on_detection_body_entered(body) -> void:
	if body.is_in_group("player"):
		if body.hp < body.maxhp:
			var noise = $noise.duplicate()
			body.add_child(noise)
			noise.connect("finished", Callable(noise, "queue_free"))
			noise.play()
			body.healing(randi_range(1,3))
			queue_free()
