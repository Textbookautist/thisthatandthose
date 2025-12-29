@tool
extends Node2D

var mapScore := 0
var pauseables := []
var paused = false

var myData: Resource = load("res://files/savedata.tres")
var oldPoints = 0

var tileScene = preload("res://scenes/terrain_piece.tscn")

var playerScene = preload("res://scenes/player.tscn")

var sizes = [[5,6], [5,13], [9, 9]]
var types = ["mountain", "field", "snow"]
var coordinates = [Vector2(10,10), Vector2(-500, -500), Vector2(-300,600)]

var massive = [11, 11]

func victory():
	return
	
	
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
	oldPoints = myData.collectedPoints
	print("Old points: ", str(oldPoints))
	sizes = []
	for i in range(3):
		var list = makesize()
		sizes.append(list)
	for i in range(3):
		var index = i-1
		var tile = tileScene.instantiate()
		tile.horizon = sizes[index][0]
		tile.depth = sizes[index][1]
		if i == 1:
			tile.horizon = massive[0]
			tile.depth = massive[1]
		tile.tileType = types[index]
		tile.global_position = coordinates[index]
		add_child(tile)
		print("Tile has ", str(tile.neighbors.size()), " neighbors.")
	await get_tree().process_frame
	var player = playerScene.instantiate()
	player.dev = false
	player.global_position = Vector2(10, 10)
	add_child(player)
