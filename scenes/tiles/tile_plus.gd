extends StaticBody2D

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


@onready var thistile = preload("res://scenes/tiles/tilePlus.tscn")

var originTile = true
var dontSpawnStuff = false

var horizon = 7
var depth = 7

func _ready():
	add_to_group("terrain")
	var moveVal = 42
	for i in range(horizon):
		var index = i + 1
		var lilTile = thistile.instantiate()
		lilTile.originTile = false
		if originTile:
			lilTile.dontSpawnStuff = true
		lilTile.horizon = 0
		lilTile.depth = depth
		lilTile.global_position = global_position
		lilTile.global_position.x -= moveVal*index
		add_sibling.call_deferred(lilTile)
		
		lilTile = thistile.instantiate()
		lilTile.originTile = false
		lilTile.horizon = 0
		lilTile.depth = depth
		lilTile.global_position = global_position
		lilTile.global_position.x += moveVal*index
		add_sibling.call_deferred(lilTile)
	
	for i in range(depth):
		var index = i + 1
		var lilTile = thistile.instantiate()
		lilTile.originTile = false
		lilTile.depth = 0
		lilTile.horizon = 0
		lilTile.global_position = global_position
		lilTile.global_position.y -= moveVal*index
		add_sibling.call_deferred(lilTile)
		
		lilTile = thistile.instantiate()
		lilTile.originTile = false
		lilTile.depth = 0
		lilTile.horizon = 0
		lilTile.global_position = global_position
		lilTile.global_position.y += moveVal*index
		add_sibling.call_deferred(lilTile)

	if originTile or dontSpawnStuff:
		pass
	else:
		if randi_range(1,5) == 5:
			pass
		elif randi_range(1,10) == 1:
			var coin = coinScene.instantiate()
			add_child(coin)
		elif randi_range(1,13) == 1:
			var gate = gateScene.instantiate()
			add_child(gate)
		elif randi_range(1,10) == 10:
			if randi_range(1,2) == 1:
				var wall = innerwallScene.instantiate()
				add_child(wall)
			else:
				var wall = partWallScene.instantiate()
				add_child(wall)
		elif randi_range(1,10) == 10:
			var bomb = bombScene.instantiate()
			add_child(bomb)
		elif randi_range(1,10) == 10:
			var enemy = enemyScene.instantiate()
			add_child(enemy)
		elif randi_range(1,10) == 10:
			var spikes = spikeScene.instantiate()
			add_child(spikes)
		elif randi_range(1,10) == 10:
			var cannon = cannonScene.instantiate()
			add_child(cannon)
		elif randi_range(1,10) == 10:
			var shield = shieldScene.instantiate()
			add_child(shield)
		elif randi_range(1,10) == 10:
			var spinner = spinnerScene.instantiate()
			add_child(spinner)
		elif randi_range(1,10) == 10:
			var health = healthScene.instantiate()
			add_child(health)
		elif randi_range(1,10) == 10:
			var sniper = sniperScene.instantiate()
			add_child(sniper)
		elif randi_range(1,20) == 20:
			var shrine = healingShrineScene.instantiate()
			add_child(shrine)
		elif randi_range(1,20) == 20:
			var chest = colorChestScene.instantiate()
			add_child(chest)
