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
		$ColorRect.size.x += 120*_delta
		$ColorRect.position.x -= 60*_delta
	else:
		$ColorRect.size.x -= 120*_delta
		$ColorRect.position.x += 60*_delta
	if phase >= 99:
		get_tree().change_scene_to_file("res://menus/run_finished.tscn")
	phase += 1
