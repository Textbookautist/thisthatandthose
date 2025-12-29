extends Node2D

var datapath = "user://files/savedata.tres"
@onready var data = load(datapath)
@onready var base = $base

@onready var player = get_parent()

var colors = []

func close():
	player.changeColor(base.color)
	player.lockedInPlace = false
	queue_free()

var colM1 = 0
var colP1 = 0
var colIndex = 1

var selectedColor = null
var primecolor = null

func _ready():
	player.lockedInPlace = true
	
	var c = data.selectedColor
	base.color = c
	selectedColor = c
	
	primecolor = data.primeColor
	colors.append(primecolor)
	if primecolor != selectedColor:
		colors.append(selectedColor)
	else:
		colIndex = 0
	var colorsData = data.ownedColors
	
	for c1 in colorsData:
		
		var c8 = get_color(c1)
		if c8 in colors:
			continue
		colors.append(c8)
		#print("Added to colors: "+str(c8))

	if colorsData.size() == 2:
		$btns/colors/lefter.color = selectedColor
		$btns/colors/righter.color = selectedColor
	if colors.size() >= 3:
		$btns/colors/center.color = colors[1]
		$btns/colors/lefter.color = colors[0]
		$btns/colors/righter.color = colors[2]
	elif colors.size() == 1:
		$btns/colors/center.color = selectedColor
		$btns/colors/righter.color = selectedColor
		$base.color = selectedColor
		$btns/colors/lefter.color = selectedColor
	elif colors.size() == 2:
		$btns/colors/center.color = selectedColor
		if selectedColor != primecolor:
			$btns/colors/lefter.color = primecolor
			$btns/colors/righter.color = primecolor
		else:
			$btns/colors/lefter.color = colors[1]
			$btns/colors/righter.color = colors[1]
	$Label.text = "You own "+str(colors.size())+" colors"
	if colors.size() == 1:
		$Label.text = "You own "+str(colors.size())+" color"
	
	var total = 256 * 256 * 256
	var percentage = float(colorsData.size() + 1) / total * 100.0

	$tiplabel.text = "%d / %d : %.6f%%" % [
		colorsData.size() + 1,
		total,
		percentage
	]


func _process(_delta):
	$base.color = $btns/colors/center.color
	
	if Input.is_action_just_pressed("a"):
		_on_left_pressed()
		
	if Input.is_action_just_pressed("d"):
		_on_right_pressed()
	
	if Input.is_action_just_pressed("space"):
		close()
	
	

	var col = $btns/colors/center.color
	$rgbs/container/r_text.text = str(int(col.r * 255))
	$rgbs/container/g_text.text = str(int(col.g * 255))
	$rgbs/container/b_text.text = str(int(col.b * 255))

	

func get_color(value):
	var c: Color = value
	var c8: Color = Color8(int(c.r*255), int(c.g*255), int(c.b*255), int(c.a*255))
	return c8

func _on_close_pressed():
	close()

func change_index(amount):
	colIndex += amount

	# wrap main index
	if colIndex < 0:
		colIndex = colors.size() - 1
	elif colIndex >= colors.size():
		colIndex = 0

	# left index
	colM1 = colIndex - 1
	if colM1 < 0:
		colM1 = colors.size() - 1

	# right index
	colP1 = colIndex + 1
	if colP1 >= colors.size():
		colP1 = 0

	# apply
	$btns/colors/center.color = colors[colIndex]
	$btns/colors/lefter.color = colors[colM1]
	$btns/colors/righter.color = colors[colP1]



func _on_left_pressed():
	change_index(-1)


func _on_right_pressed():
	change_index(1)
