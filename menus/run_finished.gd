extends Node2D

var datapath = "user://files/savedata.tres"
@onready var data = load(datapath)
@onready var multText = $multiplier
@onready var runText = $collected
@onready var totalText = $total

var runPoints = 0
var runEnding = 0
var totalPoints = 0

var lifetimePoints = 0
var runs = 0
var wins = 0
var losses = 0
var highestPoints = 0
var averagePoints = 0

const winMult = 1.2
const lossMult = 0.5

var deathMessage = "Cause of death: Unknown"

func _ready():
	#new data
	if data.deathSource != "unknown":
		deathMessage = data.deathSource
	$death.text = deathMessage
	runPoints = data.runPoints
	runEnding = data.runEnding
	totalPoints = data.collectedPoints
	#old data
	lifetimePoints = data.lifetimePoints
	runs = data.runs
	wins = data.wins
	losses = data.losses
	highestPoints = data.highestPoints
	
	if runPoints > highestPoints:
		data.highestPoints = runPoints
	
	lifetimePoints += runPoints
	data.lifetimePoints = lifetimePoints
	runs += 1
	data.runs = runs
	
	averagePoints = round(lifetimePoints / runs)
	data.averagePoints = averagePoints
	
	var newTotal = totalPoints
	runText.text = "Collected: "+str(runPoints)
	
	if runEnding == -1:
		var newPoints = int(runPoints*lossMult)
		multText.modulate = Color("darkred")
		multText.text = "Multiplier: "+str(lossMult)
		newTotal += newPoints
		losses += 1
		data.losses = losses
		if runPoints > 10:
			data.restock = true

	elif runEnding == 1:
		var newPoints = int(float(runPoints)*winMult)
		multText.modulate = Color("gold")
		multText.text = "Multiplier: "+str(winMult)
		newTotal += newPoints
		wins += 1
		data.wins = wins
		data.restock = true

	totalText.text = "New total: "+str(newTotal)
	data.collectedPoints = newTotal
	data.deathSource = "unknown"
	data.runPoints = 0
	data.runEnding = 0
	ResourceSaver.save(data, datapath)

var timer = 0
func _process(_delta):
	timer += 1
	if Input.is_action_just_pressed("space"):
		if timer > 15:
			_on_transfertimer_timeout()


func _on_transfertimer_timeout():
	get_tree().change_scene_to_file("res://menus/hub.tscn")
