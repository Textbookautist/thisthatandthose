extends Node2D

var tileScene = preload("res://scenes/terrain_piece.tscn")

func _ready() -> void:
	var originTile = tileScene.instantiate()
	originTile.horizon = 3
	originTile.depth = 3
	add_child(originTile)
