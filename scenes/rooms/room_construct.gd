extends Node2D

var width = 1
var height = 1

var tileScene = preload("res://scenes/terrain_piece.tscn")

func _ready() -> void:
	var originTile = tileScene.instantiate()
	originTile.horizon = width
	originTile.depth = height
	add_child(originTile)
