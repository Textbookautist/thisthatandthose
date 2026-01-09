@tool
extends Node2D

var mapScore := 0
var pauseables := []
var paused = false
var gatesSpawned := 0

var datapath = "user://files/savedata.tres"

@onready var myData: Resource = load(datapath)
var selectedColor = null
var colorData = null
var colorDataArray = []
var seedArray = []
var oldPoints = 0

var utilities = []

@onready var tileScene = preload("res://scenes/tiles/tilePlus.tscn")

var playerScene = preload("res://scenes/player.tscn")

@onready var coinScene = preload("res://scenes/coin.tscn")
@onready var gateScene = preload("res://scenes/transportgate.tscn")
@onready var innerwallScene = preload("res://scenes/innerwall.tscn")
@onready var partWallScene = preload("res://scenes/partwall.tscn")
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
@onready var pommelerScene = preload("res://scenes/pommeler.tscn")
@onready var harvesTime = preload("res://scenes/harvest_time.tscn")
@onready var tileStripScene = preload("res://scenes/tilestrip.tscn")
@onready var jawScene = preload("res://scenes/jawtrap.tscn")
@onready var enemySpawner = preload("res://scenes/enemyspawner.tscn")
@onready var uTowerScene = preload("res://scenes/utility_tower.tscn")
@onready var uLever = preload("res://scenes/power_lever.tscn")
@onready var turretScene = preload("res://scenes/spectral_turret.tscn")



var sizes = [[5,6], [5,13], [9, 9]]


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

var tiletypes = ["mountain", "snow", "field", "aberrant", "gloom", "radiant", "random"]

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
	tiletypes.shuffle()
	tile.tileType = tiletypes[0]
	var value = sizes[0]
	
	tile.horizon = value[0]
	tile.depth = value[1]
	add_child(tile)


func _on_spawntimer_timeout():
	$Camera2D.queue_free()
	var player = playerScene.instantiate()
	player.maxhp = int(round(10 + (seedArray[0]*2)))
	if seedArray[6] != 0:
		var Val = seedArray[6]
		var floatti = float(Val/10)
		var newVal = 1.0+floatti
		player.speedBonus = newVal
	player.damageIgnoreChance = seedArray[2]
	player.dev = false
	player.global_position = Vector2(0,0)
	add_child(player)
	$spawntimer.queue_free()
