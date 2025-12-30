extends StaticBody2D

var needsRestock = false
var color = Color8(0,0,0)

var points = 0
var cost = 100
var datapath = "user://files/savedata.tres"
@onready var data = load(datapath)
@onready var box = $square/core
@onready var parent = get_parent().get_parent()

var hasStock = true
var wasRestock = false
func restock():
	wasRestock = true
	var randR = randi_range(0,255)
	var randG = randi_range(0,255)
	var randB = randi_range(0,255)
	color = Color8(randR, randG, randB)
	box.color = color
	data.restock = false
	data.restockTime = 60
	hasStock = true
	ResourceSaver.save(data, datapath)

func _ready():
	points = data.collectedPoints
	if hasStock:
		box.color = color
	else:
		if needsRestock != true:
			removeBox()
	if needsRestock:
		restock()
	#parent.signal_color()

func get_color():
	var c: Color = box.color
	var c8: Color = Color8(int(c.r*255), int(c.g*255), int(c.b*255), int(c.a*255))
	return c8

func _process(_delta):
	$square.rotation_degrees += randi_range(1,2)*60*_delta
	if displayed and hasStock:
		var boxColor = get_color()
		$colors/container/r/Label.text = str(int(boxColor.r*255))
		$colors/container/g/Label.text = str(int(boxColor.g*255))
		$colors/container/b/Label.text = str(int(boxColor.b*255))
		if Input.is_action_just_pressed("space"):
			if points >= cost:
				print("Buying colors")
				data.collectedPoints -= cost
				var c:Color = box.color
				var c8: Color = Color8(int(c.r*255), int(c.g*255), int(c.b*255), int(c.a*255))
				var ownedList = data.ownedColors
				ownedList.append(c8)
				ownedList.sort()
				data.ownedColors = ownedList
				ResourceSaver.save(data, datapath)
				parent.updatePoints(self)
				removeBox()
				

@onready var colorDisplay = $colors
@onready var costDisplay = $cost
var displayed = false
func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		displayed = true
		colorDisplay.visible = true
		costDisplay.visible = true
		box.color = get_color()

func _on_detection_body_exited(body):
	if body.is_in_group("player"):
		displayed = false
		colorDisplay.visible = false
		costDisplay.visible = false

func removeBox():
	$square.visible = false
	$detection.monitoring = false
	$colors.visible = false
	$cost.visible = false
	displayed = false
