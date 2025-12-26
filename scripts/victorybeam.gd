extends Node2D


var parent = null
func _ready() -> void:
	add_to_group("admin")
	parent = get_parent()

var phase = 0
func _process(_delta: float) -> void:
	if parent.invulnerable != true:
		parent.invulnerable = true
	
	if phase < 50:
		$ColorRect.size.x += 2
		$ColorRect.position.x -= 1
	else:
		$ColorRect.size.x -= 2
		$ColorRect.position.x += 1
	if phase >= 99:
		get_tree().quit()
	phase += 1
