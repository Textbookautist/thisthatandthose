extends Node2D

@onready var data = load("res://files/savedata.tres")

var runPoints = 0
var runEnding = 0
var totalPoints = 0

const winMult = 1.2
const lossMult = 0.5


func _ready():
	runPoints = data.runPoints
	runEnding = data.runEnding
	totalPoints = data.collectedPoints
	
	var newTotal = totalPoints
	$collected.text = "Collected: "+str(runPoints)
	
	if runEnding == -1:
		var newPoints = int(runPoints*lossMult)
		$multiplier.modulate = Color("darkred")
		$multiplier.text = "Multiplier: "+str(lossMult)
		newTotal += newPoints

	elif runEnding == 1:
		var newPoints = int(float(runPoints)*winMult)
		$multiplier.modulate = Color("gold")
		$multiplier.text = "Multiplier: "+str(winMult)
		newTotal += newPoints

	$total.text = "New total: "+str(newTotal)
	data.collectedPoints = newTotal
	data.runPoints = 0
	data.runEnding = 0
	ResourceSaver.save(data, "res://files/savedata.tres")

var timer = 0
func _process(_delta):
	timer += 1
	if Input.is_action_just_pressed("space"):
		if timer > 15:
			_on_transfertimer_timeout()


func _on_transfertimer_timeout():
	get_tree().change_scene_to_file("res://menus/hub.tscn")
