extends Node2D

var notificationType = "score"

var content = ""
func _ready():
	if notificationType == "healthbad":
		$textbox.modulate = Color("darkred")
	elif notificationType == "health":
		$textbox.modulate = Color("red")
	$textbox.text = content
	$ColorRect.size.x = $textbox.size.x
	$ColorRect.size.y = $textbox.size.y

var timesran = 0
func _process(_delta):
	
	global_position.y -= timesran*60*_delta
	timesran += 1
	
	if timesran >= 100:
		queue_free()
