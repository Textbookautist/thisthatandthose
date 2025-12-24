extends Node2D

var tileScene = preload("res://scenes/terrain_piece.tscn")

var playerScene = preload("res://scenes/player.tscn")

var sizes = [[2,6], [4,8], [6, 10]]
var types = ["mountain", "field", "snow"]
var coordinates = [Vector2(10,10), Vector2(-500, -500), Vector2(-300, 500)]

func _ready() -> void:
	for i in range(3):
		var index = i-1
		var tile = tileScene.instantiate()
		tile.horizon = sizes[index][0]
		tile.depth = sizes[index][1]
		tile.tileType = types[index]
		tile.global_position = coordinates[index]
		add_child(tile)
		print("Tile has ", str(tile.neighbors.size()), " neighbors.")
	
	var player = playerScene.instantiate()
	player.dev = true
	player.global_position = Vector2(-20, 10)
	add_child(player)
