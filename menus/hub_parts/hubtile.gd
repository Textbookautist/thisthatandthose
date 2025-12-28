extends StaticBody2D

var color = null

func _ready():
	if color != null:
		$ColorRect.color = color
