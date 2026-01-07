extends StaticBody2D

@onready var main = get_tree().root.get_child(0)
var selectedColor = null

var colorData = null

@onready var coinScene = main.coinScene
@onready var gateScene = main.gateScene
@onready var innerwallScene = main.innerwallScene
@onready var partWallScene = main.partWallScene
@onready var bombScene = main.bombScene
@onready var enemyScene = main.enemyScene
@onready var spikeScene = main.spikeScene
@onready var cannonScene = main.cannonScene
@onready var shieldScene = main.shieldScene
@onready var spinnerScene = main.spinnerScene
@onready var healthScene = main.healthScene
@onready var sniperScene = main.sniperScene
@onready var healingShrineScene = main.healingShrineScene
@onready var colorChestScene = main.colorChestScene
@onready var pommelerScene = main.pommelerScene
@onready var harvesTime = main.harvesTime
@onready var tileStripScene = main.tileStripScene
@onready var jawScene = main.jawScene
@onready var enemySpawner = main.enemySpawner


@onready var thistile = main.tileScene

@onready var base = $base


var originTile = true
var dontSpawnStuff = false
var dontGate = false

var horizon: int = 7
var depth: int = 7

var canCorridor = true

var isEdge = false
var edgeBottom = false
var edgeTop = false
var edgeLeft = false
var edgeRight = false

var tileType = "default"

var types = ["mountain", "snow", "field", "aberrant", "gloom", "radiant", "random"]

var color = Color("white")

func coloration():
	match tileType:
		"aberrant":
			base.color = Color8(200, 0, 200)
		"gloom":
			base.color = Color8(140, 90, 100)
		"radiant":
			base.color = Color8(255,255,0)
		"random":
			base.color = Color8(randi_range(0,255), randi_range(0,255), randi_range(0,255))
		"field":
			base.color = Color8(0,200,0)
		"mountain":
			base.color = Color8(100,100,100)
		"snow", "default":
			pass

func spawnstuff():
	var moveVal = 42
	
	for i in range(horizon):
		var index = i + 1
		var lilTile = thistile.instantiate()
		lilTile.color = color
		lilTile.originTile = false
		lilTile.dontGate = dontGate
		lilTile.tileType = tileType
		lilTile.horizon = 0
		lilTile.depth = depth
		lilTile.global_position = global_position
		lilTile.global_position.x -= moveVal*index
		add_sibling.call_deferred(lilTile)
		
		lilTile = thistile.instantiate()
		lilTile.color = color
		lilTile.originTile = false
		lilTile.dontGate = dontGate
		lilTile.tileType = tileType
		lilTile.horizon = 0
		lilTile.depth = depth
		lilTile.global_position = global_position
		lilTile.global_position.x += moveVal*index
		add_sibling.call_deferred(lilTile)
	
	for i in range(depth):
		var index = i + 1
		
		var lilTile = thistile.instantiate()
		lilTile.color = color
		lilTile.dontGate = dontGate
		lilTile.originTile = false
		lilTile.tileType = tileType
		lilTile.depth = 0
		lilTile.horizon = 0
		lilTile.global_position = global_position
		lilTile.global_position.y -= moveVal*index
		add_sibling.call_deferred(lilTile)
		
		lilTile = thistile.instantiate()
		lilTile.color = color
		lilTile.originTile = false
		lilTile.dontGate = dontGate
		lilTile.tileType = tileType
		lilTile.depth = 0
		lilTile.horizon = 0
		lilTile.global_position = global_position
		lilTile.global_position.y += moveVal*index
		add_sibling.call_deferred(lilTile)

	if originTile or dontSpawnStuff:
		pass
	else:
		if randi_range(1,30) == 1:
			call_deferred("queue_free")
		
		elif randi_range(1,100) > int(80 - seedArray[3]):
			var coin = coinScene.instantiate()
			coin.collectDistanceBonus = int(seedArray[5])
			add_child(coin)
			if randi_range(1,50) <= int(seedArray[4]):
				coin = coinScene.instantiate()
				coin.collectDistanceBonus = int(seedArray[6])
				add_child(coin)
				#print("a duplicate has spawned")
		
		elif randi_range(1,100) <= (10 + (seedArray[0]*2)):
			if dontGate != true:
				var gate = gateScene.instantiate()
				add_child(gate)
		
		elif randi_range(1,10) == 10:
			if randi_range(1,2) == 1:
				var wall = innerwallScene.instantiate()
				add_child(wall)
			else:
				var wall = partWallScene.instantiate()
				add_child(wall)
		
		elif randi_range(1,100) <= 10 + (seedArray[3]*2):
			var bomb = bombScene.instantiate()
			add_child(bomb)
			
		elif randi_range(1,10) == 10:
			var enemy = enemyScene.instantiate()
			add_child(enemy)
			
		elif randi_range(1,10) == 10:
			var spikes = spikeScene.instantiate()
			add_child(spikes)
			
		elif randi_range(1,100) <= 10 + (seedArray[6]*2):
			var cannon = cannonScene.instantiate()
			cannon.speedDecrease = 2.0 - (1.0 + float((seedArray[8]/10)))
			add_child(cannon)
		
		elif randi_range(1,100) <= 8 + (seedArray[4]):
			var shield = shieldScene.instantiate()
			add_child(shield)
	
		elif randi_range(1,100) <= 10 + (seedArray[1]+seedArray[4]) - seedArray[7]:
			var spinner = spinnerScene.instantiate()
			add_child(spinner)
			
		elif randi_range(1,100) <= 8 + (seedArray[6]):
			var health = healthScene.instantiate()
			add_child(health)
	
		elif randi_range(1,150) <= seedArray[0]+seedArray[3]+seedArray[6]:
			var sniper = sniperScene.instantiate()
			add_child(sniper)
		
		elif randi_range(1,250) <= 10 + (seedArray[3]):
			var shrine = healingShrineScene.instantiate()
			shrine.timeDecrease = seedArray[2]
			add_child(shrine)
		
		elif randi_range(1,250) <= 10 + (seedArray[6] - (seedArray[3]*2)):
			var chest = colorChestScene.instantiate()
			add_child(chest)
		
		elif randi_range(1,100) <= 9 + (seedArray[7]) - seedArray[5]:
			var pommeler = pommelerScene.instantiate()
			add_child(pommeler)
		
		elif randi_range(1,250) <=(seedArray[0] + seedArray[3] + seedArray[6]):
			var harvester = harvesTime.instantiate()
			harvester.pos = global_position
			add_child(harvester)
		
		elif randi_range(1,100) <= 10 + (seedArray[3]*5):
			var strip = tileStripScene.instantiate()
			strip.color = $base.color
			add_sibling(strip)
			strip.global_position = global_position
			call_deferred("queue_free")
		
		elif randi_range(1,100) <= 10 + seedArray[8] - seedArray[2]:
			var jaws = jawScene.instantiate()
			add_child(jaws)

		elif randi_range(1,100) <= 10 + seedArray[0]:
			var spawner = enemySpawner.instantiate()
			spawner.global_position = global_position
			spawner.wait_time = randf_range(15.0, 35.0)
			add_child(spawner)

var colorDataArray = []
var seedArray = []
func _ready():
	
	main.tiles.append(self)
	selectedColor = main.myData.selectedColor
	colorData = main.colorData
	colorDataArray = main.colorDataArray
	seedArray = main.seedArray
	
	if color == null:
		coloration()
	if tileType != null:
		coloration()
	
	add_to_group("terrain")
	call_deferred("spawnstuff")


func _on_safe_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("alive"):
		body.safeMove(self, 1)

func _on_safe_body_exited(body):
	if body.is_in_group("player") or body.is_in_group("alive"):
		body.safeMove(self, -1)
