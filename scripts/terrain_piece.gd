extends StaticBody2D

@onready var gateScene = preload("res://scenes/transportgate.tscn")
@onready var coinScene = preload("res://scenes/coin.tscn")
@onready var innerwallScene = preload("res://scenes/innerwall.tscn")
@onready var bombScene = preload("res://scenes/bomb.tscn")
@onready var enemyScene = preload("res://scenes/enemy.tscn")
@onready var spikeScene = preload("res://scenes/spiketrap.tscn")
@onready var cannonScene = preload("res://scenes/cannon.tscn")
@onready var shieldScene = preload("res://scenes/shield_tile.tscn")
@onready var spinnerScene = preload("res://scenes/spinner.tscn")
@onready var healthScene = preload("res://scenes/health.tscn")
@onready var sniperScene = preload("res://scenes/sniper.tscn")
@onready var healingShrineScene = preload("res://scenes/health_lantern.tscn")
@onready var colorChestScene = preload("res://scenes/color_loot_chest.tscn")
@onready var partWallScene = preload("res://scenes/partwall.tscn")

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
	if find_child("colBottom"):
		$colBottom.position.y = 26
	
	
			

func spawnstuff():
	if not isFirst:
		if randi_range(1,10) == 1:
			var gate = gateScene.instantiate()
			add_child(gate)
		elif randi_range(1,10) >= 9:
			var coin = coinScene.instantiate()
			add_child(coin)
		elif randi_range(1,10) == 10:
			var wall = innerwallScene.instantiate()
			add_child(wall)
			wall.global_position.y += 1
		elif randi_range(1,10) == 10:
			var bomb = bombScene.instantiate()
			add_child(bomb)
		elif randi_range(1,10) == 10:
			var enemy = enemyScene.instantiate()
			enemy.global_position = global_position
			add_sibling(enemy)
		elif randi_range(1,10) == 10:
			var spiketrap = spikeScene.instantiate()
			add_child(spiketrap)
		elif randi_range(1,10) == 10:
			var cannon = cannonScene.instantiate()
			$center.add_child(cannon)
		elif randi_range(1,10) == 10:
			var shield = shieldScene.instantiate()
			$center.add_child(shield)
		elif randi_range(1,10) == 10:
			var spinner = spinnerScene.instantiate()
			$center.add_child(spinner)
		elif randi_range(1,10) == 10:
			var health = healthScene.instantiate()
			add_child(health)
		elif randi_range(1,20) == 1:
			var sniper = sniperScene.instantiate()
			add_child(sniper)
		elif randi_range(1,20) == 1:
			var lantern = healingShrineScene.instantiate()
			add_child(lantern)
		elif randi_range(1,20) == 1:
			var chest = colorChestScene.instantiate()
			add_child(chest)
		elif randi_range(1,20 < 3):
			var wall = partWallScene.instantiate()
			add_child(wall)
			wall.position.y += 1

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
		#print(str(s))
		if s == self:
			continue
		elif s.is_in_group("terrainTile"):
			neighbors.append(s)
			if s.neighbors.size() > 0:
				for i in s.neighbors:
					if i not in neighbors:
						neighbors.append(i)
