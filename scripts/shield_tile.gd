extends StaticBody2D


func _on_cover_body_entered(body) -> void:
	if body.is_in_group("player") or body.is_in_group("alive"):
		body.invulnerability(true)




func _on_cover_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") or body.is_in_group("alive"):
		body.invulnerability(false)
