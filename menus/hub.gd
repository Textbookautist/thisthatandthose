extends Node2D

@onready var data: Resource = load("res://files/savedata.tres")

@onready var tile = preload("res://menus/hub_parts/hubtile.tscn")

var points = 0
var primeColor = null
var selectedColor = null
var ownedColors = []

func buildmain():
	var tiles = []
	var plusx = 0
	for i in range(10):
		var t = tile.instantiate()
		t.global_position = $tiles.global_position
		t.global_position.x += plusx
		t.color = Color("darkgray")
		$tiles.add_child(t)
		tiles.append(t)
		plusx += 42
	var plusy = 42
	for t in tiles:
		for i in range(9):
			var newT = tile.instantiate()
			newT.global_position = t.global_position
			newT.global_position.y += plusy
			newT.color = Color("darkgray")
			$tiles.add_child(newT)
			plusy += 42
		plusy = 42

func _ready():
	points = data.collectedPoints
	primeColor = data.primeColor
	selectedColor = data.selectedColor
	ownedColors = data.ownedColors
	
	buildmain()
