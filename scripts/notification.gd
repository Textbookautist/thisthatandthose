extends Node2D


var content = ""
func _ready():
	$textbox.text = content
	$ColorRect.size.x = $textbox.size.x
	$ColorRect.size.y = $textbox.size.y

var timesran = 0
func _process(_delta):
	
	global_position.y -= timesran
	timesran += 1
	
	if timesran >= 100:
		queue_free()
