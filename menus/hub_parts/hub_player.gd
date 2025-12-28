extends CharacterBody2D


@onready var data: Resource = load("res://files/savedata.tres")
var points = 0
var primeColor = null
var selectedColor = null
var ownedColors = []


func _ready():
	primeColor = data.primeColor
	if data.selectedColor == null:
		selectedColor = primeColor
	else:
		selectedColor = data.selectedColor

	ownedColors = data.ownedColors
	points = data.collectedPoints
	$base.color = selectedColor
