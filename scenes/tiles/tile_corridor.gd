extends StaticBody2D

@onready var thisTile = preload("res://scenes/tiles/tile_corridor.tscn")
@onready var mastertile = preload("res://scenes/tiles/tilePlus.tscn")

var direction = "right"
var dir = Vector2(0,0)

var depth = 1
var horizon = 8
var masterSize = [2,1]
var hasMaster = true

var is_root = true
var last_tile = null

var color = Color("white")

var listOfTiles = []
func construct():
	var amount = 0
	if horizon > depth:
		amount = horizon
	else:
		amount = depth
	var moveAmount = 42
	for i in range(amount):
		var index = i + 1
		var tile = thisTile.instantiate()
		tile.is_root = false
		last_tile = tile
		listOfTiles.insert(0, tile)
		tile.listOfTiles = listOfTiles
		if horizon != 0:
			tile.horizon = 0
		if depth != 0:
			tile.depth = 0
		tile.global_position = global_position
		if dir.x > 0 and horizon != 0:
			tile.global_position.x += index * moveAmount
		elif dir.x < 0 and horizon != 0:
			tile.global_position.x -= index * moveAmount
		elif dir.y > 0 and depth != 0:
			tile.global_position.y += index * moveAmount
		elif dir.y < 0 and depth != 0:
			tile.global_position.y -= index * moveAmount
		add_sibling.call_deferred(tile)
		
	if hasMaster:
		await get_tree().process_frame
		last_tile.call_deferred("constructMaster")

func constructMaster():
	print("Begun to construct master room. corridor tile amount: "+str(listOfTiles))
	var x = masterSize[0]
	var y = masterSize[1]
	var originTile = mastertile.instantiate()
	originTile.horizon = x
	originTile.depth = y
	if randi_range(1,3) > 2:
		originTile.canCorridor = false
	if direction == "right" or direction == "left":
		var removables = []
		for i in range(x):
			if listOfTiles[i] == self:
				continue
			removables.append(listOfTiles[i])
		while removables.size() != 0:
			removables[0].queue_free()
			removables.erase(removables[0])
	elif direction == "up" or direction == "down":
		var removables = []
		for i in range(y):
			if listOfTiles[i] == self:
				continue
			removables.append(listOfTiles[i])
		while removables.size() != 0:
			removables[0].queue_free()
			removables.erase(removables[0])
	originTile.global_position = global_position
	add_sibling(originTile)
	#call_deferred("queue_free")
	
	

func _ready():
	listOfTiles.append(self)
	$ColorRect.color = color
	add_to_group("terrain")
	add_to_group("corridor")
	if direction == "none":
		depth = 0
		horizon = 0
		queue_free()
	elif direction == "left":
		depth = 0
		dir = Vector2(-1,0)
	elif direction == "right":
		depth = 0
		dir = Vector2(1, 0)
	elif direction == "up":
		horizon = 0
		dir = Vector2(0, -1)
	elif direction == "down":
		horizon = 0
		dir = Vector2(0, 1)
	
	if dir != Vector2(0,0) and is_root:
		construct()

func _on_safe_body_entered(body):
	if body.is_in_group("player"):
		body.safeMove(self, 1)



func _on_safe_body_exited(body):
	if body.is_in_group("player"):
		body.safeMove(self, -1)
