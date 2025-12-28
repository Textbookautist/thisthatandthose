extends StaticBody2D

@onready var changerScene = preload("res://menus/colorchanger.tscn")


func _on_detector_body_entered(body):
	if body.is_in_group("player"):
		var changer = changerScene.instantiate()
		body.add_child(changer)
