extends StaticBody2D

var tileScene = preload("res://scenes/terrain_piece.tscn")

var base = null

var tileType = "base"
var horizon = 0
var depth = 0
var leftEdge = true
var rightEdge = true
var bottomEdge = true
var topEdge = true
var isFirst = true
var topRow = true
var firstColumn = true
var lastRow = false
var guarantee_gate = null

func _ready() -> void:
	add_to_group("terrainTile")
	
	
	if topEdge == false or topRow == false:
		$colTop.queue_free()
	if bottomEdge == false or topRow:
		if lastRow != true:
			$colBottom.queue_free()
	if rightEdge == false or firstColumn:
		$colRight.queue_free()
	if leftEdge == false:
		$colLeft.queue_free()
	
	base = $base
	match tileType:
		"snow": base.color = Color("white")
		"field": base.color = Color("green")
		"mountain": base.color = Color("darkgray")
	$top.visible = false
	
	if horizon != 0:
		buildH(horizon)
	if depth != 0:
		buildY(depth, horizon)
	#detectTiles()
	if guarantee_gate != null:
		var gate = await (load("res://scenes/transportgate.tscn")).instantiate()
		gate.twin = guarantee_gate
		guarantee_gate.twin = gate
		add_child(gate)
	spawnstuff()
	
	
			

func spawnstuff():
	if not isFirst:
		if randi_range(1,10) == 1:
			var gate = (load("res://scenes/transportgate.tscn")).instantiate()
			add_child(gate)
		elif randi_range(1,10) >= 9:
			var coin = (load("res://scenes/coin.tscn")).instantiate()
			add_child(coin)
		elif randi_range(1,10) == 10:
			var wall = (load("res://scenes/innerwall.tscn")).instantiate()
			add_child(wall)
			wall.global_position.y += 1
		elif randi_range(1,10) == 10:
			var bomb = (load("res://scenes/bomb.tscn")).instantiate()
			add_child(bomb)
		elif randi_range(1,10) == 10:
			var enemy = (load("res://scenes/enemy.tscn")).instantiate()
			enemy.global_position = global_position
			add_sibling(enemy)
		elif randi_range(1,10) == 10:
			var spiketrap = (load("res://scenes/spiketrap.tscn")).instantiate()
			add_child(spiketrap)
		elif randi_range(1,10) == 10:
			var cannon = (load("res://scenes/cannon.tscn")).instantiate()
			$center.add_child(cannon)
		elif randi_range(1,10) == 10:
			var shield = (load("res://scenes/shield_tile.tscn")).instantiate()
			$center.add_child(shield)
		elif randi_range(1,10) == 10:
			var spinner = (load("res://scenes/spinner.tscn")).instantiate()
			$center.add_child(spinner)
		elif randi_range(1,10) == 10:
			var health = (load("res://scenes/health.tscn")).instantiate()
			add_child(health)

func buildH(h):
	var newHor = h-1
	var tile = tileScene.instantiate()
	tile.tileType = tileType
	tile.horizon = newHor
	tile.isFirst = false
	tile.firstColumn = false
	if topRow:
		tile.topRow = true
		tile.topEdge = true
		tile.bottomEdge = false
	else:
		tile.topRow = false
		tile.topEdge = false
	if newHor == 0:
		tile.rightEdge = true
	else:
		tile.rightEdge = false
	if lastRow:
		tile.lastRow = true
		tile.topEdge = false
		tile.bottomEdge = true
	else:
		tile.bottomEdge = false
	tile.leftEdge = false
	tile.global_position = $connectors/right.global_position
	tile.global_position.x += 21
	add_sibling(tile)
	

func buildY(d, h):
	var newD = d-1
	var tile = tileScene.instantiate()
	tile.tileType = tileType
	tile.isFirst = false
	tile.firstColumn = true
	tile.topRow = false
	tile.rightEdge = false
	tile.topEdge = false
	if newD == 0:
		tile.bottomEdge = true
		tile.lastRow = true
	else:
		tile.bottomEdge = false
	tile.depth = newD
	tile.horizon = h
	
	tile.global_position = $connectors/bottom.global_position
	tile.global_position.y += 20
	add_sibling(tile)

var neighbors = []
func detectTiles():
	var surrounding = $tiledetection.get_overlapping_areas()
	for s in surrounding:
		print(str(s))
		if s == self:
			continue
		elif s.is_in_group("terrainTile"):
			neighbors.append(s)
			if s.neighbors.size() > 0:
				for i in s.neighbors:
					if i not in neighbors:
						neighbors.append(i)
