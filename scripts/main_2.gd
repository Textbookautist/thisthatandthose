@tool
extends Node2D

var mapScore := 0
var pauseables := []
var paused = false

var datapath = "user://files/savedata.tres"

@onready var myData: Resource = load(datapath)
var selectedColor = null
var colorData = null
var colorDataArray = []
var seedArray = []
var oldPoints = 0

var tileScene = preload("res://scenes/tiles/tilePlus.tscn")

var playerScene = preload("res://scenes/player.tscn")

var sizes = [[5,6], [5,13], [9, 9]]
var types = ["mountain", "field", "snow"]

var massive = [11, 11]

func victory():
	return
	

var tiles = []

func makesize():
	return [randi_range(5,10), randi_range(5,10)]

func _process(_delta):
	if paused:
		for p in pauseables:
			if p:
				if p.paused != true:
					p.paused = true
			else:
				pauseables.erase(p)
	else:
		for p in pauseables:
			if p:
				if p.paused:
					p.paused = false
			else:
				pauseables.erase(p)


func _ready() -> void:
	
	selectedColor = myData.selectedColor
	if selectedColor == null:
		selectedColor = myData.primeColor
	colorData = Color8(int(selectedColor.r * 255), int(selectedColor.g * 255), int(selectedColor.b * 255))
	var colorDataArray_r = int(selectedColor.r * 255)
	colorDataArray.append(colorDataArray_r)
	var colorDataArray_g = int(selectedColor.g * 255)
	colorDataArray.append(colorDataArray_g)
	var colorDataArray_b = int(selectedColor.b * 255)
	colorDataArray.append(colorDataArray_b)
	
	for i in colorDataArray:
		var padded = str(i).pad_zeros(3)
		for c in padded:
			seedArray.append(int(c))
	print(str(seedArray))
	
	oldPoints = myData.collectedPoints
	#print("Old points: ", str(oldPoints))
	sizes = []
	for i in range(3):
		var list = makesize()
		sizes.append(list)

	var tile = tileScene.instantiate()
	tile.color = Color8(randi_range(0,255), randi_range(0,255), randi_range(0,255))
	var value = sizes[0]
	
	tile.horizon = value[0]
	tile.depth = value[1]
	add_child(tile)
	
	


func _on_spawntimer_timeout():
	$Camera2D.queue_free()
	var player = playerScene.instantiate()
	player.maxhp = int(round(10 + (seedArray[0]*2)))
	if seedArray[6] != 0:
		player.speedBonus = int(round(seedArray[6]))
	player.damageIgnoreChance = seedArray[2]
	player.dev = false
	player.global_position = Vector2(0,0)
	add_child(player)
	$spawntimer.queue_free()
