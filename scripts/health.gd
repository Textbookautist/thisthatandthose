extends RigidBody2D


func _ready() -> void:
	add_to_group("resource")
	add_to_group("hp")

func _process(_delta: float) -> void:
	$spinme.rotation_degrees += 1



func _on_detection_body_entered(body) -> void:
	if body.is_in_group("player"):
		if body.hp < body.maxhp:
			body.healing(randi_range(1,3))
			queue_free()
